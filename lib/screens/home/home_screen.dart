// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import '../login/login_screen.dart';
import '../../models/user_model.dart';
import '../../models/company_location_model.dart';
import '../../services/location_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocationService _locationService = LocationService();
  CompanyLocationModel? company; // 회사 정보 (nullable)
  bool isLoading = true; // 로딩 상태

  @override
  void initState() {
    super.initState();
    _loadCompanyData();
  }

  // 회사 정보 불러오기
  void _loadCompanyData() async {
    final UserModel user = Get.arguments;

    print('===== 받아온 유저 정보 =====');
    print('회사ID: ${user.company_id}');
    print('전화번호: ${user.phone}');
    print('이름: ${user.name}');
    print('========================');

    // 회사 정보 조회
    final result = await _locationService.getCompanyById(user.company_id);

    if (result['success']) {
      setState(() {
        company = result['company'];
        isLoading = false;
      });

      print('===== 받아온 회사 정보 =====');
      print(company);
      print('========================');
    } else {
      setState(() {
        isLoading = false;
      });

      // 에러 메시지 표시
      Get.snackbar("오류", result['msg'],
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(company != null ? "출퇴근 (${company!.name})" : "출퇴근 (메인)"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Get.snackbar("로그아웃", "로그인 화면으로 돌아갑니다.",
                  snackPosition: SnackPosition.BOTTOM);
              Get.offAll(() => const LoginScreen());
            },
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // 로딩 중
          : company == null
          ? const Center(
        child: Text(
          "회사 정보를 불러올 수 없습니다.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : NaverMap(
        options: NaverMapViewOptions(
          initialCameraPosition: NCameraPosition(
            target: NLatLng(
              double.parse(company!.centerLat), // String → double 변환
              double.parse(company!.centerLon),
            ),
            zoom: 15,
          ),
        ),
        onMapReady: (controller) {
          print("===== 네이버 지도 로드 완료 =====");
          print("회사: ${company!.name}");
          print("위치: ${company!.centerLat}, ${company!.centerLon}");
          print("========================");
        },
      ),
    );
  }
}