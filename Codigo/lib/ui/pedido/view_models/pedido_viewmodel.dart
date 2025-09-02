import 'package:flutter/foundation.dart';
import 'package:merchandising_app/data/service/exception/service_exception.dart';
import 'package:merchandising_app/domain/models/pedcab/pedcab_model.dart';
import 'package:merchandising_app/domain/models/pedcorp/pedcorp_model.dart';
import 'package:merchandising_app/domain/repositories/pedido/pedido_repository.dart';

class PedidoViewModel extends ChangeNotifier {
  /// Indica se um pedido foi salvo na base de dados, utilizada para informar
  /// o sucesso da operação.
  bool salvouPedido = false;

  final PedidoRepository _pedidoRepository;
  PedidoViewModel({required PedidoRepository pedidoRepository})
    : _pedidoRepository = pedidoRepository;

  /// Insere o cabeçalho do pedido.
  ///
  /// - [pedcabModel]: dados do cabeçalho.
  ///
  /// Retorna o código do cabeçalho pedido inserido em caso de sucesso. Já caso
  /// ocorra algum erro durante o insert, uma [ServiceException] será lançada contendo
  /// informações sobre o tipo de erro ocorrido.
  Future<int> inserirCabecalhoPedido(PedcabModel pedcabModel) async {
    try {
      return _pedidoRepository.inserirCabecalho(pedcabModel);
    } on ServiceException {
      rethrow;
    }
  }

  /// Insere o corpo do pedido.
  ///
  /// - [pedcorpModel]: dados do cabeçalho.
  ///
  /// Retorna o `true`  em caso de sucesso. Já caso ocorra algum erro durante o insert,
  ///  uma [ServiceException] será lançada contendo informações sobre o tipo de erro ocorrido.
  Future<bool> inserirCorpoPedido(PedcorpModel pedcorpModel) async {
    try {
      return _pedidoRepository.inserirCorpo(pedcorpModel);
    } on ServiceException {
      rethrow;
    }
  }

  /// Atualiza o campo de importação do pedido.
  ///
  /// - [codigoPedido]: código do pedido a ser atualizado.
  ///
  ///  Uma [ServiceException] será lançada contendo informações sobre o tipo de erro ocorrido.
  Future<void> atualizarImportadoPedCab(int codigoPedido) async {
    try {
      return _pedidoRepository.updateImportadoPedCab(codigoPedido);
    } on ServiceException {
      rethrow;
    }
  }

  /// Altera o valor de [salvouPedido] para `true` indicando que um pedido foi salvo
  /// com sucesso na base de dados.
  void salvarPedido() {
    salvouPedido = true;
    notifyListeners();
  }

  /// Altera o valor de [salvouPedido] para `false` indicando que o usuário foi informado
  /// sobre a operação do pedido salvo com sucesso.
  void desmarcarPedido() {
    salvouPedido = false;
    notifyListeners();
  }
}
