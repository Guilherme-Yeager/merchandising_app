import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:merchandising_app/routing/routes.dart';
import 'package:merchandising_app/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:merchandising_app/ui/core/themes/app_colors.dart';
import 'package:merchandising_app/ui/home/view_models/home_viewmodel.dart';
import 'package:merchandising_app/ui/core/logger/app_logger.dart';
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
    final LoginViewmodel loginViewmodel = Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );
    final HomeViewmodel homeViewModel = Provider.of<HomeViewmodel>(context);

    // Dados
    final String userName =
        ReCase(loginViewmodel.userModel?.nome ?? "Usuário").titleCase;

    /// Páginas do AnimatedNotchBottomBar
    final Map<String, WidgetBuilder> routesMap = Routes.getRoutes();

    final List<Widget> bottomBarPages = [
      routesMap[Routes.menu]?.call(context) ?? SizedBox.shrink(),
      routesMap[Routes.cliente]?.call(context) ?? SizedBox.shrink(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          homeViewModel.titleAppBar == ""
              ? "Olá, $userName"
              : homeViewModel.titleAppBar,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 26.0),
        ),
        toolbarHeight: 100,
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
          } else if (index == 1) {
            homeViewModel.updateTitleAppBar("Clientes");
          }
          _pageController.jumpToPage(index);
        },
        kIconSize: 24.0,
      ),
    );
  }
}
