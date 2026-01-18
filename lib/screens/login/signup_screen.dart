// lib/screens/login/signup_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../models/company_model.dart';
import '../../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  final CompanyModel company; // 선택한 회사 정보를 받아옴

  const SignUpScreen({super.key, required this.company});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _pwController = TextEditingController();

  // 가입 요청하는 함수
  void _submitSignUp() {
    String name = _nameController.text.trim();
    String phone = _phoneController.text.trim();
    String pw = _pwController.text.trim();

    if (name.isEmpty || phone.isEmpty || pw.isEmpty) {
      Get.snackbar("알림", "모든 정보를 입력해주세요.", snackPosition: SnackPosition.BOTTOM);
      return;
    }


    // 서버 연결시, 수정이 필요할 듯?

    Get.defaultDialog(
      title: "신청 완료",
      middleText: "${widget.company.name}에\n${name}님의 가입 신청이 전송되었습니다.\n\n사장님 승인 후 로그인이 가능합니다.",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back(); // 팝업 닫기
        Get.offAllNamed('/'); // 로그인 화면(처음)으로 완전히 돌아가기
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("회원가입 정보 입력")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 선택된 회사 정보 보여주기
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                children: [
                  const Text("입사 신청할 회사", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 5),
                  Text(widget.company.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 이름 입력
            const Text("이름", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: "본명을 입력하세요 (예: 홍길동)"),
            ),
            const SizedBox(height: 20),

            // 전화번호 입력
            const Text("휴대폰 번호", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(hintText: "숫자만 입력 (예: 01012345678)"),
            ),
            const SizedBox(height: 20),

            // 비밀번호 입력
            const Text("비밀번호 설정", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _pwController,
              obscureText: true,
              decoration: const InputDecoration(hintText: "로그인에 사용할 비밀번호"),
            ),
            const SizedBox(height: 40),

            // 가입하기 버튼
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitSignUp,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text("가입 신청 보내기", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}