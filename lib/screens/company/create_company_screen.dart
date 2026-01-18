// lib/screens/company/create_company_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// ★ 주소 검색 화면 import (파일이 있어야 함!)
import '../../utils/address_search.dart';

class CreateCompanyScreen extends StatefulWidget {
  const CreateCompanyScreen({super.key});

  @override
  State<CreateCompanyScreen> createState() => _CreateCompanyScreenState();
}

class _CreateCompanyScreenState extends State<CreateCompanyScreen> {
  // 입력 컨트롤러들
  final _nameController = TextEditingController();    // 회사명
  final _ownerController = TextEditingController();   // 대표자명
  final _addressController = TextEditingController(); // 주소
  final _bizNumController = TextEditingController();  // 사업자번호
  final _codeController = TextEditingController();    // 입장코드(비번)

  // 등록 완료 버튼 눌렀을 때 실행되는 함수
  void _submitCreate() {
    // 1. 빈칸 검사
    if (_nameController.text.isEmpty ||
        _ownerController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _bizNumController.text.isEmpty ||
        _codeController.text.isEmpty) {
      Get.snackbar("알림", "모든 정보를 입력해주세요.", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // 2. 사업자 번호 길이 검사 (단순 체크)
    if (_bizNumController.text.length != 10) {
      Get.snackbar("오류", "사업자 등록번호 10자리를 정확히 입력해주세요.",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    // 3. (가상) 서버 전송 및 성공 처리
    Get.defaultDialog(
      title: "등록 완료",
      middleText: "[${_nameController.text}] 회사가 생성되었습니다.\n\n이제 직원들에게 아래 코드를 알려주세요.\n\n입장 코드: ${_codeController.text}",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back(); // 팝업 닫기
        Get.back(); // 로그인 화면으로 돌아가기
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("우리 회사 등록하기")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("회사 기본 정보"),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "회사 이름",
                hintText: "예: 대박 유통",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _ownerController,
              decoration: const InputDecoration(
                labelText: "대표자 성함",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // ▼▼▼ [주소 찾기 기능 부활!] ▼▼▼
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _addressController,
                    readOnly: true, // 직접 수정 금지
                    decoration: const InputDecoration(
                      labelText: "회사 주소",
                      hintText: "주소 찾기 버튼을 눌러주세요",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    // 주소 검색 화면으로 이동 (AddressSearch)
                    // 만약 빨간줄이 뜨면 import가 제대로 되었는지,
                    // lib/utils/address_search.dart 파일이 있는지 확인하세요.
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddressSearch()),
                    );

                    // 결과 받아와서 넣기
                    if (result != null) {
                      setState(() {
                        String addr = result['roadAddress'] ?? result['jibunAddress'] ?? "";
                        _addressController.text = addr;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    backgroundColor: Colors.grey[800],
                  ),
                  child: const Text("주소 찾기", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            // ▲▲▲ 주소 찾기 끝 ▲▲▲

            const SizedBox(height: 30),

            _buildSectionTitle("보안 설정 (중요)"),
            TextField(
              controller: _bizNumController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10), // 최대 10자리 제한
              ],
              decoration: const InputDecoration(
                labelText: "사업자 등록번호 (숫자 10자리)",
                hintText: "0000000000",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.verified_user_outlined),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Column(
                children: [
                  const Text("직원들이 가입할 때 사용할 암호를 설정하세요.",
                      style: TextStyle(fontSize: 12, color: Colors.brown)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _codeController,
                    keyboardType: TextInputType.number, // 숫자 키패드
                    decoration: const InputDecoration(
                      labelText: "입장 코드 (비밀번호)",
                      hintText: "예: 1234",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.vpn_key),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // 등록 버튼
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitCreate,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                child: const Text("회사 생성하고 시작하기", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 소제목 스타일 꾸미기용 함수
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
    );
  }
}