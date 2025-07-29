/// Modelo que representa um cliente associado ao usuário logado.
class ClienteModel {
  /// Código do cliente.
  final int codcli;

  /// Nome do cliente.
  final String cliente;

  /// Nome fantasia do cliente.
  final String fantasia;

  /// Telefone do cliente.
  final String telent;

  /// Endereço do cliente.
  final String enderent;

  /// Município do cliente.
  final String municent;

  /// Bairro do cliente.
  final String bairrocob;

  /// CNPJ do cliente.
  final String cgcent;

  ClienteModel({
    required this.codcli,
    required this.cliente,
    required this.fantasia,
    required this.telent,
    required this.enderent,
    required this.municent,
    required this.bairrocob,
    required this.cgcent,
  });

  Map<String, dynamic> toJson() => {
    "codcli": codcli,
    "cliente": cliente,
    "fantasia": fantasia,
    "telent": telent,
    "enderent": enderent,
    "municent": municent,
    "bairrocob": bairrocob,
    "cgcent": cgcent,
  };

  factory ClienteModel.fromJson(Map<String, dynamic> json) {
    return ClienteModel(
      codcli: json["codcli"],
      cliente: json["cliente"],
      fantasia: json["fantasia"],
      telent: json["telent"],
      enderent: json["enderent"],
      municent: json["municent"],
      bairrocob: json["bairrocob"],
      cgcent: json["cgcent"],
    );
  }
}
