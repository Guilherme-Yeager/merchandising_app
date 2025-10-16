class PedcabModel {
  final int orgvenda = 2;
  final String dataPedido;
  final String codigoVendedor;
  final String codigoCliente;
  final String codigoCobranca = 'MKTN';
  final String codigoPlanoPagamento = '10';
  final String codigoTabela = '1';
  final String tipoVenda = '1';
  final int importado = 1;

  PedcabModel({
    required this.dataPedido,
    required this.codigoVendedor,
    required this.codigoCliente,
  });
}
