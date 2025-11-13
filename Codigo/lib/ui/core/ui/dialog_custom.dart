import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:merchandising_app/domain/models/produto/produto_model.dart';
import 'package:merchandising_app/ui/core/logger/app_logger.dart';
import 'package:merchandising_app/ui/core/themes/app_colors.dart';
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
    int quantidade = 1,
  }) {
    const int maxValor = 9999999;
    final TextEditingController quantidadeController = TextEditingController(
      text: quantidade.toString(),
    );
    String? imagem = 'assets/images/teste.jpeg';
    return showDialog(
      context: context,
      builder: (context) {
        int quantidadeLocal = quantidade;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: Image.asset(
                          imagem ?? 'assets/images/sem-imagem.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
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
                            if (quantidadeLocal > 1) {
                              setState(() {
                                quantidadeLocal--;
                                quantidadeController.text =
                                    quantidadeLocal.toString();
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
                                novoValor = quantidadeLocal;
                              } else if (novoValor != quantidadeLocal) {
                                quantidadeLocal = novoValor;
                              }
                              quantidadeController.text =
                                  quantidadeLocal.toString();
                              quantidadeController
                                  .selection = TextSelection.collapsed(
                                offset: quantidadeController.text.length,
                              );
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 8,
                              ),
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
                            if (quantidadeLocal == produto.qtest.toInt()) {
                              return;
                            }
                            if (quantidadeLocal < maxValor) {
                              setState(() {
                                quantidadeLocal++;
                                quantidadeController.text =
                                    quantidadeLocal.toString();
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
                ),
              ),
              actions: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        Navigator.of(context).pop(false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonLogin,
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        produtoViewModel.selecionarProduto(
                          produto,
                          quantidadeLocal,
                        );
                        if (context.mounted) {
                          Navigator.of(context).pop(true);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonLogin,
                      ),
                      child: const Text(
                        'Adicionar',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
