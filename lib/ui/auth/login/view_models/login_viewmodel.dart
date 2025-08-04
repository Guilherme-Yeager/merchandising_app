import 'package:flutter/material.dart';
import 'package:merchandising_app/domain/models/user/user_model.dart';
import 'package:merchandising_app/domain/repositories/auth/login_repository.dart';
import 'package:merchandising_app/ui/core/logger/app_logger.dart';

/// ViewModel responsável por gerenciar o estado de autenticação do usuário.
class LoginViewModel extends ChangeNotifier {
  UserModel? _userModel;

  /// Usuário autenticado.
  UserModel? get userModel => _userModel;

  final LoginRepository _loginRepository;

  LoginViewModel({required LoginRepository loginRepository})
    : _loginRepository = loginRepository;

  /// Realiza o login do usuário com o e-mail e senha fornecidos.
  ///
  /// - [email]: endereço de e-mail do usuário.
  /// - [password]: senha associada ao e-mail.
  ///
  /// Se o login for bem-sucedido, armazena os dados do usuário em [_userModel],
  /// notifica os listeners da mudança de estado e retorna `true`.
  /// Caso contrário, retorna `false`.
  ///
  /// Também registra mensagens de sucesso ou falha no [AppLogger].
  Future<bool> login(String email, String password) async {
    UserModel? userModel = await _loginRepository.login(email, password);
    bool logou = false;
    if (userModel != null) {
      _userModel = userModel;
      notifyListeners();
      logou = true;
      AppLogger.instance.i("Login realizado com sucesso.");
      AppLogger.instance.i(
        "Código: ${_userModel!.codusur}, Usuário: ${_userModel!.nome}, Email: ${_userModel!.email}",
      );
    } else {
      AppLogger.instance.w("Usuário logado não encontrado.");
    }

    return logou;
  }
}
