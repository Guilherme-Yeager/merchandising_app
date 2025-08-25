import 'package:merchandising_app/data/service/exception/service_exception.dart';
import 'package:merchandising_app/domain/models/pedcab/pedcab_model.dart';
import 'package:merchandising_app/domain/models/pedcorp/pedcorp_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Serviço responsável por obter inserir os dados do pedido no supabase.
class PedidoService {
  /// Insere o cabeçalho do pedido.
  ///
  /// - [pedcabModel]: cabeçalho do pedido.
  ///
  /// Retorna true em caso de sucesso. Já caso ocorra algum erro durante
  /// o insert, uma [ServiceException] será lançada contendo informações
  /// sobre o tipo de erro ocorrido.
  Future<int> insertPedCab(PedcabModel pedcabModel) async {
    try {
      final Map<String, dynamic>? codigoPedido =
          await Supabase.instance.client
              .from('polibras_pedcab')
              .insert({
                'orgvenda': pedcabModel.orgvenda,
                'data_pedido': pedcabModel.dataPedido,
                'codigo_vendedor': pedcabModel.codigoVendedor,
                'codigo_cliente': pedcabModel.codigoCliente,
                'codigo_cobranca': pedcabModel.codigoCobranca,
                'codigo_planopagamento': pedcabModel.codigoPlanoPagamento,
                'codigo_tabela': pedcabModel.codigoTabela,
                'tipo_venda': pedcabModel.tipoVenda,
                'importado': pedcabModel.importado,
              })
              .select('codigo_pedido')
              .maybeSingle();
      return codigoPedido!['codigo_pedido'];
    } on Exception catch (exception) {
      throw ServiceException(exception);
    }
  }

  /// Insere o corpo do pedido.
  ///
  /// - [pedcorpModel]: corpo do pedido.
  ///
  /// Retorna true em caso de sucesso. Já caso ocorra algum erro durante
  /// o insert, uma [ServiceException] será lançada contendo informações
  /// sobre o tipo de erro ocorrido.
  Future<bool> insertPedCorp(PedcorpModel pedcorpModel) async {
    try {
      await Supabase.instance.client.from('polibras_pedcorp').insert({
        'codigo_pedido': pedcorpModel.codigoPedido,
        'codigo_produto': pedcorpModel.codigoProduto,
        'quantidade': pedcorpModel.quantidade,
        'preco_venda': pedcorpModel.precoVenda.toInt(),
        'preco_base': pedcorpModel.precoBase.toInt(),
      });
      return true;
    } on Exception catch (exception) {
      throw ServiceException(exception);
    }
  }
}
