import 'package:merchandising_app/data/service/exception/service_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Serviço responsável por obter informações dos produtos no Supabase.
class ProdutoService {
  /// Retorna todos os produtos do usuário logado da base de dados.
  ///
  /// - [idUser]: código do usuário logado.
  ///
  /// Retorna um `List<Map<String, dynamic>>` com os dados de todos os produtos,
  /// ou uma lista vazia, caso não haja nenhum.
  /// Caso ocorra algum erro durante a consulta, uma [ServiceException]
  /// será lançada contendo informações sobre o tipo de erro ocorrido.
  Future<List<Map<String, dynamic>>> obterTodos(int idUser) async {
    try {
      return await Supabase.instance.client
          .from('vw_merchandising_produtos')
          .select('codprod, descricao, qtest, pvenda')
          .eq('codlinhaprod', idUser);
    } on Exception catch (exception) {
      throw ServiceException(exception);
    }
  }

  /// Busca o preço de venda do produto.
  ///
  /// - [codProd]: código de produto do cliente.
  ///
  /// Retorna o preço de venda do produto em caso de sucesso ou nulo se não houver
  /// no banco. Caso ocorra algum erro durante o insert, uma [ServiceException]
  /// será lançada contendo informações sobre o tipo de erro ocorrido.
  Future<double?> obterPrecoVenda(int codProd) async {
    try {
      final Map<String, dynamic>? response =
          await Supabase.instance.client
              .from('vw_merchandising_preco')
              .select('pvenda')
              .eq('codprod', codProd)
              .maybeSingle();

      return response != null ? response['pvenda'] : null;
    } on ServiceException {
      rethrow;
    }
  }
}
