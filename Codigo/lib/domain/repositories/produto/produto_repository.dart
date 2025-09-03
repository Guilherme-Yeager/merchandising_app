import 'package:merchandising_app/domain/models/produto/produto_model.dart';

abstract class ProdutoRepository {
  Future<List<ProdutoModel>> obterTodos(int codLinhaProd);
  Future<double?> obterPrecoVenda(int codProd);
}
