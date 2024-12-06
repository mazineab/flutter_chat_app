import 'package:chat_app/data/models/user.dart';

abstract class Authentication {
  Future<bool> login(String email, String password);
  Future<void> logout();
  Future<bool> registerUser(User user);
}