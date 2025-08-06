import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:merchandising_app/ui/auth/logout/view_models/logout_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

/// Classe responsável por exibir um diálogo de logout e gerenciar a confirmação do usuário.
class LogoutScreen {
  /// Exibe um diálogo de confirmação para o usuário antes de realizar o logout.
  Future<dynamic> showDialogLogout({
    required String title,
    required String message,
    required BuildContext context,
  }) {
    final LogoutViewModel logoutViewmodel = Provider.of<LogoutViewModel>(
      context,
      listen: false,
    );
    return QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: title,
      text: message,
      confirmBtnText: "Sim",
      cancelBtnText: "Não",
      onConfirmBtnTap: () async {
        await logoutViewmodel.logout();
        if (context.mounted) {
          Navigator.of(context).pop(true);
        }
      },
      onCancelBtnTap: () {
        Navigator.of(context).pop(false);
      },
    );
  }
}
