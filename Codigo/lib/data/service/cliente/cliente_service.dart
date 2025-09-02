import 'package:merchandising_app/data/service/exception/service_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Serviço responsável por obter informações dos clientes associados ao usuário logado no Supabase.
class ClienteService {
  /// Retorna todos os clientes associados ao usuário correspondente ao [codusur].
  ///
  /// - [codusur]: identificador do usuário.
  ///
  /// Retorna um `List<Map<String, dynamic>>` com os dados de todos os clientes,
  /// ou uma lista vazia, caso não haja nenhum.
  /// Caso ocorra algum erro durante a consulta, uma [ServiceException] será lançada
  /// contendo informações sobre o tipo de erro ocorrido.
  Future<List<Map<String, dynamic>>> obterTodos(String codusur) async {
    try {
      return await Supabase.instance.client
          .from('vw_merchandising_clientes')
          .select(
            'codcli, cliente, fantasia, telent, enderent, municent, bairrocob, cgcent',
          )
          .eq('codusur', codusur);
    } on Exception catch (exception) {
      throw ServiceException(exception);
    }
  }
}
