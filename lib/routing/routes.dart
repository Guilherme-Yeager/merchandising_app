import 'package:flutter/material.dart';
import 'package:merchandising_app/ui/auth/login/widgets/login_screen.dart';
import 'package:merchandising_app/ui/cliente/widgets/cliente_screen.dart';
import 'package:merchandising_app/ui/cliente/widgets/perfil_screen.dart';
import 'package:merchandising_app/ui/home/widgets/home_screen.dart';
import 'package:merchandising_app/ui/pedido/widgets/pedido_screen.dart';
import 'package:merchandising_app/ui/splash/widgets/splash_screen.dart';

abstract class Routes {
  static const splash = "/splash";
  static const login = "/login";
  static const home = "/";
  static const cliente = "/cliente";
  static const pedido = "/pedido";
  static const perfil = "/perfil";

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => SplashScreen(),
      login: (context) => LoginScreen(),
      home: (context) => HomeScreen(),
      cliente: (context) => ClienteScreen(),
      pedido: (context) => PedidoScreen(),
      perfil: (context) => PerfilScreen(),
    };
  }
}
