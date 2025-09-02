/// Modelo que representa um usuário autenticado no sistema.
class UserModel {
  /// Código do usuário.
  final int codusur;

  /// Nome do usuário.
  final String nome;

  /// Email do usuário.
  final String email;

  /// Código da linha de produto associada ao usuário.
  final int? codLinhaProd;

  UserModel({
    required this.codusur,
    required this.nome,
    required this.codLinhaProd,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
    "codusur": codusur,
    "nome": nome,
    "email": email,
    "codLinhaProd": codLinhaProd,
  };

  /// A desserialização trata os valores nulos colocando valores
  /// padrão.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      codusur: json["codusur"],
      nome: json["nome"],
      codLinhaProd: json["codlinhaprod"],
      email: json["email"],
    );
  }
}
