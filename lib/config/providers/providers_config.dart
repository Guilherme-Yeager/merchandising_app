import 'package:merchandising_app/data/repositories/auth/login_repository_impl.dart';
import 'package:merchandising_app/data/repositories/auth/logout_repository_impl.dart';
import 'package:merchandising_app/data/repositories/cliente/cliente_repository_impl.dart';
import 'package:merchandising_app/data/repositories/user/user_repository_impl.dart';
import 'package:merchandising_app/data/service/auth/login_service.dart';
import 'package:merchandising_app/data/service/auth/logout_service.dart';
import 'package:merchandising_app/data/service/cliente/cliente_service.dart';
import 'package:merchandising_app/data/service/user/user_service.dart';
import 'package:merchandising_app/domain/repositories/auth/login_repository.dart';
import 'package:merchandising_app/domain/repositories/auth/logout_reppository.dart';
import 'package:merchandising_app/domain/repositories/cliente/cliente_repository.dart';
import 'package:merchandising_app/domain/repositories/user/user_repository.dart';
import 'package:merchandising_app/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:merchandising_app/ui/auth/logout/view_models/logout_viewmodel.dart';
import 'package:merchandising_app/ui/cliente/view_models/cliente_viewmodel.dart';
import 'package:merchandising_app/ui/home/view_models/home_viewmodel.dart';
import 'package:merchandising_app/ui/splash/view_models/splash_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

abstract class ProvidersConfig {
  static List<SingleChildWidget> get providers => [
    /// Services
    Provider<LoginService>(create: (_) => LoginService()),
    Provider<ClienteService>(create: (_) => ClienteService()),
    Provider<UserService>(create: (_) => UserService()),
    Provider<LogoutService>(create: (_) => LogoutService()),

    /// Repositories
    ProxyProvider2<LoginService, UserService, LoginRepository>(
      update:
          (_, loginService, userService, __) => LoginRepositoryImpl(
            loginService: loginService,
            userService: userService,
          ),
    ),
    ProxyProvider<UserService, UserRepository>(
      update:
          (_, userService, __) => UserRepositoryImpl(userService: userService),
    ),
    ProxyProvider<ClienteService, ClienteRepository>(
      update:
          (_, clienteService, __) =>
              ClienteRepositoryImpl(clienteService: clienteService),
    ),
    ProxyProvider<LogoutService, LogoutRepository>(
      update:
          (_, logoutService, __) =>
              LogoutRepositoryImpl(logoutService: logoutService),
    ),

    /// ViewModels
    ChangeNotifierProvider(
      create:
          (context) => LoginViewmodel(
            loginRepository: Provider.of<LoginRepository>(
              context,
              listen: false,
            ),
          ),
    ),
    ChangeNotifierProvider(
      create:
          (context) => LogoutViewModel(
            logoutReppository: Provider.of<LogoutRepository>(
              context,
              listen: false,
            ),
          ),
    ),
    ChangeNotifierProvider(
      create:
          (context) => ClienteViewModel(
            clienteRepository: Provider.of<ClienteRepository>(
              context,
              listen: false,
            ),
          ),
    ),
    ChangeNotifierProvider(create: (_) => HomeViewmodel()),
    ChangeNotifierProvider(create: (_) => SplashViewmodel()),
  ];
}
