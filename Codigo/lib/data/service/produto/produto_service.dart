import 'package:merchandising_app/data/service/exception/service_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Serviço responsável por obter informações dos pedidos no supabase.
/// Caso ocorra algum erro durante a consulta, uma [ServiceException] será lançada
/// contendo informações sobre o tipo de erro ocorrido.
class ProdutoService {
  /// Retorna todos os produtos da base de dados.
  ///
  /// Já caso ocorra algum erro durante o insert, uma [ServiceException]
  /// será lançada contendo informações sobre o tipo de erro ocorrido.
  Future<List<Map<String, dynamic>>> getAll() {
    try {
      return Supabase.instance.client
          .from('vw_merchandising_produtos')
          .select('codprod, descricao, qtest, pvenda');
    } on Exception catch (exception) {
      throw ServiceException(exception);
    }
  }

  /// Busca o preço de venda do produto.
  ///
  /// - [codProd]: código de produto do cliente.
  ///
  /// Retorna o preço de venda do produto em caso de sucesso. Já caso ocorra
  /// algum erro durante o insert, uma [ServiceException] será lançada contendo
  /// informações sobre o tipo de erro ocorrido.
  Future<double?> getPrecoVenda(int codProd) async {
    try {
      final Map<String, dynamic>? response =
          await Supabase.instance.client
              .from('vw_merchandising_preco')
              .select('pvenda')
              .eq('codprod', codProd)
              .maybeSingle();
      if (response == null) {
        return null;
      }
      return response['pvenda'];
    } on ServiceException {
      rethrow;
    }
  }
}
