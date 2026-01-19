import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
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

    // 사장님인지 직원인지 확인
    final isPresident = userController.user?.role == 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(isPresident ? "직원 근태 관리" : "출퇴근 체크"), // 제목도 다르게
        centerTitle: true,
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
      // 역할에 따라 다른 화면 보여주기!
      body: isPresident
          ? _buildPresidentBody() // 사장님이면 리스트
          : _buildEmployeeBody(companyService, userController), // 직원이면 지도
    );
  }

  // 1. [사장님 화면] 직원들 출퇴근 기록 리스트
  Widget _buildPresidentBody() {
    // 나중엔 서버에서 진짜 데이터를 받기.
    final List<Map<String, String>> dummyLogs = [
      {"name": "한경열", "time": "08:55", "status": "출근 완료"},
      {"name": "최성현", "time": "08:58", "status": "출근 완료"},
      {"name": "이과장", "time": "09:01", "status": "지각"},
      {"name": "김대리", "time": "-", "status": "미출근"},
    ];

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.blue[50],
          width: double.infinity,
          child: const Text(
            "📅 2025년 5월 20일 (오늘)",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: dummyLogs.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final log = dummyLogs[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(log["name"]![0]), // 이름 첫 글자
                ),
                title: Text(log["name"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("출근 시간: ${log["time"]}"),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: log["status"] == "지각" ? Colors.red[100] :
                    log["status"] == "미출근" ? Colors.grey[200] : Colors.green[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    log["status"]!,
                    style: TextStyle(
                      color: log["status"] == "지각" ? Colors.red :
                      log["status"] == "미출근" ? Colors.grey : Colors.green[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // 2. [직원 화면] 기존에 만든 지도 + 출근 체크 기능
  Widget _buildEmployeeBody(CompanyService companyService, UserController userController) {
    return FutureBuilder<CompanyModel?>(
      future: companyService.getCompanyById(userController.user!.companyId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("회사 위치 정보를 불러올 수 없습니다."));
        }

        final company = snapshot.data!;
        final companyLatLng = NLatLng(company.latitude, company.longitude);

        return NaverMap(
          options: NaverMapViewOptions(
            initialCameraPosition: NCameraPosition(
              target: companyLatLng,
              zoom: 16,
            ),
            locationButtonEnable: true,
            consumeSymbolTapEvents: false,
          ),
          onMapReady: (controller) {
            final marker = NMarker(id: 'company_loc', position: companyLatLng);
            final circle = NCircleOverlay(
              id: 'attendance_zone',
              center: companyLatLng,
              radius: 100,
              color: Colors.green.withOpacity(0.2),
              outlineColor: Colors.green,
              outlineWidth: 2,
            );

            controller.addOverlay(marker);
            controller.addOverlay(circle);

            final infoWindow = NInfoWindow.onMarker(
                id: 'company_info', text: "${company.name}\n(반경 100m)");
            marker.openInfoWindow(infoWindow);
          },
        );
      },
    );
  }
}