class PedcorpModel {
  final int codigoPedido;
  final String codigoProduto;
  final int quantidade;
  final double precoVenda;
  final double precoBase;

  PedcorpModel({
    required this.codigoPedido,
    required this.codigoProduto,
    required this.quantidade,
    required this.precoVenda,
    required this.precoBase,
  });
}
