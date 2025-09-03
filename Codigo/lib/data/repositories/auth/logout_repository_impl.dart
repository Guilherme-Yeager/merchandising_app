import 'package:merchandising_app/data/service/auth/logout_service.dart';
import 'package:merchandising_app/data/service/exception/service_exception.dart';
import 'package:merchandising_app/domain/repositories/auth/logout_reppository.dart';

/// Implementação do [LogoutRepository] utilizando Supabase.
class LogoutRepositoryImpl implements LogoutRepository {
  final LogoutService logoutService;

  LogoutRepositoryImpl({required this.logoutService});

  /// Desconecta o usuário atual, se houver um usuário conectado.
  ///
  /// Não retorna nada. Caso ocorra algum erro durante a consulta, uma
  /// [ServiceException] será lançada contendo informações sobre o tipo de erro ocorrido.
  @override
  Future<void> sair() async {
    try {
      await logoutService.sair();
    } on ServiceException {
      rethrow;
    }
  }
}
