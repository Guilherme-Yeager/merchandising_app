import 'package:supabase_flutter/supabase_flutter.dart';

/// Serviço responsável por obter informações dos clientes associados ao usuário logado no supabase.
class ClienteService {
  /// Retorna todos os clientes associados ao usuário correspondente ao [codusur].
  ///
  /// - [codusur]: identificador do usuário.
  ///
  /// A função retorna um `List<Map<String, dynamic>>` com os dados de todos os clientes,
  /// ou uma lista vazia, caso não haja nenhum.
  Future<List<Map<String, dynamic>>> getAll(String codusur) {
    return Supabase.instance.client
        .from('vw_merchandising_clientes')
        .select(
          'codcli, cliente, fantasia, telent, enderent, municent, bairrocob, cgcent',
        )
        .eq('codusur', codusur);
  }
}
