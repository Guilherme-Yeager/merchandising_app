import 'package:merchandising_app/data/service/exception/service_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Serviço responsável por encerrar a sessão do usuário utilizando o Supabase.
class LogoutService {
  /// Desconecta o usuário atual, se houver um usuário conectado.
  /// Caso ocorra algum erro durante a consulta, uma [ServiceException] será lançada
  /// contendo informações sobre o tipo de erro ocorrido.
  Future<void> logout() async {
    try {
      return await Supabase.instance.client.auth.signOut();
    } on Exception catch (exception) {
      throw ServiceException(exception);
    }
  }
}
