import 'package:merchandising_app/data/service/auth/login_service.dart';
import 'package:merchandising_app/data/service/exception/service_exception.dart';
import 'package:merchandising_app/data/service/user/user_service.dart';
import 'package:merchandising_app/domain/models/user/user_model.dart';
import 'package:merchandising_app/domain/repositories/auth/login_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Implementação do [LoginRepository] utilizando Supabase.
class LoginRepositoryImpl implements LoginRepository {
  final LoginService loginService;
  final UserService userService;

  LoginRepositoryImpl({required this.loginService, required this.userService});

  /// Realiza o login do usuário e retorna seus dados como um [UserModel].
  ///
  /// - [email]: endereço de e-mail do usuário.
  /// - [password]: senha do usuário.
  ///
  /// Retorna `null` se o login falhar ou se os dados do usuário não forem encontrados.
  /// Caso ocorra algum erro durante a consulta, uma [ServiceException] será lançada
  /// contendo informações sobre o tipo de erro ocorrido.
  @override
  Future<UserModel?> login(String email, String password) async {
    UserModel? userModel;
    try {
      AuthResponse authResponse = await loginService.entrar(email, password);
      final User? user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        Map<String, dynamic>? response = await userService.obterUsuario(
          user.id,
        );
        if (response != null) {
          /// Adiciona o email ao json para ser incluido no modelo.
          response["email"] = authResponse.user!.email;
          userModel = UserModel.fromJson(response);
        }
      }
    } on ServiceException {
      rethrow;
    }
    return userModel;
  }
}
