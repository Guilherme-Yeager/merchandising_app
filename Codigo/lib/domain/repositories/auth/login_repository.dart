import 'package:merchandising_app/domain/models/user/user_model.dart';

abstract class LoginRepository {
  Future<UserModel?> login(String email, String password);
}
