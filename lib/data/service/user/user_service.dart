import 'package:supabase_flutter/supabase_flutter.dart';

/// Serviço responsável por obter informações do usuário logado no supabase.
class UserService {
  /// Retorna informações do usuário correspondente ao [uuid].
  ///
  /// - [uuid]: identificador do usuário.
  ///
  /// Retorna um `Map<String, dynamic>` com os dados do usuário,
  /// ou `null` caso nenhum usuário seja encontrado.
  Future<Map<String, dynamic>?> get(String uuid) async {
    return await Supabase.instance.client
        .from('pcusuari')
        .select('codusur, nome')
        .eq('user_id', uuid)
        .maybeSingle();
  }
}
