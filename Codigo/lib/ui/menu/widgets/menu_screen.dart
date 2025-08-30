import 'package:flutter/material.dart';
import 'package:merchandising_app/config/supabase/supabase_config.dart';
import 'package:merchandising_app/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:merchandising_app/ui/auth/logout/widgets/logout_screen.dart';
import 'package:merchandising_app/ui/core/logger/app_logger.dart';
import 'package:merchandising_app/ui/core/themes/app_colors.dart';
import 'package:merchandising_app/ui/core/ui/show_modal_custom.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    /// ViewModels
    final LoginViewModel loginViewModel = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );

    // Cards
    final List<InkWell> cards = _getInkWells(loginViewModel);

    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: GridView.builder(
        padding: const EdgeInsets.all(28.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: 40.0,
          mainAxisSpacing: 40.0,
        ),
        itemCount: cards.length,
        itemBuilder: (_, index) {
          return cards[index];
        },
      ),
    );
  }

  /// Retorna uma lista de `InkWell` que são `Cards` clicáveis que representam
  /// as opções do menu.
  ///
  /// - [loginViewModel] é  ViewModel de login
  List<InkWell> _getInkWells(LoginViewModel loginViewModel) {
    return [
      InkWell(
        onTap: () {
          ShowModalCustom.mostrarDetalhesUsuario(
            context,
            loginViewModel.userModel!,
          );
          AppLogger.instance.i("Opcão 'Meus dados' selecionada.");
        },
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.assignment_outlined, size: 50, color: Colors.black),
              const SizedBox(height: 6),
              const Text(
                "Meus dados",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
      InkWell(
        onTap: () async {
          AppLogger.instance.i("Opcão 'Sair' selecionada.");

          /// Instância de LogoutScreen para exibir o diálogo de confirmação de logout.
          final LogoutScreen logoutScreen = LogoutScreen();

          /// Resposta do diálogo de logout.
          /// Pode ser `true` se o usuário confirmar o logout ou `false` se cancelar.
          /// Ou `null` se o diálogo for fechado sem ação.
          final dynamic response = await logoutScreen.showDialogLogout(
            title: "Sair",
            message: "Você tem certeza que deseja sair?",
            context: context,
          );
          if (response == true) {
            if (mounted) {
              SupabaseConfig.unsubscribeRealTimeChanges();
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (Route<dynamic> route) => false,
              );
              AppLogger.instance.i("Usuário confirmou o logout.");
            }
          } else {
            AppLogger.instance.i("Usuário cancelou o logout.");
          }
        },
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.logout_outlined, size: 50, color: Colors.black),
              const SizedBox(height: 6),
              const Text(
                "Sair",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    ];
  }
}
