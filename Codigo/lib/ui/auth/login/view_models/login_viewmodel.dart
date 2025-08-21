import 'package:flutter/material.dart';
import 'package:merchandising_app/config/supabase/supabase_config.dart';
import 'package:merchandising_app/data/service/exception/service_exception.dart';
import 'package:merchandising_app/domain/models/user/user_model.dart';
import 'package:merchandising_app/domain/repositories/auth/login_repository.dart';
import 'package:merchandising_app/domain/repositories/user/user_repository.dart';
import 'package:merchandising_app/ui/cliente/view_models/cliente_viewmodel.dart';
import 'package:merchandising_app/ui/core/logger/app_logger.dart';
import 'package:merchandising_app/ui/produto/view_models/produto_viewmodel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// ViewModel responsável por gerenciar o estado de autenticação do usuário.
class LoginViewModel extends ChangeNotifier {
  UserModel? _userModel;

  /// Usuário autenticado.
  UserModel? get userModel => _userModel;

  final LoginRepository _loginRepository;
  final UserRepository _userRepository;

  LoginViewModel({
    required LoginRepository loginRepository,
    required UserRepository userRepository,
  }) : _loginRepository = loginRepository,
       _userRepository = userRepository;

  /// Realiza o login do usuário com o e-mail e senha fornecidos.
  ///
  /// - [email]: endereço de e-mail do usuário.
  /// - [password]: senha associada ao e-mail.
  ///
  /// Se o login for bem-sucedido, armazena os dados do usuário em [_userModel],
  /// notifica os listeners da mudança de estado e retorna `true`.
  /// Caso contrário, retorna `false`.
  ///
  /// Também registra mensagens de sucesso ou falha no [AppLogger].
  Future<bool> login(String email, String password) async {
    bool logou = false;
    try {
      UserModel? userModel = await _loginRepository.login(email, password);
      if (userModel != null) {
        _userModel = userModel;
        notifyListeners();
        logou = true;
        AppLogger.instance.i("Login realizado com sucesso.");
        AppLogger.instance.i(
          "Código: ${_userModel!.codusur}, Usuário: ${_userModel!.nome}, Email: ${_userModel!.email}",
        );
      } else {
        AppLogger.instance.w("Usuário logado não encontrado.");
      }
    } on ServiceException {
      rethrow;
    }
    return logou;
  }

  /// Carrega informações do usuário com sessão ativa, acessando o
  /// shared_preferences e obtendo informações do mesmo.
  /// Ao final `_userModel` será o usuário da aplicação sem precisar
  /// fazer login.
  Future<void> carregarUsuario() async {
    final User? user = Supabase.instance.client.auth.currentUser;
    try {
      Map<String, dynamic>? response = await _userRepository.getUser(user!.id);
      response!["email"] = user.email;
      _userModel = UserModel.fromJson(response);
    } on ServiceException {
      rethrow;
    }
  }

  /// Carrega as dependências do sistema, onde atualiza a lista de
  /// clientes e inscreve-se em canais de tempo real para as tabelas
  /// `pcclient` e `pcprodut`
  ///
  /// - [clienteViewModel]: é a classe que possui a funcionalidade de
  /// atualização dos clientes.
  /// - [produtoViewModel]: é a classe que possui a funcionalidade de
  /// atualização dos produtos.
  Future<void> carregarDependencias(
    ClienteViewModel clienteViewModel,
    ProdutoViewModel produtoViewModel,
  ) async {
    await clienteViewModel.updateClientes(_userModel!.codusur);
    SupabaseConfig.inscribeRealTimeChangeCliente(
      clienteViewModel.updateClientes,
      _userModel!.codusur,
    );
    SupabaseConfig.inscribeRealTimeChangeProduto(
      produtoViewModel.updateProdutos,
    );
  }
}
