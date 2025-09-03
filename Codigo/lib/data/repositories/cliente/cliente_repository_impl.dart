import 'package:merchandising_app/data/service/cliente/cliente_service.dart';
import 'package:merchandising_app/data/service/exception/service_exception.dart';
import 'package:merchandising_app/domain/models/cliente/cliente_model.dart';
import 'package:merchandising_app/domain/repositories/cliente/cliente_repository.dart';

/// Implementação do [ClienteRepository] utilizando Supabase.
class ClienteRepositoryImpl implements ClienteRepository {
  final ClienteService clienteService;

  ClienteRepositoryImpl({required this.clienteService});

  /// Obtém todos os clientes associados a um usuário específico.
  ///
  /// - [codusur]: código do usuário para o qual os clientes serão obtidos.
  ///
  /// Retorna uma lista de [ClienteModel] representando os clientes do usuário.
  /// Caso ocorra algum erro durante a consulta, uma [ServiceException] será lançada
  /// contendo informações sobre o tipo de erro ocorrido.
  @override
  Future<List<ClienteModel>> obterTodos(int codusur) async {
    try {
      final List<Map<String, dynamic>> response = await clienteService
          .obterTodos(codusur.toString());
      return response.map((cliente) => ClienteModel.fromJson(cliente)).toList();
    } on ServiceException {
      rethrow;
    }
  }
}
