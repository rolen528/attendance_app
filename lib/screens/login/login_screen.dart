// lib/screens/login/login_screen.dart
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';
import '../company/company_screen.dart';
import '../home/home_screen.dart';
import '../company/create_company_screen.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController(); // 전화번호 입력기
  final _pwController = TextEditingController();    // 비번 입력기
  final AuthService _authService = AuthService();   // 가짜 서버 데이터 가져오기

  void _handleLogin() async {
    String phone = _phoneController.text.trim();
    String pw = _pwController.text.trim();

    if (phone.isEmpty || pw.isEmpty) {
      Get.snackbar("알림", "정보를 모두 입력해주세요.", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // 로딩창 on
    Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false
    );

    // 로그인 시도
    final result = await _authService.login(phone, pw);

    // 로딩창 off
    Get.back();

    if (result['success']) {
      UserModel user = result['user'];
      // 성공 알림
      Get.snackbar("로그인 성공", "${user.name}님 환영합니다!",
          backgroundColor: Colors.greenAccent, snackPosition: SnackPosition.TOP);
      // 화면 이동
      Get.offAll(() => const HomeScreen());

    } else {
      // 실패 알림
      Get.snackbar("로그인 실패", result['msg'],
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              const Text("출퇴근 체크", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),

              // 전화번호 입력
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.number, // only 키보드 숫자
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly // 숫자만 입력
                ],
                decoration: const InputDecoration(
                  labelText: "휴대폰 번호 (숫자만 입력)", // 안내 문구 변경
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                  hintText: "01012345678", // 힌트 텍스트 추가
                ),
              ),
              const SizedBox(height: 16),

              // 비밀번호 입력
              TextField(
                controller: _pwController,
                obscureText: true, // 비번 안 보이게
                decoration: const InputDecoration(
                  labelText: "비밀번호",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 24),

              // 로그인 버튼
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text("로그인", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),

              // 회원가입
              const SizedBox(height: 10), //  버튼 사이 간격

              // 회원가입 버튼
              TextButton(
                onPressed: () {
                  // 하단에서 올라오는 선택창 (Bottom Sheet)
                  Get.bottomSheet(
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(20),
                      height: 250, // 높이 적당히
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("회원가입 유형 선택",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),

                          // 선택 1: 사장님
                          ListTile(
                            leading: const Icon(Icons.store, size: 40, color: Colors.indigo),
                            title: const Text("사장님으로 시작하기"),
                            subtitle: const Text("회사를 새로 등록하고 관리합니다."),
                            onTap: () {
                              Get.back(); // 창 닫고
                              Get.to(() => const CreateCompanyScreen()); // 회사 생성 화면으로!
                            },
                          ),
                          const Divider(), // 구분선

                          // 선택 2: 직원
                          ListTile(
                            leading: const Icon(Icons.person_search, size: 40, color: Colors.blue),
                            title: const Text("직원으로 시작하기"),
                            subtitle: const Text("이미 등록된 회사를 찾아 가입합니다."),
                            onTap: () {
                              Get.back(); // 창 닫고
                              Get.to(() => const CompanyScreen()); // 회사 검색 화면으로!
                            },
                          ),
                        ],
                      ),
                    ),
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                  );
                },
                child: const Text("처음이신가요? 회원가입"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}