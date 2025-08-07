import 'package:merchandising_app/data/service/produto/produto_service.dart';
import 'package:merchandising_app/domain/models/produto/produto_model.dart';
import 'package:merchandising_app/domain/repositories/produto/produto_repository.dart';

class ProdutoRepositoryImpl implements ProdutoRepository {
  final ProdutoService produtoService;

  ProdutoRepositoryImpl({required this.produtoService});

  @override
  Future<List<ProdutoModel>> getAllProdutos() {
    return produtoService.getAll().then((response) {
      return response.map((pedido) => ProdutoModel.fromJson(pedido)).toList();
    });
  }
}
