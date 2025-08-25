import 'package:flutter/foundation.dart';
import 'package:merchandising_app/data/service/exception/service_exception.dart';
import 'package:merchandising_app/domain/models/produto/produto_model.dart';
import 'package:merchandising_app/domain/repositories/produto/produto_repository.dart';
import 'package:merchandising_app/ui/core/logger/app_logger.dart';

class ProdutoViewModel extends ChangeNotifier {
  List<ProdutoModel> _produtos = [];

  /// Lista de produtos filtrados seja por codprod ou descrição.
  List<ProdutoModel> _produtosComFiltro = [];

  List<ProdutoModel> get produtos => _produtos;

  List<ProdutoModel> get produtosComFiltro => _produtosComFiltro;

  final ProdutoRepository _produtoRepository;
  ProdutoViewModel({required ProdutoRepository produtoRepistory})
    : _produtoRepository = produtoRepistory;

  /// Busca todos produtos.
  /// Também registra mensagens de sucesso ou falha no [AppLogger].
  Future<void> updateProdutos() async {
    _produtos = await _produtoRepository.getAllProdutos();
    _produtos.sort((a, b) => a.codprod.compareTo(b.codprod));
    _produtosComFiltro = List.from(_produtos);
    notifyListeners();
    AppLogger.instance.i("Produtos atualizados.");
  }

  /// Filtra a lista de produtos com base no filtro fornecido.
  /// Se o filtro estiver vazio, a lista de produtos filtrados será igual à lista original
  /// caso contrário, a lista será filtrada por `codprod` ou `descricao`.
  ///
  /// - [filter] é a string usada para filtrar os produtos.
  void filtrarProdutos(String filtro) {
    if (filtro.isEmpty) {
      _produtosComFiltro.clear();
      _produtosComFiltro = List.from(_produtos);
    } else {
      _produtosComFiltro =
          _produtos.where((produto) {
            return produto.codprod.toString().contains(filtro) ||
                produto.descricao.toLowerCase().contains(filtro.toLowerCase());
          }).toList();
    }
    notifyListeners();
  }

  /// Limpa o filtro selecionado, fazendo a listada de filtro ter o mesmo
  /// conteúdo da lista original.
  void limparFiltro() {
    _produtosComFiltro = List.from(_produtos);
    notifyListeners();
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
      return _produtoRepository.getPrecoVenda(codProd);
    } on ServiceException {
      rethrow;
    }
  }
}
