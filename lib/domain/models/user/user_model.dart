import 'package:merchandising_app/utils/helpers/text_helper.dart';

class UserModel {
  final int codusur;
  final String nome;

  UserModel({required this.codusur, required this.nome});

  Map<String, dynamic> toJson() => {"codusur": codusur, "nome": nome};

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      codusur: json["codusur"],
      nome: TextHelper.extrairNome(json["nome"]),
    );
  }
}
