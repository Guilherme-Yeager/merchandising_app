import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:merchandising_app/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:merchandising_app/ui/cliente/widgets/cliente_screen.dart';
import 'package:merchandising_app/ui/core/logger/app_logger.dart';
import 'package:merchandising_app/ui/pedido/widgets/pedido_screen.dart';
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
    // Dados
    final String userName =
        ReCase(loginViewmodel.userModel?.nome ?? "Usuário").titleCase;

    /// Páginas do Bottom Bar
    final List<Widget> bottomBarPages = [ClienteScreen(), PedidoScreen()];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Olá, $userName",
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
        kBottomRadius: 28.0,
        notchColor: Colors.white,
        removeMargins: false,
        bottomBarWidth: 500,
        showShadow: false,
        durationInMilliSeconds: 300,
        itemLabelStyle: const TextStyle(fontSize: 10),
        elevation: 1,
        bottomBarItems: const [
          BottomBarItem(
            inActiveItem: Icon(Icons.person_2_outlined, color: Colors.black),
            activeItem: Icon(Icons.person_2_outlined, color: Colors.black),
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.inventory_2_outlined, color: Colors.black),
            activeItem: Icon(Icons.inventory_2_outlined, color: Colors.black),
          ),
        ],
        onTap: (index) {
          AppLogger.instance.i("Página selecionada: ${bottomBarPages[index]}");
          _pageController.jumpToPage(index);
        },
        kIconSize: 24.0,
      ),
    );
  }
}
