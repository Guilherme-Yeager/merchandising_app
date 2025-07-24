import 'package:flutter/material.dart';
import 'package:merchandising_app/domain/models/user/user_model.dart';
import 'package:merchandising_app/domain/repositories/auth/login_repository.dart';
import 'package:merchandising_app/ui/core/logger/app_logger.dart';

class LoginViewmodel extends ChangeNotifier {
  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  final LoginRepository _loginRepository;

  LoginViewmodel({required LoginRepository loginRepository})
    : _loginRepository = loginRepository;

  Future<bool> login(String email, String password) async {
    UserModel? userModel = await _loginRepository.login(email, password);
    bool logou = false;
    if (userModel != null) {
      _userModel = userModel;
      notifyListeners();
      logou = true;
      AppLogger.instance.i("Login realizado com sucesso.");
    } else {
      AppLogger.instance.w("Usuário logado não encontrado.");
    }

    return logou;
  }
}
