import 'package:merchandising_app/domain/models/produto/produto_model.dart';

abstract class ProdutoRepository {
  Future<List<ProdutoModel>> getAllProdutos();
  Future<double?> getPrecoVenda(int codProd);
}
