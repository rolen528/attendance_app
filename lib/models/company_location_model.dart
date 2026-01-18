
class CompanyLocationModel {
  final int id;
  final String name;           // 회사명
  final String ownerName;      // 회사 대표님 이름
  final String code;           // 회사 코드
  final String centerLat;      // 중심 위도
  final String centerLon;      // 중심 경도
  final int status;            // 상태 (1: 사용 중)
  final String createdAt;      // 생성일

  CompanyLocationModel({
    required this.id,
    required this.name,
    required this.ownerName,
    required this.code,
    required this.centerLat,
    required this.centerLon,
    required this.status,
    required this.createdAt,
  });

  // 서버 통신용 (JSON → CompanyModel)
  factory CompanyLocationModel.fromJson(Map<String, dynamic> json) {
    return CompanyLocationModel(
      id: json['id'],
      name: json['name'],
      ownerName: json['owner_name'],
      code: json['code'],
      centerLat: json['center_lat'],
      centerLon: json['center_lon'],
      status: json['status'],
      createdAt: json['created_at'],
    );
  }
}