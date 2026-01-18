import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/company_model.dart';
<<<<<<< HEAD
import 'package:flutter_naver_map/flutter_naver_map.dart';
=======
import '../login/signup_screen.dart';
>>>>>>> feature/login

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({super.key});

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  final TextEditingController _searchController = TextEditingController();

  // 가짜 회사 리스트 (나중엔 서버에서 받아옵니다)
  final List<CompanyModel> _allCompanies = [
    CompanyModel(id: 1, name: "제이에스 유통", address: "시흥시 정왕동 123", ownerName: "김사장"),
    CompanyModel(id: 2, name: "시흥 사이언스", address: "안산시 단원구 456", ownerName: "이대표"),
    CompanyModel(id: 3, name: "정왕 테크", address: "시흥시 배곧동 789", ownerName: "박이사"),
    CompanyModel(id: 4, name: "지스 무역", address: "서울시 강남구 000", ownerName: "최회장"),
  ];

  // 화면에 보여줄 검색 결과 리스트
  List<CompanyModel> _filteredCompanies = [];

  @override
  void initState() {
    super.initState();
    _filteredCompanies = _allCompanies; // 처음엔 모든 회사 보여주기
  }

  // 검색 기능
  void _runSearch(String keyword) {
    setState(() {
      if (keyword.isEmpty) {
        _filteredCompanies = _allCompanies;
      } else {
        _filteredCompanies = _allCompanies
            .where((company) => company.name.contains(keyword)) // 이름에 글자가 포함되면 찾음
            .toList();
      }
    });
  }

  // 가입 신청 화면 연결
  void _goToSignUp(CompanyModel company) {
    // 선택한 회사 정보를 들고 회원가입 화면으로 이동!
    Get.to(() => SignUpScreen(company: company));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("내 회사 찾기")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 검색창
            TextField(
              controller: _searchController,
              onChanged: _runSearch, // 글자 칠 때마다 검색 실행
              decoration: const InputDecoration(
                labelText: "회사 이름 검색",
                hintText: "예: 시흥, 안산",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // 리스트 보여주기
            Expanded(
              child: _filteredCompanies.isEmpty
                  ? const Center(child: Text("검색된 회사가 없습니다."))
                  : ListView.builder(
                itemCount: _filteredCompanies.length,
                itemBuilder: (context, index) {
                  final company = _filteredCompanies[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: const Icon(Icons.business, size: 40, color: Colors.indigo),
                      title: Text(company.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("${company.address}\n대표: ${company.ownerName}"),
                      isThreeLine: true,
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _goToSignUp(company), // 누르면 가입 신청
                    ),
                  );
                },
              ),
            ),
            NaverMap(
              options: const NaverMapViewOptions(
                initialCameraPosition: NCameraPosition(
                  target: NLatLng(37.5665, 126.9780), // 서울시청
                  zoom: 15,
                ),
              ),
              onMapReady: (controller) {
                print("네이버 지도 로드 완료");
              },
            ),
          ],
        ),
      ),
    );
  }
}