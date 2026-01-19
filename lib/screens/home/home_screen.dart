import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/user_controller.dart';
import '../../services/company_service.dart';
import '../../models/company_model.dart';
import '../login/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. 내 정보 저장소(UserController) 찾기
    final userController = Get.find<UserController>();

    // 2. 회사 정보 조회용 서비스 준비
    final companyService = CompanyService();

    return Scaffold(
      appBar: AppBar(
        // 사장님(0)인지 직원(1)인지에 따라 제목 다르게 표시 ( 상단 앱 바 )
        title: Text(userController.user?.role == 0 ? "사장님 모드" : "직원 모드"),
        centerTitle: true,
        actions: [
          // 로그아웃 버튼
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              userController.clearUser(); // 내 정보 비우기
              Get.snackbar("로그아웃", "안녕히 가세요!", snackPosition: SnackPosition.BOTTOM);
              Get.offAll(() => const LoginScreen()); // 로그인 화면으로 이동
            },
          )
        ],
      ),
      body: Center(
        child: FutureBuilder<CompanyModel?>(
          // 3. 내 companyId를 가지고 회사 정보(좌표 포함)를 서버에 요청
          future: companyService.getCompanyById(userController.user!.companyId),

          builder: (context, snapshot) {
            // (1) 로딩 중
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            // (2) 데이터가 없을 때 (에러 혹은 잘못된 ID)
            if (!snapshot.hasData || snapshot.data == null) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.red),
                  SizedBox(height: 10),
                  Text("회사 정보를 찾을 수 없습니다."),
                ],
              );
            }

            // (3) 데이터 도착 성공
            final company = snapshot.data!;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 회사 이름
                Text(
                  company.name,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // 회사 주소
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    company.address,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ),

                const SizedBox(height: 30),

                // 좌표 데이터 확인용 카드
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.blue[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text("📍 지도 띄울 좌표 확인", style: TextStyle(fontWeight: FontWeight.bold)),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("위도(Lat): ${company.latitude}"),
                            Text("경도(Lon): ${company.longitude}"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                const Icon(Icons.map_outlined, size: 80, color: Colors.blue),
                const SizedBox(height: 10),
                const Text(
                  "위 좌표에 지도가 그리기.",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}