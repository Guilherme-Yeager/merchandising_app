import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:merchandising_app/data/service/exception/service_exception.dart';
import 'package:merchandising_app/domain/models/pedcab/pedcab_model.dart';
import 'package:merchandising_app/domain/models/pedcorp/pedcorp_model.dart';
import 'package:merchandising_app/domain/models/produto/produto_model.dart';
import 'package:merchandising_app/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:merchandising_app/ui/cliente/view_models/cliente_viewmodel.dart';
import 'package:merchandising_app/ui/core/logger/app_logger.dart';
import 'package:merchandising_app/ui/core/themes/app_colors.dart';
import 'package:merchandising_app/ui/core/ui/dialog_custom.dart';
import 'package:merchandising_app/ui/core/ui/error_screen.dart';
import 'package:merchandising_app/ui/core/ui/offline_screen.dart';
import 'package:merchandising_app/ui/core/ui/text_form_field_custom.dart';
import 'package:merchandising_app/ui/home/view_models/home_viewmodel.dart';
import 'package:merchandising_app/ui/pedido/view_models/pedido_viewmodel.dart';
import 'package:merchandising_app/ui/produto/view_models/produto_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class ProdutoScreen extends StatefulWidget {
  const ProdutoScreen({super.key});

  @override
  State<ProdutoScreen> createState() => _ProdutoScreenState();
}

class _ProdutoScreenState extends State<ProdutoScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  /// Lista de controllers para gerenciar a expansão dos produtos.
  List<ExpansibleController> _expansibleControllers = [];
  int? _produtoSelecionado;

  bool salvandoPedido = false;

  @override
  Widget build(BuildContext context) {
    /// ViewModels
    final HomeViewModel homeViewModel = Provider.of<HomeViewModel>(
      context,
      listen: false,
    );
    final ClienteViewModel clienteViewModel = Provider.of<ClienteViewModel>(
      context,
      listen: false,
    );
    final LoginViewModel loginViewModel = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );
    final ProdutoViewModel produtoViewModel = Provider.of<ProdutoViewModel>(
      context,
    );
    final PedidoViewModel pedidoViewModel = Provider.of<PedidoViewModel>(
      context,
      listen: false,
    );

    /// Cards com informações dos produtos
    final List<Card> produtos = _getProdutos(
      clienteViewModel,
      produtoViewModel,
      loginViewModel,
      homeViewModel,
      pedidoViewModel,
    );

    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: 0.38,
                child: InkWell(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    DialogCustom.showDialogWarning(
                      context: context,
                      title: "Cancelar",
                      message:
                          "Tem certeza que deseja cancelar?\n As alterações serão perdidas.",
                    ).then((result) {
                      if (result == true) {
                        if (context.mounted) {
                          retornaScreenCliente(homeViewModel, clienteViewModel);
                        }
                      }
                    });
                  },
                  child: Row(
                    textBaseline: TextBaseline.alphabetic,
                    children: const [
                      Icon(
                        Icons.arrow_back_outlined,
                        color: Colors.white,
                        size: 22,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Cancelar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SearchBar(
              controller: _searchController,
              hintText: "Pesquisar produto",
              hintStyle: WidgetStateProperty.all(
                TextStyle(color: AppColors.placeholder, fontSize: 18),
              ),
              onChanged: (text) {
                produtoViewModel.filtrarProdutos(text);
                homeViewModel.updateSubtitleAppBar(
                  "Total: ${produtoViewModel.produtosComFiltro.length}",
                );
              },
              leading: const Icon(Icons.search),
              trailing: <Widget>[
                Tooltip(
                  message: "Limpar pesquisa",
                  child: IconButton(
                    onPressed: () {
                      _searchController.clear();
                      FocusScope.of(context).unfocus();
                      produtoViewModel.filtrarProdutos("");
                      homeViewModel.updateSubtitleAppBar(
                        "Total: ${produtoViewModel.produtosComFiltro.length}",
                      );
                    },
                    icon: const Icon(Icons.clear_outlined),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child:
                  produtos.isEmpty
                      ? Center(
                        child: const Text(
                          "Nenhum produto encontrado.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                      : ScrollbarTheme(
                        data: ScrollbarThemeData(crossAxisMargin: -4.0),
                        child: RefreshIndicator(
                          onRefresh: () async {
                            FocusScope.of(context).unfocus();
                            try {
                              await produtoViewModel.updateProdutos();
                            } on ServiceException catch (exception) {
                              if (exception.tipo == TipoErro.offline) {
                                await Future.delayed(Duration(seconds: 1));
                                if (context.mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => OfflineScreen(),
                                    ),
                                  );
                                }
                              } else {
                                await Future.delayed(Duration(seconds: 1));
                                if (context.mounted) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => ErrorScreen(
                                            mensagem: exception.mensagem,
                                          ),
                                    ),
                                  );
                                }
                                return;
                              }
                            }
                          },
                          child: Scrollbar(
                            controller: _scrollController,
                            thumbVisibility: true,
                            thickness: 6,
                            radius: const Radius.circular(8),
                            child: ListView(
                              controller: _scrollController,
                              children: produtos,
                            ),
                          ),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  /// Responsável por construir os cards dos produtos a serem exibidos.
  ///
  /// - [clienteViewModel] é a ViewModel do Cliente.
  /// - [produtoViewModel] é a ViewModel do Produto.
  /// - [loginViewModel] é a ViewModel de Login.
  /// - [homeViewModel] é a ViewModel de Home.
  /// - [pedidoViewModel] é a ViewModel de Pedido.
  ///
  /// Retorna uma lista de cards, sendo cada um deles, um produto da base de dados.
  List<Card> _getProdutos(
    ClienteViewModel clienteViewModel,
    ProdutoViewModel produtoViewModel,
    LoginViewModel loginViewModel,
    HomeViewModel homeViewModel,
    PedidoViewModel pedidoViewModel,
  ) {
    List<ProdutoModel> produtos = produtoViewModel.produtosComFiltro;
    if (produtos.isEmpty) {
      return [];
    }
    _sincronizarExpansibleControllers(produtos.length);
    return produtos.asMap().entries.map((entry) {
      final int index = entry.key;
      final ProdutoModel produto = entry.value;
      final bool isSelected = _produtoSelecionado == index;
      return Card(
        color: isSelected ? AppColors.activeCard : AppColors.inactiveCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: ExpansionTile(
          initiallyExpanded: isSelected,
          controller: _expansibleControllers[index],
          onExpansionChanged: (value) {
            setState(() {
              if (value) {
                /// Expande o cliente selecionado e colapsa o anterior
                if (_produtoSelecionado != null &&
                    _produtoSelecionado != index) {
                  _expansibleControllers[_produtoSelecionado!].collapse();
                  _expansibleControllers[index].expand();
                }

                /// Atualiza o cliente selecionado
                _produtoSelecionado = index;

                /// Colapsa o cliente selecionado se ele já estiver expandido
              } else if (isSelected) {
                _produtoSelecionado = null;
              }
            });
          },
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  produto.codprod.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                produto.descricao,
                style: const TextStyle(fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          children: [
            Divider(color: Colors.black, thickness: 1, height: 1),
            SizedBox(height: 5),
            Text(
              "Detalhes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 40,
                          child: TextFormFieldCustom.buildTextFormField(
                            initialValue: produto.codprod.toString(),
                            labelText: "Código",
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 60,
                          child: TextFormFieldCustom.buildTextFormField(
                            initialValue: produto.pvenda.toString(),
                            labelText: "Preço de Venda",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    FractionallySizedBox(
                      widthFactor: 0.65,
                      child: TextFormFieldCustom.buildTextFormField(
                        initialValue: produto.qtest.toInt().toString(),
                        labelText: "Quantidade disponível",
                      ),
                    ),

                    const SizedBox(height: 10),
                    TextFormFieldCustom.buildTextFormField(
                      initialValue: produto.descricao,
                      labelText: "Descrição",
                      maxLines: 3,
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          int quantidade = 1;
                          const int maxValor = 9999999;
                          final TextEditingController quantidadeController =
                              TextEditingController(
                                text: quantidade.toString(),
                              );
                          await QuickAlert.show(
                            context: context,
                            type: QuickAlertType.custom,
                            widget: StatefulBuilder(
                              builder: (context, setState) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Produto ${produto.codprod}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text('Quantidade'),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.remove_circle,
                                            color: Colors.blue,
                                            size: 32,
                                          ),
                                          onPressed: () {
                                            if (quantidade > 1) {
                                              setState(() {
                                                quantidade--;
                                                quantidadeController.text =
                                                    quantidade.toString();
                                              });
                                            }
                                          },
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: TextField(
                                            controller: quantidadeController,
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                7,
                                              ),
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            onChanged: (value) {
                                              int novoValor =
                                                  int.tryParse(value) ?? 1;
                                              if (novoValor != quantidade) {
                                                quantidade = novoValor;
                                              }
                                              quantidadeController.text =
                                                  quantidade.toString();
                                              quantidadeController.selection =
                                                  TextSelection.collapsed(
                                                    offset:
                                                        quantidadeController
                                                            .text
                                                            .length,
                                                  );
                                              setState(() {});
                                            },
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 8,
                                                  ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.add_circle,
                                            color: Colors.blue,
                                            size: 32,
                                          ),
                                          onPressed: () {
                                            if (quantidade < maxValor) {
                                              setState(() {
                                                quantidade++;
                                                quantidadeController.text =
                                                    quantidade.toString();
                                                quantidadeController.selection =
                                                    TextSelection.collapsed(
                                                      offset:
                                                          quantidadeController
                                                              .text
                                                              .length,
                                                    );
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                            confirmBtnText: "Salvar",
                            onConfirmBtnTap:
                                salvandoPedido
                                    ? null
                                    : () async {
                                      /// Se já estiver salvando um pedido não vai salvar
                                      /// novamente ao mesmo tempo.
                                      if (salvandoPedido) {
                                        return;
                                      }
                                      FocusScope.of(context).unfocus();

                                      setState(() {
                                        salvandoPedido = !salvandoPedido;
                                      });

                                      /// Modelo do cabeçalho do pedido
                                      PedcabModel pedcabModel = PedcabModel(
                                        dataPedido: DateFormat(
                                          'dd/MM/yyyy',
                                        ).format(DateTime.now()),
                                        codigoVendedor:
                                            loginViewModel.userModel!.codusur
                                                .toString(),
                                        codigoCliente:
                                            clienteViewModel
                                                .clienteSelecionado!
                                                .codcli
                                                .toString(),
                                      );

                                      AppLogger.instance.i(
                                        "Cabeçalho do pedido: ${pedcabModel.dataPedido} | ${pedcabModel.codigoVendedor} | ${pedcabModel.codigoCliente}",
                                      );

                                      /// Inserindo cabeçalho do pedido e obtendo o código do mesmo.
                                      try {
                                        final int codigoPedido =
                                            await pedidoViewModel
                                                .inserirCabecalhoPedido(
                                                  pedcabModel,
                                                );

                                        double? precoVenda =
                                            await produtoViewModel
                                                .getPrecoVenda(produto.codprod);

                                        if (precoVenda == null) {
                                          AppLogger.instance.w(
                                            "O produto não possui preço de venda.",
                                          );
                                          precoVenda = 0;
                                        }

                                        /// Modelo do corpo do pedido
                                        PedcorpModel pedcorpModel =
                                            PedcorpModel(
                                              codigoPedido: codigoPedido,
                                              codigoProduto:
                                                  produto.codprod.toString(),
                                              quantidade: quantidade,
                                              precoVenda: precoVenda,
                                              precoBase: precoVenda,
                                            );

                                        AppLogger.instance.i(
                                          "Corpo do pedido: ${pedcorpModel.codigoPedido} | ${pedcorpModel.codigoProduto} | ${pedcorpModel.quantidade} | ${pedcorpModel.precoVenda} | ${pedcorpModel.precoVenda}",
                                        );

                                        /// Inserindo corpo do pedido.
                                        await pedidoViewModel
                                            .inserirCorpoPedido(pedcorpModel);
                                      } on ServiceException catch (exception) {
                                        if (exception.tipo ==
                                            TipoErro.offline) {
                                          await Future.delayed(
                                            Duration(seconds: 1),
                                          );
                                          if (mounted) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => OfflineScreen(),
                                              ),
                                            );
                                            return;
                                          }
                                        } else {
                                          await Future.delayed(
                                            Duration(seconds: 1),
                                          );
                                          if (mounted) {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (_) => ErrorScreen(
                                                      mensagem:
                                                          exception.mensagem,
                                                    ),
                                              ),
                                            );
                                          }
                                          return;
                                        }
                                      }
                                      setState(() {
                                        salvandoPedido = !salvandoPedido;
                                      });
                                      if (mounted) {
                                        Navigator.pop(context);
                                        pedidoViewModel.salvarPedido();
                                        retornaScreenCliente(
                                          homeViewModel,
                                          clienteViewModel,
                                        );
                                      }
                                    },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                          backgroundColor: AppColors.buttonLogin,
                          foregroundColor: Colors.white,
                        ),
                        child: Icon(Icons.edit_outlined, size: 26),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  /// Inicializa a lista [_expansibleControllers] se ainda não estiver sincronizada
  /// com o número de produtos. Garante que haja um controller para cada cliente.
  ///
  /// - [tamanhoprodutos] é o número de produtos a serem sincronizados.
  void _sincronizarExpansibleControllers(int tamanhoprodutos) {
    if (_expansibleControllers.length != tamanhoprodutos) {
      _expansibleControllers = List.generate(
        tamanhoprodutos,
        (_) => ExpansibleController(),
      );
    }
  }

  /// Faz a configuração necessária para o conteúdo principal a ser exibido seja a
  /// tela de clientes.
  void retornaScreenCliente(
    HomeViewModel homeViewModel,
    ClienteViewModel clienteViewModel,
  ) {
    homeViewModel.updateTitleAppBar("Clientes");
    clienteViewModel.limparClienteSelecionado();
    homeViewModel.updateSubtitleAppBar(
      "Total: ${clienteViewModel.clientesComFiltro.length}",
    );
  }
}
