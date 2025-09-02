import 'package:merchandising_app/data/service/exception/service_exception.dart';
import 'package:merchandising_app/data/service/pedido/pedido_service.dart';
import 'package:merchandising_app/domain/models/pedcab/pedcab_model.dart';
import 'package:merchandising_app/domain/models/pedcorp/pedcorp_model.dart';
import 'package:merchandising_app/domain/repositories/pedido/pedido_repository.dart';

class PedidoRepositoryImpl implements PedidoRepository {
  final PedidoService pedidoService;

  PedidoRepositoryImpl({required this.pedidoService});

  @override
  Future<int> inserirCabecalho(PedcabModel pedcabModel) async {
    try {
      return await pedidoService.inserirCabecalho(pedcabModel);
    } on ServiceException {
      rethrow;
    }
  }

  @override
  Future<bool> inserirCorpo(PedcorpModel pedcorpModel) async {
    try {
      return await pedidoService.inserirCorpo(pedcorpModel);
    } on ServiceException {
      rethrow;
    }
  }

  @override
  Future<void> updateImportadoPedCab(int codigoPedido) async {
    try {
      await pedidoService.atualizarImportadoCabecalho(codigoPedido);
    } on ServiceException {
      rethrow;
    }
  }
}
