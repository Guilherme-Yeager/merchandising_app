import 'package:merchandising_app/data/service/exception/service_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Serviço responsável por obter informações dos pedidos no supabase.
/// Caso ocorra algum erro durante a consulta, uma [ServiceException] será lançada
/// contendo informações sobre o tipo de erro ocorrido.
class ProdutoService {
  Future<List<Map<String, dynamic>>> getAll() {
    try {
      return Supabase.instance.client
          .from('vw_merchandising_produtos')
          .select('codprod, descricao, qtest, pvenda');
    } on Exception catch (exception) {
      throw ServiceException(exception);
    }
  }
}
