import 'package:merchandising_app/data/service/auth/login_service.dart';
import 'package:merchandising_app/data/service/user/user_service.dart';
import 'package:merchandising_app/domain/models/user/user_model.dart';
import 'package:merchandising_app/domain/repositories/auth/login_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginService loginService;
  final UserService userService;

  LoginRepositoryImpl({required this.loginService, required this.userService});

  @override
  Future<UserModel?> login(String email, String password) async {
    await loginService.logar(email, password);
    final User? user = Supabase.instance.client.auth.currentUser;
    UserModel? userModel;
    if (user != null) {
      Map<String, dynamic>? response = await userService.get(user.id);
      if (response != null) {
        userModel = UserModel.fromJson(response);
      }
    }
    return userModel;
  }
}
