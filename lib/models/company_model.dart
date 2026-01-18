// lib/models/company_model.dart

class CompanyModel {
  final int id;
  final String name;      // 회사
  final String address;   // 주소
  final String ownerName; // 회사 대표님 이름

  CompanyModel({
    required this.id,
    required this.name,
    required this.address,
    required this.ownerName,
  });

  // 나중에 서버 통신용
  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      ownerName: json['owner_name'],
    );
  }
}