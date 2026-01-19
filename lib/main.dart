// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/login/login_screen.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

void main() async {
  // 1. 플러터 엔진 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // 2. 네이버 지도 초기화 (API 키를 넣기!)
  await NaverMapSdk.instance.initialize(
      clientId: "f4z9kzyi7q", // 인증키
      onAuthFailed: (ex) {
        print("네이버 지도 인증 실패: $ex");
      }
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // GetX를 쓰려면 MaterialApp 대신 GetMaterialApp을 써야 합니다.
    return GetMaterialApp(
      title: '출퇴근 앱',
      debugShowCheckedModeBanner: false, // 오른쪽 위 'Debug' 띠 제거
      theme: ThemeData(
        useMaterial3: false, // 기존 스타일 유지
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(), // <--- 시작 화면을 로그인 화면으로 지정!
    );
  }
}