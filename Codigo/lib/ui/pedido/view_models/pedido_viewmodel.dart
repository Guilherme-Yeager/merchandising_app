import 'package:flutter/foundation.dart';
import 'package:merchandising_app/data/service/exception/service_exception.dart';
import 'package:merchandising_app/domain/models/pedcab/pedcab_model.dart';
import 'package:merchandising_app/domain/models/pedcorp/pedcorp_model.dart';
import 'package:merchandising_app/domain/repositories/pedido/pedido_repository.dart';

class PedidoViewModel extends ChangeNotifier {
  /// Indica se um pedido foi salvo na base de dados;
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

  void salvarPedido() {
    salvouPedido = true;
    notifyListeners();
  }

  void desmarcarPedido() {
    salvouPedido = false;
    notifyListeners();
  }
}
