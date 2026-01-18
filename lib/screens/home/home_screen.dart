// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../login/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("출퇴근 (메인)"),
        actions: [
          // 로그아웃 버튼
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // 로그아웃 알림
              Get.snackbar("로그아웃", "로그인 화면으로 돌아갑니다.",
                  snackPosition: SnackPosition.BOTTOM);
              // 로그인 화면으로 이동 (뒤로가기 기록 삭제)
              Get.offAll(() => const LoginScreen());
            },
          )
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map_outlined, size: 100, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              "지도 자리",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}