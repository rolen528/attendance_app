// lib/models/user_model.dart

class UserModel {
  final int id;
  final String name;
  final String phone;
  final int role;   // 0: 관리자(사장), 1: 직원
  final int status; // 0: 대기, 1: 거절, 2: 승인(정상)

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    required this.status,
  });

  // 서버에서 받은 데이터를 앱에서 쓸 수 있게 변환하는 기능
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      role: json['role'],
      status: json['status'],
    );
  }
}