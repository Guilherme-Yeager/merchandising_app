/// Modelo que representa um pedido associado a um cliente.
class PedidoModel {
  /// Código do produto.
  final int codprod;

  /// Descrição do produto.
  final String descricao;

  /// Quantidade disponível do produto
  final double qtest;

  /// Preço de venda do produto.
  final double pvenda;

  PedidoModel({
    required this.codprod,
    required this.descricao,
    required this.qtest,
    required this.pvenda,
  });

  Map<String, dynamic> toJson() => {
    "codprod": codprod,
    "descricao": descricao,
    "qtest": qtest,
    "pvenda": pvenda,
  };

  factory PedidoModel.fromJson(Map<String, dynamic> json) {
    return PedidoModel(
      codprod: json["codprod"],
      descricao: json["descricao"],
      qtest: json["qtest"],
      pvenda: json["pvenda"],
    );
  }
}
