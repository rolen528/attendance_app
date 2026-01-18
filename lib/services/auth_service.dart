// lib/services/auth_service.dart
import '../models/user_model.dart';

class AuthService {
  // 가짜 회원 명부 (나중에 실제 서버로 대체됨)
  final List<Map<String, dynamic>> _dummyDb = [
    {
      "id": 1,
      "company_id": 100,
      "name": "최성현",
      "phone": "01011111111",
      "password": "1234",
      "role": 0, // 관리자
      "status": 2, // 정상 승인됨
    },
    {
      "id": 2,
      "company_id": 100,
      "name": "박정윤",
      "phone": "01022222222",
      "password": "1234",
      "role": 1, // 직원
      "status": 2, // 정상 승인됨
    },
    {
      "id": 3,
      "company_id": 200,
      "name": "손흥민",
      "phone": "01033333333",
      "password": "1234",
      "role": 1,
      "status": 0, // 승인 대기중 (로그인 못함)
    }
  ];

  // 로그인 기능
  Future<Map<String, dynamic>> login(String phone, String password) async {
    // 1초 동안 로딩하는 척 (서버 통신 흉내)
    await Future.delayed(const Duration(seconds: 1));

    try {
      // 명부에서 전화번호와 비번이 일치하는 사람 찾기
      final userData = _dummyDb.firstWhere(
            (user) => user['phone'] == phone && user['password'] == password,
        orElse: () => {}, // 없으면 빈 데이터
      );

      if (userData.isEmpty) {
        return {'success': false, 'msg': '아이디 또는 비밀번호를 확인해주세요.'};
      }

      // 데이터 모델로 변환
      final user = UserModel.fromJson(userData);

      // 상태 체크 (승인 대기중이거나 퇴사자면 로그인 막음)
      if (user.status == 0) return {'success': false, 'msg': '관리자 승인 대기 중입니다.'};
      if (user.status == 1) return {'success': false, 'msg': '가입이 거절되었습니다.'};

      // 통과!
      return {'success': true, 'user': user};

    } catch (e) {
      return {'success': false, 'msg': '알 수 없는 오류가 발생했습니다.'};
    }
  }
}