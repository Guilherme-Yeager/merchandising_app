import 'package:merchandising_app/data/service/exception/service_exception.dart';
import 'package:merchandising_app/data/service/user/user_service.dart';
import 'package:merchandising_app/domain/models/user/user_model.dart';
import 'package:merchandising_app/domain/repositories/user/user_repository.dart';

/// Implementação do [UserRepository] utilizando Supabase.
class UserRepositoryImpl implements UserRepository {
  final UserService userService;

  UserRepositoryImpl({required this.userService});

  /// Obtém os dados do usuário correspondente ao [uuid].
  ///
  /// - [uuid]: identificador do usuário.
  ///
  /// Retorna `null` caso nenhum usuário seja encontrado.
  @override
  Future<UserModel?> getUser(String uuid) async {
    try {
      UserModel? userModel;
      Map<String, dynamic>? response = await userService.get(uuid);
      if (response != null) {
        userModel = UserModel.fromJson(response);
      }
      return userModel;
    } on ServiceException {
      rethrow;
    }
  }
}
