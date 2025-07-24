class UserModel {
  final int matricula;
  final String nome;

  UserModel({required this.matricula, required this.nome});

  Map<String, dynamic> toJson() => {"matricula": matricula, "nome": nome};

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(matricula: json["matricula"], nome: json["nome"]);
  }
}
