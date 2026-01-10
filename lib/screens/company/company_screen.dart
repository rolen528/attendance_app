// lib/screens/company/company_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/company_model.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({super.key});

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  final TextEditingController _searchController = TextEditingController();

  // 가짜 회사 데이터 (나중에 서버에서 받아올 것들)
  final List<CompanyModel> _allCompanies = [
    CompanyModel(id: 1, name: "대박 유통", address: "시흥시 정왕동", ownerName: "김사장"),
    CompanyModel(id: 2, name: "안산 정밀", address: "안산시 단원구", ownerName: "박대표"),
    CompanyModel(id: 3, name: "시흥 테크", address: "시흥시 배곧동", ownerName: "이이사"),
  ];

  // 검색 결과 보여줄 리스트
  List<CompanyModel> _filteredCompanies = [];

  @override
  void initState() {
    super.initState();
    _filteredCompanies = _allCompanies; // 처음엔 다 보여줌
  }

  // 검색 로직
  void _searchCompany(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCompanies = _allCompanies;
      } else {
        _filteredCompanies = _allCompanies
            .where((company) => company.name.contains(query))
            .toList();
      }
    });
  }

  // 가입 신청 팝업
  void _showJoinDialog(CompanyModel company) {
    Get.defaultDialog(
      title: "가입 신청",
      middleText: "${company.name}에 입사 신청하시겠습니까?\n(사장님 승인 후 로그인 가능)",
      textConfirm: "신청하기",
      textCancel: "취소",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back(); // 다이얼로그 닫기
        Get.back(); // 로그인 화면으로 돌아가기
        Get.snackbar("완료", "가입 신청이 완료되었습니다. 승인을 기다려주세요.",
            backgroundColor: Colors.green, colorText: Colors.white);
      },
    );
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
              onChanged: _searchCompany, // 글자 칠 때마다 검색 실행
              decoration: const InputDecoration(
                labelText: "회사 이름 검색",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // 회사 리스트
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
                      leading: const Icon(Icons.business, size: 40),
                      title: Text(company.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("${company.address} | 대표: ${company.ownerName}"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _showJoinDialog(company),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}