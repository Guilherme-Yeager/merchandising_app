import 'package:merchandising_app/domain/models/produto/produto_model.dart';

abstract class ProdutoRepository {
  Future<List<ProdutoModel>> getAllProdutos(int codLinhaProd);
  Future<double?> getPrecoVenda(int codProd);
}
