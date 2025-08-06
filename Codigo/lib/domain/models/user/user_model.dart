import 'package:merchandising_app/utils/helpers/text_helper.dart';

/// Modelo que representa um usuário autenticado no sistema.
class UserModel {
  /// Código do usuário.
  final int codusur;

  /// Nome do usuário.
  final String nome;

  /// Email do usuário.
  final String email;

  UserModel({required this.codusur, required this.nome, required this.email});

  Map<String, dynamic> toJson() => {
    "codusur": codusur,
    "nome": nome,
    "email": email,
  };

  /// A desserialização trata os valores nulos colocando valores
  /// padrão.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      codusur: json["codusur"],
      nome:
          json["nome"] != null
              ? TextHelper.extrairNome(json["nome"])
              : "Sem nome",
      email: json["email"],
    );
  }
}
