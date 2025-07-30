import 'package:merchandising_app/data/service/cliente/cliente_service.dart';
import 'package:merchandising_app/domain/models/cliente/cliente_model.dart';
import 'package:merchandising_app/domain/repositories/cliente/cliente_repository.dart';

class ClienteRepositoryImpl implements ClienteRepository {
  final ClienteService clienteService;

  ClienteRepositoryImpl({required this.clienteService});

  @override
  Future<List<ClienteModel>> getAllClientes(int codusur) {
    return clienteService.getAll(codusur.toString()).then((response) {
      return response.map((cliente) => ClienteModel.fromJson(cliente)).toList();
    });
  }
}
