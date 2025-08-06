import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:merchandising_app/routing/routes.dart';
import 'package:merchandising_app/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:merchandising_app/ui/cliente/view_models/cliente_viewmodel.dart';
import 'package:merchandising_app/ui/core/themes/app_colors.dart';
import 'package:merchandising_app/ui/home/view_models/home_viewmodel.dart';
import 'package:merchandising_app/ui/core/logger/app_logger.dart';
import 'package:merchandising_app/ui/produto/view_models/produto_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  final NotchBottomBarController _notchBottomBarController =
      NotchBottomBarController(index: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// ViewModels
    final LoginViewModel loginViewModel = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );
    final ClienteViewModel clienteViewModel = Provider.of<ClienteViewModel>(
      context,
    );
    final ProdutoViewModel produtoViewModel = Provider.of<ProdutoViewModel>(
      context,
      listen: false,
    );
    final HomeViewModel homeViewModel = Provider.of<HomeViewModel>(context);

    // Dados
    final String userName =
        ReCase(loginViewModel.userModel?.nome ?? "Usuário").titleCase;

    /// Páginas do AnimatedNotchBottomBar
    final Map<String, WidgetBuilder> routesMap = Routes.getRoutes();

    final List<Widget> bottomBarPages = [
      routesMap[Routes.menu]?.call(context) ?? SizedBox.shrink(),

      /// Se houver um cliente selecionado, exibe a tela de pedido
      clienteViewModel.clienteSelecionado != null
          ? routesMap[Routes.produto]?.call(context) ?? SizedBox.shrink()
          : routesMap[Routes.cliente]?.call(context) ?? SizedBox.shrink(),
    ];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              homeViewModel.titleAppBar == ""
                  ? "Olá, $userName"
                  : homeViewModel.titleAppBar,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 26.0),
            ),
            if (homeViewModel.subtitleAppBar != null) ...[
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    homeViewModel.titleAppBar == "Produtos"
                        ? Icons.production_quantity_limits_outlined
                        : Icons.group_outlined,
                    size: 21.3,
                  ),
                  SizedBox(width: 5),
                  Text(
                    homeViewModel.subtitleAppBar!,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ],
            if (clienteViewModel.clienteSelecionado != null &&
                homeViewModel.titleAppBar == "Produtos") ...[
              SizedBox(height: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: 0.52,
                  child: InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(Icons.contact_page_outlined, size: 21.3),
                        SizedBox(width: 5),
                        Text(
                          "Cliente Selecionado",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
          bottomBarPages.length,
          (index) => bottomBarPages[index],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _notchBottomBarController,
        color: Colors.white,
        showLabel: true,
        textOverflow: TextOverflow.visible,
        maxLine: 1,
        shadowElevation: 5,
        kBottomRadius: 16.0,
        notchColor: AppColors.activeMenu,
        removeMargins: false,
        bottomBarWidth: 500,
        showShadow: false,
        durationInMilliSeconds: 300,
        elevation: 1,
        bottomBarItems: const [
          BottomBarItem(
            inActiveItem: Icon(Icons.home_outlined, color: Colors.black),
            activeItem: Icon(Icons.home_outlined, color: Colors.black),
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.group_outlined, color: Colors.black),
            activeItem: Icon(Icons.group_outlined, color: Colors.black),
          ),
        ],
        onTap: (index) {
          AppLogger.instance.i("Página selecionada: ${bottomBarPages[index]}");
          if (index == 0) {
            homeViewModel.updateTitleAppBar("");
            homeViewModel.updateSubtitleAppBar(null);
          } else if (index == 1) {
            /// Caso haja um cliente seleconado, altera o título do AppBar
            /// para "Pedido", caso contrário, mantém "Clientes"
            if (clienteViewModel.clienteSelecionado != null) {
              produtoViewModel.limparFiltro();
              homeViewModel.updateTitleAppBar("Produtos");
              homeViewModel.updateSubtitleAppBar(
                "Total: ${produtoViewModel.produtosComFiltro.length}",
              );
            } else {
              clienteViewModel.limparFiltro();
              homeViewModel.updateTitleAppBar("Clientes");
              homeViewModel.updateSubtitleAppBar(
                "Total: ${clienteViewModel.clientesComFiltro.length}",
              );
            }
          }
          _pageController.jumpToPage(index);
        },
        kIconSize: 24.0,
      ),
    );
  }
}
