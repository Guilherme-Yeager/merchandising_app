import 'package:flutter/material.dart';
import 'package:merchandising_app/domain/models/cliente/cliente_model.dart';
import 'package:merchandising_app/domain/repositories/cliente/cliente_repository.dart';
import 'package:merchandising_app/ui/core/logger/app_logger.dart';

class ClienteViewModel extends ChangeNotifier {
  List<ClienteModel> _clientes = [];

  /// Clientes associados ao usuário.
  List<ClienteModel> get clientes => _clientes;

  final ClienteRepository _clienteRepository;

  ClienteViewModel({required ClienteRepository clienteRepository})
    : _clienteRepository = clienteRepository;

  /// Busca todos os clientes associados ao usuário.
  /// Também registra mensagens de sucesso ou falha no [AppLogger].
  Future<void> updateClientes(int codusur) async {
    _clientes = await _clienteRepository.getAllClientes(codusur);
    _clientes.sort((a, b) => a.codcli.compareTo(b.codcli));
    notifyListeners();
  }
}
