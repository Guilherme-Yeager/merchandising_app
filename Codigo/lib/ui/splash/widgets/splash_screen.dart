import 'package:flutter/material.dart';
import 'package:merchandising_app/data/service/exception/service_exception.dart';
import 'package:merchandising_app/routing/routes.dart';
import 'package:merchandising_app/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:merchandising_app/ui/cliente/view_models/cliente_viewmodel.dart';
import 'package:merchandising_app/ui/core/logger/app_logger.dart';
import 'package:merchandising_app/ui/core/ui/error_screen.dart';
import 'package:merchandising_app/ui/core/ui/gradiente_linear_custom.dart';
import 'package:merchandising_app/ui/core/ui/offline_screen.dart';
import 'package:merchandising_app/ui/produto/view_models/produto_viewmodel.dart';
import 'package:merchandising_app/ui/splash/view_models/splash_viewmodel.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      inicializarAplicativo();
    });
  }

  /// Possibiliza o usuário acessar o sistema sem precisar fazer
  /// login caso haja uma sessão válida e carrega as dependências.
  /// Caso contrário, navega para tela de login.
  void inicializarAplicativo() async {
    final SplashViewModel splashViewModel = Provider.of<SplashViewModel>(
      context,
      listen: false,
    );
    if (splashViewModel.sessaoEstaValida()) {
      final LoginViewModel loginViewModel = Provider.of<LoginViewModel>(
        context,
        listen: false,
      );
      final ClienteViewModel clienteViewModel = Provider.of<ClienteViewModel>(
        context,
        listen: false,
      );
      final ProdutoViewModel produtoViewModel = Provider.of<ProdutoViewModel>(
        context,
        listen: false,
      );
      try {
        await loginViewModel.carregarUsuario();
        await loginViewModel.carregarDependencias(
          clienteViewModel,
          produtoViewModel,
        );
      } on ServiceException catch (exception) {
        if (exception.tipo == TipoErro.offline) {
          await Future.delayed(Duration(seconds: 1));
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => OfflineScreen()),
            );
          }
        } else {
          await Future.delayed(Duration(seconds: 1));
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ErrorScreen(mensagem: exception.mensagem),
              ),
            );
          }
          return;
        }
      }
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.home,
          (Route<dynamic> route) => false,
        );
        AppLogger.instance.i(
          "Sessão válida: usuário entrou no sistema sem precisar fazer login.",
        );
      }
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.login,
        (Route<dynamic> route) => false,
      );
      AppLogger.instance.i("Sessão inválida: Usuário precisa fazer login.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradienteLinearCustom(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/logo.png"),
              SizedBox(height: 30),
              CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
