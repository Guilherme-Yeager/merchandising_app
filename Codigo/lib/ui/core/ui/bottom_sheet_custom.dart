import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sweetsheet/sweetsheet.dart';

abstract class BottomSheetCustom {
  static final SweetSheet _sweetSheet = SweetSheet();

  static Future<bool> deleteConfirmation({
    required BuildContext context,
    required String title,
    required String message,
  }) async {
    final Completer<bool> completer = Completer<bool>();

    _sweetSheet.show(
      context: context,
      title: Text(title),
      description: Text(message),
      color: SweetSheetColor.DANGER,
      positive: SweetSheetAction(
        onPressed: () {
          if (!completer.isCompleted) {
            completer.complete(true);
          }
          Navigator.of(context).pop();
        },
        title: 'Excluir',
      ),
      negative: SweetSheetAction(
        onPressed: () {
          if (!completer.isCompleted) {
            completer.complete(false);
          }
          Navigator.of(context).pop();
        },
        title: 'Cancelar',
      ),
    );

    try {
      return await completer.future.timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          if (!completer.isCompleted) {
            completer.complete(false);
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          }
          return false;
        },
      );
    } catch (_) {
      return false;
    }
  }
}
