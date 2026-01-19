import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/auth_service.dart'; // 로그인 엔진 가져오기
import '../home/home_screen.dart'; // 로그인 성공시
import '../../controllers/user_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 1. 입력창 컨트롤러 (전화번호, 비번)
  final _phoneController = TextEditingController();
  final _pwController = TextEditingController();

  // 2. 우리가 만든 로그인 엔진 준비
  final _authService = AuthService();

  // 3. 로딩 중인지 체크하는 변수
  bool _isLoading = false;

  // 로그인 버튼 눌렀을 때 실행되는 함수
  void _handleLogin() async {
    // 빈칸 검사
    if (_phoneController.text.isEmpty || _pwController.text.isEmpty) {
      Get.snackbar("알림", "전화번호와 비밀번호를 모두 입력해주세요.", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // 로딩 시작
    setState(() {
      _isLoading = true;
    });

    // 엔진에 로그인 요청 (전화번호, 비번 던져줌)
    final result = await _authService.login(
        _phoneController.text,
        _pwController.text
    );

    // 로딩 끝
    setState(() {
      _isLoading = false;
    });

    // 결과 확인
    if (result['success']) {
      // 로그인 성공했으니, 유저 정보를 전역 저장소에 등록
      // (Get.put을 쓰면 앱 어디서든 UserController를 찾을 수 있음)
      final userController = Get.put(UserController());
      userController.setUser(result['user']); // 유저 정보 저장 꾹!

      // 성공 -> 메인 화면으로 이동
      Get.offAll(() => const HomeScreen());
    } else {
      // 실패 (비번 틀림, 승인 대기 등) -> 에러 메시지 띄우기
      Get.snackbar(
        "로그인 실패",
        result['msg'] ?? "오류가 발생했습니다.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 로고나 앱 이름
              const Icon(Icons.check_circle_outline, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              const Text(
                "출퇴근 체크",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),

              // 전화번호 입력
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "휴대폰 번호",
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // 비밀번호 입력
              TextField(
                controller: _pwController,
                obscureText: true, // 글자 가리기
                decoration: const InputDecoration(
                  labelText: "비밀번호",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),

              // 로그인 버튼
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin, // 로딩 중이면 클릭 금지
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white) // 로딩 중이면 뺑글이
                      : const Text("로그인하기", style: TextStyle(fontSize: 16)),
                ),
              ),

              const SizedBox(height: 16),

              // 회원가입 버튼 등 (일단 텍스트 버튼으로)
              TextButton(
                onPressed: () {
                  // 나중에 회원가입 화면 연결
                  // Get.to(() => const SignupScreen());
                },
                child: const Text("아직 계정이 없으신가요? 회원가입"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}