import 'package:merchandising_app/domain/models/pedcab/pedcab_model.dart';
import 'package:merchandising_app/domain/models/pedcorp/pedcorp_model.dart';

abstract class PedidoRepository {
  Future<int> inserirCabecalho(PedcabModel pedcabModel);
  Future<bool> inserirCorpo(PedcorpModel pedcorpModel);
  Future<void> updateImportadoPedCab(int codigoPedido);
}
