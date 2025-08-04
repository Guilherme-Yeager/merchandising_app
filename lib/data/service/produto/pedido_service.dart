import 'package:supabase_flutter/supabase_flutter.dart';

/// Serviço responsável por obter informações dos pedidos no supabase.
class ProdutoService {
  Future<List<Map<String, dynamic>>> getAll() {
    return Supabase.instance.client
        .from('vw_merchandising_pedidos')
        .select('codprod, descricao, qtest, pvenda');
  }
}
