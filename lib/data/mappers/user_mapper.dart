import 'package:merchandising_app/data/dto/user_dto.dart';
import 'package:merchandising_app/domain/models/pedido/pedido_model.dart';

extension UserDtoMapper on UserDto {
  PedidoModel toModel() {
    return PedidoModel();
  }
}

extension UserModelMapper on PedidoModel {
  UserDto toDto() {
    return UserDto();
  }
}
