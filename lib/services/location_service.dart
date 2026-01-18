// lib/services/location_service.dart
import '../models/company_location_model.dart';

class LocationService {
  // Company List(dummy)
  // code는 임시로 지정. 변경될지도 (중복 불가)
  // status도 TINYINT(3)로 바꿔서 사용하는게 어떨지 고민이 필요해보임(현재는 VARCHAR(10))
  // 0: 사용대기, 1: 사용 중, 2: 사용중지
  final List<Map<String, dynamic>> _companyDb = [
    {
      "id": 1,
      "name": "경기과학기술대학교",
      "owner_name": "허남용",
      "code": "CAV24D",
      "center_lat": "37.337935148087496",
      "center_lon": "126.73584990254035",
      "status": 1, //사용 중,
      "created_at": "2026-01-11 21:37:05"
    },
    {
      "id": 2,
      "name": "미남컴퍼니",
      "owner_name": "최성현",
      "code": "AGB72S",
      "center_lat": "37.337935148087496",
      "center_lon": "126.73584990254035",
      "status": 1, //사용 중,
      "created_at": "2026-01-11 21:37:05"
    },
    {
      "id": 3,
      "name": "한남컴퍼니",
      "owner_name": "박정윤",
      "code": "JLP25V",
      "center_lat": "37.481347557849",
      "center_lon": "126.95266114974201",
      "status": 1, //사용 중,
      "created_at": "2026-01-11 21:37:05"
    },
  ];

  // 회사 정보 가져오기
  Future<Map<String, dynamic>> getCompanyById(int companyId) async {
    // 서버 통신 흉내 (0.5초 딜레이)
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      // company_id로 회사 찾기
      final companyData = _companyDb.firstWhere(
            (company) => company['id'] == companyId,
        orElse: () => {}, // 없으면 빈 데이터
      );

      if (companyData.isEmpty) {
        return {'success': false, 'msg': '회사 정보를 찾을 수 없습니다.'};
      }

      final company = CompanyLocationModel.fromJson(companyData);

      // 상태 체크 (사용 중지된 회사면 막음)
      if (company.status == 0) {
        return {'success': false, 'msg': '사용 대기 중인 회사입니다.'};
      }
      if (company.status == 2) {
        return {'success': false, 'msg': '사용 중지된 회사입니다.'};
      }

      // 성공하면 여기서 리턴
      return {'success': true, 'company': company};

    } catch (e) {
      return {'success': false, 'msg': '회사 정보를 불러오는 중 오류가 발생했습니다.'};
    }
  }
}