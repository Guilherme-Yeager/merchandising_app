import 'package:merchandising_app/data/service/exception/service_exception.dart';
import 'package:merchandising_app/domain/models/pedcab/pedcab_model.dart';
import 'package:merchandising_app/domain/models/pedcorp/pedcorp_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Serviço responsável por realizar operações nos dados do pedido no Supabase.
class PedidoService {
  /// Insere o cabeçalho do pedido.
  ///
  /// - [pedcabModel]: cabeçalho do pedido.
  ///
  /// Retorna `true` em caso de sucesso. Caso ocorra algum erro durante
  /// o insert, uma [ServiceException] será lançada contendo informações
  /// sobre o tipo de erro ocorrido.
  Future<int> inserirCabecalho(PedcabModel pedcabModel) async {
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
                'observacao': pedcabModel.observacao,
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
  /// Retorna true em caso de sucesso. Caso ocorra algum erro durante
  /// o insert, uma [ServiceException] será lançada contendo informações
  /// sobre o tipo de erro ocorrido.
  Future<bool> inserirCorpo(PedcorpModel pedcorpModel) async {
    try {
      await Supabase.instance.client.from('polibras_pedcorp').insert({
        'codigo_pedido': pedcorpModel.codigoPedido,
        'codigo_produto': pedcorpModel.codigoProduto,
        'quantidade': pedcorpModel.quantidade,
        'preco_venda': pedcorpModel.precoVenda,
        'preco_base': pedcorpModel.precoBase,
      });
      return true;
    } on Exception catch (exception) {
      throw ServiceException(exception);
    }
  }

  /// Atualiza o campo importado do cabeçalho do pedido para 9, onde indica
  /// para o supabase para levar o pedido para o ERP.
  ///
  /// - [codigoPedido]: código do pedido a ser atualizado.
  ///
  /// Não retorna nada. Caso ocorra algum erro durante o update, uma [ServiceException]
  /// será lançada contendo informações sobre o tipo de erro ocorrido.
  Future<void> atualizarImportadoCabecalho(int codigoPedido) async {
    try {
      await Supabase.instance.client
          .from('polibras_pedcab')
          .update({'importado': 9})
          .eq('codigo_pedido', codigoPedido);
      return;
    } on Exception catch (exception) {
      throw ServiceException(exception);
    }
  }
}
