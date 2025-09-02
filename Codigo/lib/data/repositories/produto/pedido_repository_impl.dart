import 'package:merchandising_app/data/service/exception/service_exception.dart';
import 'package:merchandising_app/data/service/produto/produto_service.dart';
import 'package:merchandising_app/domain/models/produto/produto_model.dart';
import 'package:merchandising_app/domain/repositories/produto/produto_repository.dart';

class ProdutoRepositoryImpl implements ProdutoRepository {
  final ProdutoService produtoService;

  ProdutoRepositoryImpl({required this.produtoService});

  @override
  Future<List<ProdutoModel>> getAllProdutos() async {
    try {
      final List<Map<String, dynamic>> response =
          await produtoService.obterTodos();
      return response.map((pedido) => ProdutoModel.fromJson(pedido)).toList();
    } on ServiceException {
      rethrow;
    }
  }

  @override
  Future<double?> getPrecoVenda(int codProd) async {
    try {
      return produtoService.obterPrecoVenda(codProd);
    } on ServiceException {
      rethrow;
    }
  }
}
