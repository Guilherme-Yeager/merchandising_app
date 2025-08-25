import 'package:flutter/material.dart';
import 'package:merchandising_app/ui/auth/login/widgets/login_screen.dart';
import 'package:merchandising_app/ui/menu/widgets/menu_screen.dart';
import 'package:merchandising_app/ui/home/widgets/home_screen.dart';
import 'package:merchandising_app/ui/cliente/widgets/cliente_screen.dart';
import 'package:merchandising_app/ui/produto/widgets/produto_screen.dart';
import 'package:merchandising_app/ui/splash/widgets/splash_screen.dart';

abstract class Routes {
  static const splash = "/splash";
  static const login = "/login";
  static const home = "/";
  static const menu = "/menu";
  static const cliente = "/cliente";
  static const perfil = "/perfil";
  static const produto = "/produto";

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => SplashScreen(),
      login: (context) => LoginScreen(),
      home: (context) => HomeScreen(),
      menu: (context) => MenuScreen(),
      cliente: (context) => ClienteScreen(),
      produto: (context) => ProdutoScreen(),
    };
  }
}
