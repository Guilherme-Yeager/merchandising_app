/// Modelo que representa um pedido associado a um cliente.
class ProdutoModel {
  /// Código do produto.
  final int codprod;

  /// Descrição do produto.
  final String descricao;

  /// Quantidade disponível do produto
  final double qtest;

  /// Preço de venda do produto.
  final double pvenda;

  ProdutoModel({
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

  /// A desserialização trata os valores nulos colocando valores
  /// padrão.
  factory ProdutoModel.fromJson(Map<String, dynamic> json) {
    return ProdutoModel(
      codprod: json["codprod"],
      descricao: json["descricao"] ?? "Sem descrição",
      qtest: json["qtest"] ?? 0,
      pvenda: json["pvenda"] ?? 0,
    );
  }
}
