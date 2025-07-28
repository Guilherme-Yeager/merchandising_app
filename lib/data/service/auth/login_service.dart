import 'package:supabase_flutter/supabase_flutter.dart';

/// Serviço responsável por autenticar usuários utilizando o Supabase.
class LoginService {
  /// Realiza o login com e-mail e senha.
  ///
  /// - [email]: endereço de e-mail do usuário.
  /// - [password]: senha associada ao e-mail.
  ///
  /// Retorna um [AuthResponse] com informações da sessão atual.
  Future<AuthResponse> logar(String email, String password) async {
    return await Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
}
