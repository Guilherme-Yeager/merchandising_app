import 'package:merchandising_app/data/repositories/auth/login_repository_impl.dart';
import 'package:merchandising_app/data/repositories/auth/logout_repository_impl.dart';
import 'package:merchandising_app/data/repositories/cliente/cliente_repository_impl.dart';
import 'package:merchandising_app/data/repositories/pedido/pedido_repository_impl.dart';
import 'package:merchandising_app/data/repositories/produto/produto_repository_impl.dart';
import 'package:merchandising_app/data/repositories/user/user_repository_impl.dart';
import 'package:merchandising_app/data/service/auth/login_service.dart';
import 'package:merchandising_app/data/service/auth/logout_service.dart';
import 'package:merchandising_app/data/service/cliente/cliente_service.dart';
import 'package:merchandising_app/data/service/pedido/pedido_service.dart';
import 'package:merchandising_app/data/service/produto/produto_service.dart';
import 'package:merchandising_app/data/service/user/user_service.dart';
import 'package:merchandising_app/domain/repositories/auth/login_repository.dart';
import 'package:merchandising_app/domain/repositories/auth/logout_reppository.dart';
import 'package:merchandising_app/domain/repositories/cliente/cliente_repository.dart';
import 'package:merchandising_app/domain/repositories/pedido/pedido_repository.dart';
import 'package:merchandising_app/domain/repositories/produto/produto_repository.dart';
import 'package:merchandising_app/domain/repositories/user/user_repository.dart';
import 'package:merchandising_app/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:merchandising_app/ui/auth/logout/view_models/logout_viewmodel.dart';
import 'package:merchandising_app/ui/cliente/view_models/cliente_viewmodel.dart';
import 'package:merchandising_app/ui/home/view_models/home_viewmodel.dart';
import 'package:merchandising_app/ui/pedido/view_models/pedido_viewmodel.dart';
import 'package:merchandising_app/ui/produto/view_models/produto_viewmodel.dart';
import 'package:merchandising_app/ui/splash/view_models/splash_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProvidersConfig {
  static List<SingleChildWidget> get providers => [
    /// Services
    Provider<LoginService>(create: (_) => LoginService()),
    Provider<ClienteService>(create: (_) => ClienteService()),
    Provider<UserService>(create: (_) => UserService()),
    Provider<LogoutService>(create: (_) => LogoutService()),
    Provider<ProdutoService>(create: (_) => ProdutoService()),
    Provider<PedidoService>(create: (_) => PedidoService()),

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
    ProxyProvider<ProdutoService, ProdutoRepository>(
      update:
          (_, produtoService, __) =>
              ProdutoRepositoryImpl(produtoService: produtoService),
    ),
    ProxyProvider<PedidoService, PedidoRepository>(
      update:
          (_, pedidoService, __) =>
              PedidoRepositoryImpl(pedidoService: pedidoService),
    ),

    /// ViewModels
    ChangeNotifierProvider(
      create:
          (context) => LoginViewModel(
            loginRepository: Provider.of<LoginRepository>(
              context,
              listen: false,
            ),
            userRepository: Provider.of<UserRepository>(context, listen: false),
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
    ChangeNotifierProvider(
      create:
          (context) => ProdutoViewModel(
            produtoRepistory: Provider.of<ProdutoRepository>(
              context,
              listen: false,
            ),
          ),
    ),
    ChangeNotifierProvider(
      create:
          (context) => PedidoViewModel(
            pedidoRepository: Provider.of<PedidoRepository>(
              context,
              listen: false,
            ),
          ),
    ),
    ChangeNotifierProvider(create: (_) => HomeViewModel()),
    ChangeNotifierProvider<SplashViewModel>(
      create: (_) => SplashViewModel(supabaseClient: Supabase.instance.client),
    ),
  ];
}
