import 'package:merchandising_app/domain/models/cliente/cliente_model.dart';

abstract class ClienteRepository {
  Future<List<ClienteModel>> getAllClientes(int codusur);
}
