import 'package:flutter/material.dart'; // 로딩창(CircularProgressIndicator) 쓰려면 필요
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../screens/home/home_screen.dart';
import '../services/auth_service.dart';

class UserController extends GetxController {
  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);
  final AuthService _authService = AuthService();

  UserModel? get user => _currentUser.value;

  void setUser(UserModel user) {
    _currentUser.value = user;
  }

  void clearUser() {
    _currentUser.value = null;
  }

  void login(String phoneInput, String pw) async {
    // 1. 입력 확인
    if (phoneInput.isEmpty || pw.isEmpty) {
      Get.snackbar(
        "입력 오류",
        "아이디와 비밀번호를 입력해주세요.",
        backgroundColor: Colors.orange, colorText: Colors.white, // 눈에 띄게!
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // ★ [추가] 로딩 시작! (사용자가 답답하지 않게 뺑뺑이 돌리기)
    Get.dialog(
      const Center(child: CircularProgressIndicator()), // 화면 중앙에 로딩 표시
      barrierDismissible: false, // 로딩 중엔 딴 거 못 누르게
    );

    // 2. 서버(AuthService)에 검사 요청
    final result = await _authService.login(phoneInput, pw);

    // ★ [추가] 로딩 끝! (결과 나왔으니 뺑뺑이 닫기)
    Get.back();

    // 3. 결과 처리
    if (result['success']) {
      // 성공!
      UserModel loggedInUser = result['user'];
      setUser(loggedInUser);

      // ★ [추가] "환영합니다" 메시지 띄우기
      Get.snackbar(
        "로그인 성공",
        "${loggedInUser.name}님 환영합니다!",
        backgroundColor: Colors.green, colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );

      // 홈으로 이동
      Get.offAll(() => const HomeScreen());

    } else {
      // 실패! (비번 틀림, 승인 대기 등)
      Get.snackbar(
        "로그인 실패",
        result['msg'], // AuthService가 준 에러 메시지 그대로 출력
        backgroundColor: Colors.red, colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}