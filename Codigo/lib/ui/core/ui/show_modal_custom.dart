import 'package:flutter/material.dart';
import 'package:merchandising_app/domain/models/cliente/cliente_model.dart';
import 'package:merchandising_app/domain/models/user/user_model.dart';
import 'package:merchandising_app/ui/core/ui/text_form_field_custom.dart';

abstract class ShowModalCustom {
  /// Exbie um `showModalBottomSheet` com informações do cliente.
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
            child: ScrollbarTheme(
              data: ScrollbarThemeData(crossAxisMargin: -10.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close_outlined),
                    ),
                    Center(
                      child: Text(
                        "Detalhes do Cliente",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
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
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Exbie um `showModalBottomSheet` com informações do usuário logado.
  ///
  /// - [context] contexto fornecido.
  /// - [userModel] modelo do usuário para exibição dos detalhes.
  static Future<void> mostrarDetalhesUsuario(
    BuildContext context,
    UserModel userModel,
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
            child: ScrollbarTheme(
              data: ScrollbarThemeData(crossAxisMargin: -10.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close_outlined),
                    ),
                    Center(
                      child: Text(
                        "Perfil",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    FractionallySizedBox(
                      widthFactor: 0.5,
                      child: TextFormFieldCustom.buildTextFormField(
                        initialValue: userModel.codusur.toString(),
                        labelText: "Código",
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormFieldCustom.buildTextFormField(
                      initialValue: userModel.nome,
                      labelText: "Nome",
                    ),
                    const SizedBox(height: 15),
                    TextFormFieldCustom.buildTextFormField(
                      initialValue: userModel.email,
                      labelText: "E-mail",
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
