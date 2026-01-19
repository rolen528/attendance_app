// lib/models/company_model.dart

class CompanyModel {
  final int id;
  final String name;      // 회사 이름
  final String address;   // 주소
  final String ownerName; // 대표자 이름
  final String bizNum;    // 사업자 등록번호 (10자리)
  final String code;      // 우리 회사만의 입장 코드 (암호)
  final double latitude;  // 위도
  final double longitude; // 경도

  CompanyModel({
    required this.id,
    required this.name,
    required this.address,
    required this.ownerName,
    required this.bizNum,
    required this.code,
    this.latitude = 0.0,
    this.longitude = 0.0,
  });

  // 나중에 서버랑 통신할 때 쓸 기능
  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      ownerName: json['owner_name'],
      bizNum: json['biz_num'],
      code: json['code'],
      latitude: json['center_lat'] ?? 0.0,
      longitude: json['center_lon'] ?? 0.0,
    );
  }
}