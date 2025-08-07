import 'package:flutter/material.dart';
import 'package:merchandising_app/routing/routes.dart';
import 'package:merchandising_app/ui/auth/login/view_models/login_viewModel.dart';
import 'package:merchandising_app/ui/cliente/view_models/cliente_viewmodel.dart';
import 'package:merchandising_app/ui/core/ui/gradiente_linear_custom.dart';
import 'package:merchandising_app/ui/produto/view_models/produto_viewmodel.dart';
import 'package:merchandising_app/ui/splash/view_models/splash_viewModel.dart';
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

  void inicializarAplicativo() async {
    final SplashViewModel splashViewModel = Provider.of<SplashViewModel>(
      context,
      listen: false,
    );
    if (splashViewModel.estaLogado()) {
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
      await loginViewModel.carregarUsuario();
      await loginViewModel.carregarDependencias(
        clienteViewModel,
        produtoViewModel,
      );
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.home,
          (Route<dynamic> route) => false,
        );
      }
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.login,
        (Route<dynamic> route) => false,
      );
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
