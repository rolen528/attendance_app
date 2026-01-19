import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart'; // ★ 네이버 지도
import '../../controllers/user_controller.dart';
import '../../services/company_service.dart';
import '../../models/company_model.dart';
import '../login/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final companyService = CompanyService();

    return Scaffold(
      appBar: AppBar(
        title: Text(userController.user?.role == 0 ? "사장님 모드" : "출퇴근 체크"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              userController.clearUser();
              Get.offAll(() => const LoginScreen());
            },
          )
        ],
      ),
      body: FutureBuilder<CompanyModel?>(
        future: companyService.getCompanyById(userController.user!.companyId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("회사 위치 정보를 불러올 수 없습니다."));
          }

          final company = snapshot.data!;

          // 네이버 지도 좌표 객체 생성
          final companyLatLng = NLatLng(company.latitude, company.longitude);

          return NaverMap(
            // 1. 초기 카메라 위치 설정
            options: NaverMapViewOptions(
              initialCameraPosition: NCameraPosition(
                target: companyLatLng,
                zoom: 15, // 10~21 (클수록 확대)
              ),
              locationButtonEnable: true, // 내 위치 버튼 표시
            ),

            // 2. 지도가 준비되면 실행되는 함수 (마커 꽂기)
            onMapReady: (controller) {
              // 마커 생성
              final marker = NMarker(
                id: 'company_loc',
                position: companyLatLng,
              );

              // 마커에 글자 띄우기 (필수 x)
              final infoWindow = NInfoWindow.onMarker(
                  id: 'company_info',
                  text: company.name
              );

              // 지도에 마커 추가
              controller.addOverlay(marker);

              // 마커 누르면 말풍선 띄우기
              marker.openInfoWindow(infoWindow);
            },
          );
        },
      ),
    );
  }
}