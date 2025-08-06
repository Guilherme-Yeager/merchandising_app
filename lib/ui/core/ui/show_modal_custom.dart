import 'package:flutter/material.dart';
import 'package:merchandising_app/domain/models/cliente/cliente_model.dart';
import 'package:merchandising_app/ui/core/ui/text_form_field_custom.dart';

abstract class ShowModalCustom {
  /// Exbie um `showModalBottomSheet` com informações do cliente
  ///
  /// - [context] contexto fornecido.
  /// - [cliente] modelo do cliente para exibição dos detalhes.
  static Future<void> mostrarDetalhesCliente(
    BuildContext context,
    ClienteModel cliente,
  ) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 25.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FractionallySizedBox(
                  widthFactor: 0.5,
                  child: TextFormFieldCustom.buildTextFormField(
                    initialValue: cliente.codcli.toString(),
                    labelText: "Código",
                  ),
                ),
                const SizedBox(height: 15),
                TextFormFieldCustom.buildTextFormField(
                  initialValue: cliente.cliente,
                  labelText: "Nome",
                ),
                const SizedBox(height: 15),
                TextFormFieldCustom.buildTextFormField(
                  initialValue: cliente.fantasia,
                  labelText: "Nome Fantasia",
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Flexible(
                      child: TextFormFieldCustom.buildTextFormField(
                        initialValue: cliente.municent,
                        labelText: "Munícipio",
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      flex: 2,
                      child: TextFormFieldCustom.buildTextFormField(
                        initialValue: cliente.enderent,
                        labelText: "Endereço",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                FractionallySizedBox(
                  widthFactor: 0.5,
                  child: TextFormFieldCustom.buildTextFormField(
                    initialValue: cliente.telent,
                    labelText: "Telefone",
                  ),
                ),
                const SizedBox(height: 15),

                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }
}
