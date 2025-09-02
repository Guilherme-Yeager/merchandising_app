import 'package:merchandising_app/data/service/exception/service_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Serviço responsável por autenticar usuários utilizando o Supabase.
class LoginService {
  /// Realiza o login com e-mail e senha.
  ///
  /// - [email]: endereço de e-mail do usuário.
  /// - [password]: senha associada ao e-mail.
  ///
  /// Retorna um [AuthResponse] com informações da sessão atual.
  /// Caso ocorra algum erro durante a consulta, uma [ServiceException] será lançada
  /// contendo informações sobre o tipo de erro ocorrido.
  Future<AuthResponse> entrar(String email, String password) async {
    try {
      return await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on Exception catch (exception) {
      throw ServiceException(exception);
    }
  }
}
