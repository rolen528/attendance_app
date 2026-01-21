import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import '../../controllers/user_controller.dart';
import '../../services/company_service.dart';
import '../../models/company_model.dart';
import '../login/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final userController = Get.find<UserController>();
  final companyService = CompanyService();

  // FutureBuilder 사용 X 데이터를 담을 변수를 직접 만들기.
  CompanyModel? _company;
  bool _isLoading = true; // 로딩 상태 체크

  // 거리 계산용 변수
  double _distance = 0.0;
  bool _isWithinRange = false;

  // 위치 추적 스트림 구독권 (나중에 취소하기 위해 변수로 둠)
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    // 1. 화면 켜지자마자 회사 정보부터 가져옴
    _loadCompanyData();
  }

  @override
  void dispose() {
    // 화면 꺼지면 위치 추적도 종료 (메모리 절약)
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  // 데이터 가져오는 함수
  void _loadCompanyData() async {
    final companyData = await companyService.getCompanyById(userController.user!.companyId);

    if (mounted) {
      setState(() {
        _company = companyData;
        _isLoading = false; // 로딩 끝!
      });

      // 데이터 가져오면, 바로 위치 추적 로직 시작 (지도와 상관없이 백그라운드에서 계산)
      if (_company != null) {
        _startLocationTracking(_company!.latitude, _company!.longitude);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPresident = userController.user?.role == 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(isPresident ? "직원 근태 관리" : "출퇴근 체크"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              userController.clearUser();
              Get.offAll(() => const LoginScreen());
            },
          )
        ],
      ),
      body: isPresident
          ? _buildPresidentBody()
          : _buildEmployeeBody(),
    );
  }

  // 1. [사장님 화면]
  Widget _buildPresidentBody() {
    // (기존 코드와 동일)
    final List<Map<String, String>> dummyLogs = [
      {"name": "한경열", "time": "08:55", "status": "출근 완료"},
      {"name": "최성현", "time": "08:58", "status": "출근 완료"},
    ];
    return ListView.separated(
      itemCount: dummyLogs.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(dummyLogs[index]["name"]!),
          subtitle: Text(dummyLogs[index]["time"]!),
          trailing: Text(dummyLogs[index]["status"]!),
        );
      },
    );
  }

  // 2. [직원 화면] FutureBuilder 없이 깔끔해진 구조
  Widget _buildEmployeeBody() {
    // 로딩 중이면 뺑뺑이
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    // 데이터 없으면 에러 메시지
    if (_company == null) {
      return const Center(child: Text("회사 정보를 불러올 수 없습니다."));
    }

    // 데이터가 확실히 있는 상태에서 지도 그리기
    final companyLatLng = NLatLng(_company!.latitude, _company!.longitude);

    return Stack(
      children: [
        // (1) 네이버 지도 (setState가 불려도 재로딩 x)
        NaverMap(
          options: NaverMapViewOptions(
            initialCameraPosition: NCameraPosition(target: companyLatLng, zoom: 16),
            locationButtonEnable: true,
            contentPadding: const EdgeInsets.only(bottom: 220),
          ),
          onMapReady: (controller) {
            final marker = NMarker(id: 'company_loc', position: companyLatLng);
            final circle = NCircleOverlay(
              id: 'attendance_zone',
              center: companyLatLng,
              radius: 100,
              color: Colors.green.withOpacity(0.2),
              outlineColor: Colors.green,
            );
            controller.addOverlay(marker);
            controller.addOverlay(circle);

            // 지도 시점만 내 위치 따라가게 설정 (거리 계산 로직과는 별개)
            controller.setLocationTrackingMode(NLocationTrackingMode.follow);
          },
        ),

        // (2) 하단 컨트롤러 (여기만 숫자가 바뀜)
        Positioned(
          bottom: 30,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_company!.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 5),
                        Text(
                          _isWithinRange ? "출근 가능 지역입니다 📍" : "회사와 너무 멉니다 🚫",
                          style: TextStyle(
                            color: _isWithinRange ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "${_distance.toStringAsFixed(0)}m",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isWithinRange
                        ? () => Get.snackbar("성공", "✅ 출근 완료!",
                          backgroundColor: Colors.indigoAccent, colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                          margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isWithinRange ? Colors.blue : Colors.grey,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      _isWithinRange ? "출근하기" : "회사 근처로 이동해주세요",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 위치 추적 로직 (distanceFilter: 0 적용)
  void _startLocationTracking(double companyLat, double companyLon) async {
    // 권한 체크
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    print("📡 GPS 감시 시작! (목표: $companyLat, $companyLon)");

    // 스트림 시작 (변수에 담아둠)
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0, // 0으로 설정해서 아주 미세한 움직임도 감지
      ),
    ).listen((Position position) {

      double dist = Geolocator.distanceBetween(
        position.latitude, position.longitude,
        companyLat, companyLon,
      );

      // 로그 출력 (터미널 확인용)
      print("📍 내 위치 이동함! 거리: ${dist.toStringAsFixed(1)}m");

      if (mounted) {
        setState(() {
          _distance = dist;
          _isWithinRange = dist <= 100;
        });
      }
    });
  }
}