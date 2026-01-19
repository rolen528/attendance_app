// lib/services/company_service.dart
import '../models/company_model.dart';

class CompanyService {
  // 가짜 회사 데이터베이스 (나중엔 서버에서 받아옴)
  final List<CompanyModel> _dummyCompanies = [
    CompanyModel(
      id: 100,
      name: "대박 금형",
      address: "경기도 시흥시 정왕동 123-4",
      ownerName: "최성현",
      bizNum: "123-45-67890",
      code: "1111",
      // 지도를 띄울 좌표 (예시 데이터 시흥 정왕동 근처)
      latitude: 37.3496,
      longitude: 126.7335,
    ),
    CompanyModel(
      id: 200,
      name: "안산 정밀",
      address: "경기도 안산시 단원구 원곡동 567",
      ownerName: "박대표",
      bizNum: "222-22-22222",
      code: "2222",
      // 지도를 띄울 좌표 (예시 데이터 안산역 근처)
      latitude: 37.3264,
      longitude: 126.7892,
    ),
  ];

  // ID로 회사 정보(위치 포함)를 찾아내는 기능
  Future<CompanyModel?> getCompanyById(int companyId) async {
    await Future.delayed(const Duration(milliseconds: 500)); // 로딩 흉내

    try {
      return _dummyCompanies.firstWhere((company) => company.id == companyId);
    } catch (e) {
      return null; // 회사를 못 찾음
    }
  }
}