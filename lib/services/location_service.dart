// // lib/services/auth_service.dart
// import '../models/company_model.dart';
//
// class AuthService {
//   // Company List(dummy)
//   // code는 임시로 지정. 변경될지도 (중복 불가)
//   // status도 TINYINT(3)로 바꿔서 사용하는게 어떨지 고민이 필요해보임(현재는 VARCHAR(10))
//   // 0: 사용대기, 1: 사용 중, 2: 사용중지
//   final List<Map<String, dynamic>> _companyDb = [
//     {
//       "id": 1,
//       "name": "경기과학기술대학교",
//       "owner_name": "허남용",
//       "code": "CAV24D",
//       "center_lat": "37.337935148087496",
//       "center_lon": "126.73584990254035",
//       "status": 1 //사용 중,
//       "created_at": "2026-01-11 21:37:05"
//     },
//     {
//     "id": 2,
//     "name": "미남컴퍼니",
//     "owner_name": "최성현",
//     "code": "AGB72S",
//     "center_lat": "37.337935148087496",
//     "center_lon": "126.73584990254035",
//     "status": 1 //사용 중,
//     "created_at": "2026-01-11 21:37:05"
//     },
//     {
//     "id": 3,
//     "name": "한남컴퍼니",
//     "owner_name": "박정윤",
//     "code": "JLP25V",
//     "center_lat": "37.480343786513195",
//     "center_lon": "126.9492897690589",
//     "status": 1 //사용 중,
//     "created_at": "2026-01-11 21:37:05"
//     },
//   ];
//
//   // 위치 확인
// Future<Map<String, dynamic>> location(int company_id) async {
//     // 1초 동안 로딩하는 척 (서버 통신 흉내)
//     await Future.delayed(const Duration(seconds: 1));
//
//     try {
//       // CompanyList에서 유저리스트에서 전달받은 company_id로 조회
//       final companyData = _companyDb.firstWhere(
//             (company) => company['id'] == company_id,
//         orElse: () => {}, // 없으면 빈 데이터
//       );
//
//       if (companyData.isEmpty) {
//         return {'success': false, 'msg': '회사가 없습니다.'};
//       }
//
//       // 데이터 모델로 변환
//       final company = companyModel.fromJson(companyData);
//
//       // 상태 체크 (승인 대기중이거나 퇴사자면 로그인 막음)
//       if (company.status == 0) return {'success': false, 'msg': '관리자 승인 대기 중입니다.'};
//       if (company.status == 1) return {'success': false, 'msg': '가입이 거절되었습니다.'};
//
//       // 통과!
//       return {'success': true, 'company': company};
//
//     } catch (e) {
//       return {'success': false, 'msg': '알 수 없는 오류가 발생했습니다.'};
//     }
//   }
// }