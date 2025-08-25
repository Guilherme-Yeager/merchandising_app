import 'package:flutter/foundation.dart';
import 'package:merchandising_app/data/service/exception/service_exception.dart';
import 'package:merchandising_app/domain/models/pedcab/pedcab_model.dart';
import 'package:merchandising_app/domain/models/pedcorp/pedcorp_model.dart';

class PedidoViewmodel extends ChangeNotifier {
  /// Insere o cabeçalho do pedido.
  ///
  /// - [pedcabModel]: dados do cabeçalho.
  ///
  /// Retorna o código do cabeçalho pedido inserido em caso de sucesso. Já caso
  /// ocorra algum erro durante o insert, uma [ServiceException] será lançada contendo
  /// informações sobre o tipo de erro ocorrido.
  Future<int> inserirCabecalhoPedido(PedcabModel pedcabModel) async {
    try {
      return 1;
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
    try {} on ServiceException {
      rethrow;
    }
    return true;
  }
}
