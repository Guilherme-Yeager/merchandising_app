import 'package:merchandising_app/data/service/exception/service_exception.dart';
import 'package:merchandising_app/data/service/produto/produto_service.dart';
import 'package:merchandising_app/domain/models/produto/produto_model.dart';
import 'package:merchandising_app/domain/repositories/produto/produto_repository.dart';

/// Implementação do [ProdutoRepository] utilizando Supabase.
class ProdutoRepositoryImpl implements ProdutoRepository {
  final ProdutoService produtoService;

  ProdutoRepositoryImpl({required this.produtoService});

  /// Obtém todos os produtos associados a uma linha de produto específica.
  ///
  /// - [codLinhaProd]: código da linha de produto para a qual os produtos serão obtidos.
  ///
  /// Retorna uma lista de [ProdutoModel] representando os produtos da linha de produto.
  /// Caso ocorra algum erro durante a consulta, uma [ServiceException] será lançada
  /// contendo informações sobre o tipo de erro ocorrido.
  @override
  Future<List<ProdutoModel>> obterTodos(int codLinhaProd) async {
    try {
      final List<Map<String, dynamic>> response = await produtoService
          .obterTodos(codLinhaProd);
      return response.map((pedido) => ProdutoModel.fromJson(pedido)).toList();
    } on ServiceException {
      rethrow;
    }
  }

  /// Obtém o preço de venda do produto pelo código do produto.
  ///
  /// - [codProd]: código do produto.
  ///
  /// Retorna `double` representando o preço de venda do produto ou
  /// retorna `null` caso o produto não seja encontrado.
  /// Caso ocorra algum erro durante a consulta, uma [ServiceException] será lançada
  /// contendo informações sobre o tipo de erro ocorrido.
  @override
  Future<double?> obterPrecoVenda(int codProd) async {
    try {
      return produtoService.obterPrecoVenda(codProd);
    } on ServiceException {
      rethrow;
    }
  }
}
