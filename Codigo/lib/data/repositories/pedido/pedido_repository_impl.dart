import 'package:merchandising_app/data/service/exception/service_exception.dart';
import 'package:merchandising_app/data/service/pedido/pedido_service.dart';
import 'package:merchandising_app/domain/models/pedcab/pedcab_model.dart';
import 'package:merchandising_app/domain/models/pedcorp/pedcorp_model.dart';
import 'package:merchandising_app/domain/repositories/pedido/pedido_repository.dart';

/// Implementação do [PedidoRepository] utilizando Supabase.
class PedidoRepositoryImpl implements PedidoRepository {
  final PedidoService pedidoService;

  PedidoRepositoryImpl({required this.pedidoService});

  /// Insere o cabeçalho de um pedido no banco de dados.
  ///
  /// - [pedcabModel]: modelo do cabeçalho do pedido a ser inserido.
  ///
  /// Retorna o `codigo_pedido` do pedido inserido.
  /// Caso ocorra algum erro durante a inserção, uma [ServiceException] será lançada
  /// contendo informações sobre o tipo de erro ocorrido.
  @override
  Future<int> inserirCabecalho(PedcabModel pedcabModel) async {
    try {
      return await pedidoService.inserirCabecalho(pedcabModel);
    } on ServiceException {
      rethrow;
    }
  }

  /// Insere o corpo de um pedido no banco de dados.
  ///
  /// - [pedcorpModel]: modelo do corpo do pedido a ser inserido.
  ///
  /// Retorna `true` se a inserção for bem-sucedida, caso contrário, `false`.
  /// Caso ocorra algum erro durante a inserção, uma [ServiceException] será
  /// lançada contendo informações sobre o tipo de erro ocorrido.
  @override
  Future<bool> inserirCorpo(PedcorpModel pedcorpModel) async {
    try {
      return await pedidoService.inserirCorpo(pedcorpModel);
    } on ServiceException {
      rethrow;
    }
  }

  /// Atualiza o status de importação do cabeçalho do pedido.
  ///
  /// - [codigoPedido]: código do pedido cujo cabeçalho será atualizado.
  ///
  /// Não retorna nada. Caso ocorra algum erro durante a atualização, uma
  /// [ServiceException] será lançada contendo informações sobre o tipo de erro ocorrido.
  @override
  Future<void> atualizarImportadoCabecalho(int codigoPedido) async {
    try {
      await pedidoService.atualizarImportadoCabecalho(codigoPedido);
    } on ServiceException {
      rethrow;
    }
  }
}
