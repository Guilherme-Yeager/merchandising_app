import 'package:flutter/material.dart';
import 'package:merchandising_app/data/service/exception/service_exception.dart';
import 'package:merchandising_app/domain/models/produto/produto_model.dart';
import 'package:merchandising_app/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:merchandising_app/ui/cliente/view_models/cliente_viewmodel.dart';
import 'package:merchandising_app/ui/core/themes/app_colors.dart';
import 'package:merchandising_app/ui/core/ui/dialog_custom.dart';
import 'package:merchandising_app/ui/core/ui/error_screen.dart';
import 'package:merchandising_app/ui/core/ui/offline_screen.dart';
import 'package:merchandising_app/ui/core/ui/text_form_field_custom.dart';
import 'package:merchandising_app/ui/home/view_models/home_viewmodel.dart';
import 'package:merchandising_app/ui/pedido/view_models/pedido_viewmodel.dart';
import 'package:merchandising_app/ui/produto/view_models/produto_viewmodel.dart';
import 'package:provider/provider.dart';

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
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
                            retornaScreenCliente(
                              homeViewModel,
                              clienteViewModel,
                              produtoViewModel,
                            );
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      homeViewModel.updateTitleAppBar("Resumo do Pedido");
                      produtoViewModel.exibirTelaResumo = true;
                      homeViewModel.updateSubtitleAppBar(
                        "Produtos Selecionados: ${produtoViewModel.produtosSelecionados.values.length}",
                      );
                    },
                    icon: const Icon(
                      Icons.save_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: const Text(
                      "Salvar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonLogin,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
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
              child: Stack(
                children: [
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
                              int? codLinhaProd =
                                  loginViewModel.userModel!.codLinhaProd;
                              if (codLinhaProd != null) {
                                await produtoViewModel.updateProdutos(
                                  loginViewModel.userModel!.codLinhaProd!,
                                );
                              }
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
                ],
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
                          await DialogCustom.showDialogQuantItens(
                            context: context,
                            produto: produto,
                            produtoViewModel: produtoViewModel,
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
    ProdutoViewModel produtoViewModel,
  ) {
    homeViewModel.updateTitleAppBar("Clientes");
    clienteViewModel.limparClienteSelecionado();
    produtoViewModel.exibirTelaResumo = false;
    produtoViewModel.limparProdutosSelecionados();
    homeViewModel.updateSubtitleAppBar(
      "Total: ${clienteViewModel.clientesComFiltro.length}",
    );
  }
}
