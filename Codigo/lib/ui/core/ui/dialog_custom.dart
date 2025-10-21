import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:merchandising_app/domain/models/produto/produto_model.dart';
import 'package:merchandising_app/ui/core/logger/app_logger.dart';
import 'package:merchandising_app/ui/produto/view_models/produto_viewmodel.dart';
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

  static Future<dynamic> showDialogQuantItens({
    required BuildContext context,
    required ProdutoModel produto,
    required ProdutoViewModel produtoViewModel,
  }) {
    int quantidade = 1;
    const int maxValor = 9999999;
    final TextEditingController quantidadeController = TextEditingController(
      text: quantidade.toString(),
    );
    return QuickAlert.show(
      context: context,
      type: QuickAlertType.custom,
      widget: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Produto ${produto.codprod}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text('Quantidade'),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.remove_circle,
                      color: Colors.blue,
                      size: 32,
                    ),
                    onPressed: () {
                      if (quantidade > 1) {
                        setState(() {
                          quantidade--;
                          quantidadeController.text = quantidade.toString();
                        });
                      }
                    },
                  ),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: quantidadeController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(7),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) {
                        int novoValor = int.tryParse(value) ?? 1;
                        if (novoValor > maxValor ||
                            novoValor > produto.qtest.toInt()) {
                          novoValor = quantidade;
                        } else if (novoValor != quantidade) {
                          quantidade = novoValor;
                        }
                        quantidadeController.text = quantidade.toString();
                        quantidadeController
                            .selection = TextSelection.collapsed(
                          offset: quantidadeController.text.length,
                        );
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle,
                      color: Colors.blue,
                      size: 32,
                    ),
                    onPressed: () {
                      if (quantidade == produto.qtest.toInt()) {
                        return;
                      }
                      if (quantidade < maxValor) {
                        setState(() {
                          quantidade++;
                          quantidadeController.text = quantidade.toString();
                          quantidadeController
                              .selection = TextSelection.collapsed(
                            offset: quantidadeController.text.length,
                          );
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
      confirmBtnText: "Adicionar",
      onConfirmBtnTap: () async {
        /// Se já estiver salvando um pedido não vai salvar
        /// novamente ao mesmo tempo.
        FocusScope.of(context).unfocus();

        produtoViewModel.selecionarProduto(produto, quantidade);

        if (context.mounted) {
          Navigator.of(context).pop(true);
        }
      },
    );
  }
}
