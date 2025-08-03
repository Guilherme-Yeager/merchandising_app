import 'package:supabase_flutter/supabase_flutter.dart';

/// Serviço responsável por encerrar a sessão do usuário utilizando o Supabase.
class LogoutService {
  /// Desconecta o usuário atual, se houver um usuário conectado.
  Future<void> logout() async {
    return await Supabase.instance.client.auth.signOut();
  }
}
