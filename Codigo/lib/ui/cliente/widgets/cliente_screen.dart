import 'package:flutter/material.dart';
import 'package:merchandising_app/domain/models/cliente/cliente_model.dart';
import 'package:merchandising_app/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:merchandising_app/ui/cliente/view_models/cliente_viewmodel.dart';
import 'package:merchandising_app/ui/core/logger/app_logger.dart';
import 'package:merchandising_app/ui/core/themes/app_colors.dart';
import 'package:merchandising_app/ui/core/ui/text_form_field_custom.dart';
import 'package:merchandising_app/ui/home/view_models/home_viewmodel.dart';
import 'package:merchandising_app/ui/produto/view_models/produto_viewmodel.dart';

import 'package:provider/provider.dart';

class ClienteScreen extends StatefulWidget {
  const ClienteScreen({super.key});

  @override
  State<ClienteScreen> createState() => _ClienteScreenState();
}

class _ClienteScreenState extends State<ClienteScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  /// Lista de controllers para gerenciar a expansão dos clientes.
  List<ExpansibleController> _expansibleControllers = [];
  int? _clienteSelecionado;

  bool seleciouCliente = false;

  @override
  Widget build(BuildContext context) {
    /// Providers
    final ClienteViewModel clienteViewModel = Provider.of<ClienteViewModel>(
      context,
    );

    /// ViewModels
    final LoginViewModel loginViewModel = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );
    final HomeViewModel homeViewModel = Provider.of<HomeViewModel>(
      context,
      listen: false,
    );
    final ProdutoViewModel produtoViewModel = Provider.of<ProdutoViewModel>(
      context,
      listen: false,
    );

    /// Cards com informações dos clientes
    final List<Card> clientes = _getClientes(
      clienteViewModel,
      homeViewModel,
      produtoViewModel,
    );

    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SearchBar(
              controller: _searchController,
              hintText: "Pesquisar cliente",
              hintStyle: WidgetStateProperty.all(
                TextStyle(color: AppColors.placeholder, fontSize: 18),
              ),
              onChanged: (text) {
                clienteViewModel.filtrarClientes(text);
                homeViewModel.updateSubtitleAppBar(
                  "Total: ${clienteViewModel.clientesComFiltro.length}",
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
                      clienteViewModel.filtrarClientes("");
                      homeViewModel.updateSubtitleAppBar(
                        "Total: ${clienteViewModel.clientesComFiltro.length}",
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
                  clientes.isEmpty
                      ? Center(
                        child: const Text(
                          "Nenhum cliente encontrado.",
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
                            await clienteViewModel.updateClientes(
                              loginViewModel.userModel!.codusur,
                            );
                          },
                          child: Scrollbar(
                            controller: _scrollController,
                            thumbVisibility: true,
                            thickness: 6,
                            radius: const Radius.circular(8),
                            child: ListView(
                              controller: _scrollController,
                              children: clientes,
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

  /// Retorna uma lista de `Cards` com informações dos clientes.
  /// Atualiza o título da AppBar para tela de produtos.
  ///
  /// - [clienteViewModel] é o ViewModel que contém a lista de clientes filtrados.
  /// - [homeViewModel] é o ViewModel que gerencia o estado da tela inicial.
  /// - [produtoViewModel] é o ViewModel que gerencia os produtos.
  List<Card> _getClientes(
    ClienteViewModel clienteViewModel,
    HomeViewModel homeViewModel,
    ProdutoViewModel produtoViewModel,
  ) {
    List<ClienteModel> clientes = clienteViewModel.clientesComFiltro;
    if (clientes.isEmpty) {
      return [];
    }

    /// Sincroniza os controllers de expansão com o número de clientes
    /// para garantir que cada cliente tenha um controller correspondente.
    _sincronizarExpansibleControllers(clientes.length);
    return clientes.asMap().entries.map((entry) {
      final int index = entry.key;
      final ClienteModel cliente = entry.value;
      final bool isSelected = _clienteSelecionado == index;
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
                if (_clienteSelecionado != null &&
                    _clienteSelecionado != index) {
                  _expansibleControllers[_clienteSelecionado!].collapse();
                  _expansibleControllers[index].expand();
                }

                /// Atualiza o cliente selecionado
                _clienteSelecionado = index;

                /// Colapsa o cliente selecionado se ele já estiver expandido
              } else if (isSelected) {
                _clienteSelecionado = null;
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
                  cliente.codcli.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                cliente.cliente,
                style: const TextStyle(fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                width: 30,
                child: Divider(thickness: 1, color: AppColors.placeholder),
              ),
              Text(
                cliente.fantasia,
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
                    FractionallySizedBox(
                      widthFactor: 0.5,
                      child: TextFormFieldCustom.buildTextFormField(
                        initialValue: cliente.codcli.toString(),
                        labelText: "Código",
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormFieldCustom.buildTextFormField(
                      initialValue: cliente.cliente,
                      labelText: "Nome",
                    ),
                    const SizedBox(height: 15),
                    TextFormFieldCustom.buildTextFormField(
                      initialValue: cliente.fantasia,
                      labelText: "Nome Fantasia",
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Flexible(
                          child: TextFormFieldCustom.buildTextFormField(
                            initialValue: cliente.municent,
                            labelText: "Munícipio",
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          flex: 2,
                          child: TextFormFieldCustom.buildTextFormField(
                            initialValue: cliente.enderent,
                            labelText: "Endereço",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    FractionallySizedBox(
                      widthFactor: 0.5,
                      child: TextFormFieldCustom.buildTextFormField(
                        initialValue: cliente.telent,
                        labelText: "Telefone",
                      ),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            seleciouCliente = !seleciouCliente;
                          });

                          /// Atualiza os produtos
                          await produtoViewModel.updateProdutos();

                          clienteViewModel.selecionarCliente(cliente);
                          homeViewModel.updateTitleAppBar("Produtos");
                          homeViewModel.updateSubtitleAppBar(
                            "Total: ${produtoViewModel.produtosComFiltro.length}",
                          );

                          AppLogger.instance.i(
                            "Cliente selecionado: ${cliente.codcli}",
                          );
                          setState(() {
                            seleciouCliente = !seleciouCliente;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonLogin,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                        ),
                        child:
                            seleciouCliente
                                ? SizedBox(
                                  height: 23,
                                  width: 23,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                                : const Text(
                                  "Novo",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
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
  /// com o número de clientes. Garante que haja um controller para cada cliente.
  ///
  /// - [tamanhoClientes] é o número de clientes a serem sincronizados.
  void _sincronizarExpansibleControllers(int tamanhoClientes) {
    if (_expansibleControllers.length != tamanhoClientes) {
      _expansibleControllers = List.generate(
        tamanhoClientes,
        (_) => ExpansibleController(),
      );
    }
  }
}
