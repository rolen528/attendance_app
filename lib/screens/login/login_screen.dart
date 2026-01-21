import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/user_controller.dart';
// import '../../models/company_model.dart'; //
import '../company/company_screen.dart';
import '../company/create_company_screen.dart'; // 사장님 가입 화면
import 'signup_screen.dart'; // 직원 가입 화면

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    final idController = TextEditingController();
    final pwController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              const Text(
                "출퇴근 체크",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),

              TextField(
                controller: idController,
                decoration: const InputDecoration(
                  labelText: "휴대폰 번호 (ID)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone_android),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              TextField(
                controller: pwController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "비밀번호",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    userController.login(idController.text, pwController.text);
                  },
                  child: const Text("로그인", style: TextStyle(fontSize: 16)),
                ),
              ),

              const SizedBox(height: 20),

              // 회원가입 버튼 영역
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("계정이 없으신가요?"),
                  TextButton(
                    onPressed: () {
                      // 1. 사장 vs 직원 선택 팝업 띄우기
                      Get.bottomSheet(
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 40),
                          child: SafeArea(
                            child: SingleChildScrollView(
                              child: Column(
                                // ★ [핵심 수정] 내용물 크기만큼만 차지해라! (이게 없으면 화면 끝까지 늘어나려 함)
                                mainAxisSize: MainAxisSize.min,

                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "회원가입 유형을 선택해주세요",
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 20),

                                  // [선택 1] 사장님으로 시작하기
                                  ListTile(
                                    leading: const Icon(Icons.store, color: Colors.blue),
                                    title: const Text("사장님으로 가입"),
                                    subtitle: const Text("회사를 등록하고 직원을 관리합니다."),
                                    onTap: () {
                                      Get.back(); // 팝업 닫기
                                      Get.to(() => const CreateCompanyScreen());
                                    },
                                  ),

                                  // [선택 2] 직원으로 시작하기
                                  ListTile(
                                    leading: const Icon(Icons.badge, color: Colors.green),
                                    title: const Text("직원으로 가입"),
                                    subtitle: const Text("회사에 입사 신청을 합니다."), // 균형 맞춤
                                    onTap: () {
                                      Get.back(); // 팝업 닫기
                                      Get.to(() => const CompanyScreen());
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        isDismissible: true, // 배경 클릭시 닫힘
                      );
                    },
                    child: const Text("회원가입"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}