// lib/screens/company/company_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/company_model.dart';
import '../login/signup_screen.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({super.key});

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  final TextEditingController _searchController = TextEditingController();

  // (추가) 팝업창에서 쓸 입장 코드 입력기
  final TextEditingController _codeController = TextEditingController();

  // 가짜 데이터 (아까 수정한 bizNum, code 포함된 버전)
  final List<CompanyModel> _allCompanies = [
    CompanyModel(id: 1, name: "대박 유통", address: "시흥시 정왕동 123", ownerName: "김사장", bizNum: "123-45-67890", code: "1111"),
    CompanyModel(id: 2, name: "안산 정밀", address: "안산시 단원구 456", ownerName: "박대표", bizNum: "222-22-22222", code: "2222"),
    CompanyModel(id: 3, name: "시흥 테크", address: "시흥시 배곧동 789", ownerName: "이이사", bizNum: "333-33-33333", code: "7777"),
  ];

  List<CompanyModel> _filteredCompanies = [];

  @override
  void initState() {
    super.initState();
    _filteredCompanies = _allCompanies;
  }

  void _runSearch(String keyword) {
    setState(() {
      if (keyword.isEmpty) {
        _filteredCompanies = _allCompanies;
      } else {
        _filteredCompanies = _allCompanies
            .where((company) => company.name.contains(keyword))
            .toList();
      }
    });
  }

  // ★★★ (새로 만든 함수) 입장 코드 확인 팝업 ★★★
  void _showCodeDialog(CompanyModel company) {
    _codeController.clear(); // 팝업 열 때마다 입력창 비우기

    Get.defaultDialog(
      title: "보안 확인",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      content: Column(
        children: [
          const Text("사내 공지된 입장 코드를 입력하세요."),
          const SizedBox(height: 10),
          TextField(
            controller: _codeController,
            obscureText: true, // 비밀번호처럼 가리기
            keyboardType: TextInputType.number, // 숫자 키패드
            decoration: const InputDecoration(
              hintText: "코드 4자리 (예: 1111)",
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
            ),
          ),
        ],
      ),
      textConfirm: "확인",
      textCancel: "취소",
      confirmTextColor: Colors.white,
      onConfirm: () {
        // 코드 검사 로직
        if (_codeController.text == company.code) {
          // 정답! -> 팝업 닫고 -> 회원가입 화면으로 이동
          Get.back();
          Get.to(() => SignUpScreen(company: company));
        } else {
          // 땡! -> 안내 메시지
          Get.snackbar("오류", "입장 코드가 일치하지 않습니다.",
              backgroundColor: Colors.redAccent, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
        }
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
            TextField(
              controller: _searchController,
              onChanged: _runSearch,
              decoration: const InputDecoration(
                labelText: "회사 이름 검색",
                hintText: "예: 시흥, 안산",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
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
                      subtitle: Text(company.address),
                      trailing: const Icon(Icons.lock_outline, color: Colors.grey), // 자물쇠 아이콘으로 변경

                      // ★★★ 클릭하면 팝업 함수 실행 ★★★
                      onTap: () => _showCodeDialog(company),
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