import 'package:flutter/material.dart';
import 'package:merchandising_app/ui/core/logger/app_logger.dart';
import 'package:quickalert/quickalert.dart';

abstract class DialogCustom {
  static Future<dynamic> showDialogInfo({
    required String title,
    required String message,
    String messageBtn = "OK",
    required BuildContext context,
  }) {
    return QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      title: title,
      text: message,
      confirmBtnText: messageBtn,
      onConfirmBtnTap: () => Navigator.of(context).pop(true),
      onCancelBtnTap: () => Navigator.of(context).pop(false),
    );
  }

  static Future<dynamic> showDialogWarning({
    required String title,
    required String message,
    String messageBtn = "OK",
    required BuildContext context,
  }) {
    return QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      title: title,
      text: message,
      confirmBtnText: messageBtn,
      onConfirmBtnTap: () => Navigator.of(context).pop(true),
      onCancelBtnTap: () => Navigator.of(context).pop(false),
    );
  }

  static Future<dynamic> showDialogSuccess({
    String title = "Sucesso",
    required String message,
    String messageBtn = "OK",
    required BuildContext context,
  }) {
    return QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: title,
      text: message,
      confirmBtnText: messageBtn,
      onConfirmBtnTap: () => Navigator.of(context).pop(true),
      onCancelBtnTap: () => Navigator.of(context).pop(false),
    );
  }

  static Future<dynamic> showDialogError({
    String title = "Oops...",
    required String message,
    String messageBtn = "OK",
    required BuildContext context,
  }) {
    return QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: title,
      text: message,
      confirmBtnText: messageBtn,
      onConfirmBtnTap: () => Navigator.of(context).pop(true),
      onCancelBtnTap: () => Navigator.of(context).pop(false),
    );
  }

  static Future<dynamic> showDialogConfirmation({
    required String title,
    required String message,
    required BuildContext context,
  }) {
    return QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: title,
      text: message,
      confirmBtnText: "Sim",
      cancelBtnText: "Não",
      onConfirmBtnTap: () {
        Navigator.of(context).pop(true);
        AppLogger.instance.i("Cliente confirmou a ação.");
      },
      onCancelBtnTap: () {
        Navigator.of(context).pop(false);
        AppLogger.instance.w("Cliente não confirmou a ação.");
      },
    );
  }
}
