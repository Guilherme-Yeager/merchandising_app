import 'package:merchandising_app/data/service/auth/logout_service.dart';
import 'package:merchandising_app/data/service/exception/service_exception.dart';
import 'package:merchandising_app/domain/repositories/auth/logout_reppository.dart';

/// Implementação do [LogoutReppository] utilizando Supabase.
class LogoutRepositoryImpl implements LogoutRepository {
  final LogoutService logoutService;

  LogoutRepositoryImpl({required this.logoutService});

  /// Desconecta o usuário atual, se houver um usuário conectado.
  @override
  Future<void> logout() async {
    try {
      await logoutService.logout();
    } on ServiceException {
      rethrow;
    }
  }
}
