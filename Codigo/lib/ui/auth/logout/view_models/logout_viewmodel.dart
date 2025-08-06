import 'package:flutter/material.dart';
import 'package:merchandising_app/domain/repositories/auth/logout_reppository.dart';

/// ViewModel responsável por gerenciar o estado de desconectar um usuário.
class LogoutViewModel extends ChangeNotifier {
  final LogoutRepository _logoutReppository;

  LogoutViewModel({required LogoutRepository logoutReppository})
    : _logoutReppository = logoutReppository;

  /// Desconecta o usuário atual, se houver um usuário conectado.
  Future<void> logout() async {
    await _logoutReppository.logout();
  }
}
