import 'package:merchandising_app/data/service/exception/service_exception.dart';
import 'package:merchandising_app/data/service/user/user_service.dart';
import 'package:merchandising_app/domain/repositories/user/user_repository.dart';

/// Implementação do [UserRepository] utilizando Supabase.
class UserRepositoryImpl implements UserRepository {
  final UserService userService;

  UserRepositoryImpl({required this.userService});

  /// Obtém os dados do usuário correspondente ao [uuid].
  ///
  /// - [uuid]: identificador do usuário.
  ///
  /// Retorna `Map<String, dynamic>` (json) contendo código e
  /// nome do usuário.
  /// Retorna `null` caso nenhum usuário seja encontrado.
  @override
  Future<Map<String, dynamic>?> getUser(String uuid) async {
    try {
      return await userService.obterUsuario(uuid);
    } on ServiceException {
      rethrow;
    }
  }
}
