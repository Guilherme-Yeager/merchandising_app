import 'package:merchandising_app/data/service/cliente/cliente_service.dart';
import 'package:merchandising_app/data/service/exception/service_exception.dart';
import 'package:merchandising_app/domain/models/cliente/cliente_model.dart';
import 'package:merchandising_app/domain/repositories/cliente/cliente_repository.dart';

class ClienteRepositoryImpl implements ClienteRepository {
  final ClienteService clienteService;

  ClienteRepositoryImpl({required this.clienteService});

  @override
  Future<List<ClienteModel>> getAllClientes(int codusur) async {
    try {
      final List<Map<String, dynamic>> response = await clienteService.getAll(
        codusur.toString(),
      );
      return response.map((cliente) => ClienteModel.fromJson(cliente)).toList();
    } on ServiceException {
      rethrow;
    }
  }
}
