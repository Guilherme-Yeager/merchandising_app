import 'package:merchandising_app/data/dto/pedido_dto.dart';
import 'package:merchandising_app/domain/models/pedido/pedido_model.dart';

extension PedidoDtoMapper on PedidoDto {
  PedidoModel toModel() {
    return PedidoModel();
  }
}

extension PedidoModelMapper on PedidoModel {
  PedidoDto toDto() {
    return PedidoDto();
  }
}
