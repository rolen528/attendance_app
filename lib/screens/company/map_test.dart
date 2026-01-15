// lib/screens/company/company_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MapTest extends StatefulWidget {
  const MapTest({super.key});

  @override
  State<MapTest> createState() => _MapTest();
}

class _MapTest extends State<MapTest> {
  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("지도 테스트")),
      body: NaverMap(
        options: const NaverMapViewOptions(
          initialCameraPosition: NCameraPosition(
            target: NLatLng(37.3385885, 126.7361061), // 서울시청
            zoom: 15,
          ),
        ),
        onMapReady: (controller) {
          print("네이버 지도 로드 완료");
        },
      ),
    );
  }
}