import 'package:merchandising_app/data/service/exception/service_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Serviço responsável por obter informações do usuário logado no supabase.
class UserService {
  /// Retorna informações do usuário correspondente ao [uuid].
  ///
  /// - [uuid]: identificador do usuário.
  ///
  /// Retorna um `Map<String, dynamic>` com os dados do usuário,
  /// ou `null` caso nenhum usuário seja encontrado.
  /// Caso ocorra algum erro durante a consulta, uma [ServiceException] será lançada
  /// contendo informações sobre o tipo de erro ocorrido.
  Future<Map<String, dynamic>?> get(String uuid) async {
    try {
      return await Supabase.instance.client
          .from('pcusuari')
          .select('codusur, nome')
          .eq('user_id', uuid)
          .maybeSingle();
    } on Exception catch (exception) {
      throw ServiceException(exception);
    }
  }
}
