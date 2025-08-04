import 'package:flutter/material.dart';
import 'package:merchandising_app/domain/models/cliente/cliente_model.dart';
import 'package:merchandising_app/domain/repositories/cliente/cliente_repository.dart';
import 'package:merchandising_app/ui/core/logger/app_logger.dart';

/// ViewModel responsável por gerenciar o estado dos clientes.
class ClienteViewModel extends ChangeNotifier {
  /// Clientes associados ao usuário.
  List<ClienteModel> _clientes = [];

  /// Lista de clientes filtrados seja por codcli ou cliente.
  List<ClienteModel> _clientesComFiltro = [];

  List<ClienteModel> get clientesComFiltro => _clientesComFiltro;

  /// Representa o cliente selecionado.
  ClienteModel? _clienteSelecionado;

  ClienteModel? get clienteSelecionado => _clienteSelecionado;

  final ClienteRepository _clienteRepository;

  ClienteViewModel({required ClienteRepository clienteRepository})
    : _clienteRepository = clienteRepository;

  /// Busca todos os clientes associados ao usuário.
  /// Também registra mensagens de sucesso ou falha no [AppLogger].
  Future<void> updateClientes(int codusur) async {
    _clientes = await _clienteRepository.getAllClientes(codusur);
    _clientes.sort((a, b) => a.codcli.compareTo(b.codcli));
    _clientesComFiltro = List.from(_clientes);
    notifyListeners();
    AppLogger.instance.i("Clientes atualizados.");
  }

  /// Filtra a lista de clientes com base no filtro fornecido.
  /// Se o filtro estiver vazio, a lista de clientes filtrados será igual à lista original
  /// caso contrário, a lista será filtrada por `codcli` ou `cliente`.
  ///
  /// - [filter] é a string usada para filtrar os clientes.
  void filtrarClientes(String filtro) {
    if (filtro.isEmpty) {
      _clientesComFiltro.clear();
      _clientesComFiltro = List.from(_clientes);
    } else {
      _clientesComFiltro =
          _clientes.where((cliente) {
            return cliente.codcli.toString().contains(filtro) ||
                cliente.cliente.toLowerCase().contains(filtro.toLowerCase());
          }).toList();
    }
    notifyListeners();
  }

  /// Seleciona um cliente e notifica os ouvintes sobre a mudança.
  ///
  /// - [cliente] é o cliente a ser selecionado.
  void selecionarCliente(ClienteModel cliente) {
    _clienteSelecionado = cliente;
    notifyListeners();
  }
}
