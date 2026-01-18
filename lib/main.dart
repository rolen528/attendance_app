// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/login/login_screen.dart';
import 'screens/company/map_test.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'config/api_keys.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final naverMap = FlutterNaverMap();
  await naverMap.init(
    clientId: ApiKeys.naverMapClientId,
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