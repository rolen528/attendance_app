// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
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
  CompanyLocationModel? company;
  bool isLoading = true;
  NaverMapController? _mapController;
  Position? _currentPosition; // 현재 위치
  bool _isInRange = false; // 반경 내 여부

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

      Get.snackbar("오류", result['msg'],
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // 위치 권한 요청
  Future<bool> _requestLocationPermission() async {
    var status = await Permission.location.status;

    if (status.isDenied) {
      status = await Permission.location.request();
    }

    if (status.isPermanentlyDenied) {
      Get.snackbar(
        "권한 필요",
        "설정에서 위치 권한을 허용해주세요.",
        snackPosition: SnackPosition.BOTTOM,
        mainButton: TextButton(
          onPressed: () => openAppSettings(),
          child: const Text("설정 열기"),
        ),
      );
      return false;
    }

    return status.isGranted;
  }

  // 현재 위치 가져오기 및 거리 계산
  Future<void> _getCurrentLocation() async {
    if (company == null) return;

    // 권한 확인
    bool hasPermission = await _requestLocationPermission();
    if (!hasPermission) return;

    try {
      // 현재 위치 가져오기
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
      });

      print('===== 현재 위치 =====');
      print('위도: ${position.latitude}, 경도: ${position.longitude}');

      // 회사 위치와의 거리 계산 (미터 단위)
      double distance = Geolocator.distanceBetween(
        double.parse(company!.centerLat),
        double.parse(company!.centerLon),
        position.latitude,
        position.longitude,
      );

      setState(() {
        _isInRange = distance <= 50; // 50미터 이내인지 확인
      });

      print('회사와의 거리: ${distance.toStringAsFixed(2)}m');
      print('반경 내 위치: $_isInRange');
      print('========================');

      // 지도에 현재 위치 마커 추가
      if (_mapController != null) {
        final currentMarker = NMarker(
          id: 'current_location',
          position: NLatLng(position.latitude, position.longitude),
          icon: const NOverlayImage.fromAssetImage('assets/images/marker_current.png'), // 커스텀 아이콘 (선택)
          caption: NOverlayCaption(text: '현재 위치'),
        );
        _mapController!.addOverlay(currentMarker);

        // 현재 위치로 카메라 이동
        _mapController!.updateCamera(
          NCameraUpdate.fromCameraPosition(
            NCameraPosition(
              target: NLatLng(position.latitude, position.longitude),
              zoom: 17,
            ),
          ),
        );
      }

      // 반경 내 여부에 따라 알림
      if (_isInRange) {
        Get.snackbar(
          "출퇴근 가능",
          "회사 반경 내에 있습니다. (${distance.toStringAsFixed(1)}m)",
          backgroundColor: Colors.greenAccent,
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          "출퇴근 불가",
          "회사에서 너무 멉니다. (${distance.toStringAsFixed(1)}m)",
          backgroundColor: Colors.orangeAccent,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      print('위치 가져오기 실패: $e');
      Get.snackbar(
        "오류",
        "위치 정보를 가져올 수 없습니다.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
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
          ? const Center(child: CircularProgressIndicator())
          : company == null
          ? const Center(
        child: Text(
          "회사 정보를 불러올 수 없습니다.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : Stack(
        children: [
          // 지도
          NaverMap(
            options: NaverMapViewOptions(
              initialCameraPosition: NCameraPosition(
                target: NLatLng(
                  double.parse(company!.centerLat),
                  double.parse(company!.centerLon),
                ),
                zoom: 15,
              ),
            ),
            onMapReady: (controller) async {
              _mapController = controller;

              print("===== 네이버 지도 로드 완료 =====");
              print("회사: ${company!.name}");
              print("위치: ${company!.centerLat}, ${company!.centerLon}");
              print("========================");

              final center = NLatLng(
                double.parse(company!.centerLat),
                double.parse(company!.centerLon),
              );

              // 반경 50미터 원 그리기
              final circle = NCircleOverlay(
                id: 'company_area',
                center: center,
                radius: 50,
                color: Colors.blue.withOpacity(0.3),
                outlineColor: Colors.blue,
                outlineWidth: 2,
              );
              controller.addOverlay(circle);

              // 회사 마커
              final marker = NMarker(
                id: 'company_marker',
                position: center,
                caption: NOverlayCaption(text: company!.name),
              );
              controller.addOverlay(marker);

              print("반경 50m 원 그리기 완료");
            },
          ),

          // 하단 버튼 영역
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                // 상태 표시
                if (_currentPosition != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _isInRange ? Colors.green : Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _isInRange ? "✓ 출퇴근 가능 영역" : "✗ 출퇴근 불가 영역",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 10),

                // 현재 위치 확인 버튼
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _getCurrentLocation,
                    icon: const Icon(Icons.my_location, color: Colors.white),
                    label: const Text(
                      "현재 위치 확인",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}