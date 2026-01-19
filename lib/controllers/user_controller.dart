// lib/controllers/user_controller.dart
import 'package:get/get.dart';
import '../models/user_model.dart';

class UserController extends GetxController {
  // 앱 어디서든 접근 가능한 '내 정보'
  // .obs를 붙이면 정보가 바뀔 때마다 화면이 자동으로 고쳐짐
  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);

  // 정보를 꺼내보는 함수
  UserModel? get user => _currentUser.value;

  // 로그인했을 때 정보를 저장하는 함수
  void setUser(UserModel user) {
    _currentUser.value = user;
  }

  // 로그아웃했을 때 정보를 비우는 함수
  void clearUser() {
    _currentUser.value = null;
  }
}