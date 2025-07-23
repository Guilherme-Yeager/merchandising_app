import 'package:flutter/material.dart';
import 'package:merchandising_app/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:merchandising_app/ui/auth/logout/view_models/logout_viewmodel.dart';
import 'package:merchandising_app/ui/splash/view_models/splash_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

abstract class ProvidersConfig {
  static List<SingleChildWidget> get providers => [
    ChangeNotifierProvider(create: (_) => LoginViewmodel()),
    ChangeNotifierProvider(create: (_) => LogoutViewmodel()),
    ChangeNotifierProvider(create: (_) => ChangeNotifier()),
    ChangeNotifierProvider(create: (_) => SplashViewmodel()),
  ];
}
