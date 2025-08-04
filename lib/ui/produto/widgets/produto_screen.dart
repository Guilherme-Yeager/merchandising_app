import 'package:flutter/material.dart';
import 'package:merchandising_app/domain/models/produto/produto_model.dart';
import 'package:merchandising_app/ui/cliente/view_models/cliente_viewmodel.dart';
import 'package:merchandising_app/ui/core/themes/app_colors.dart';
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
    final ClienteViewModel clienteViewModel = Provider.of<ClienteViewModel>(
      context,
      listen: false,
    );
    final ProdutoViewModel produtoViewModel = Provider.of<ProdutoViewModel>(
      context,
    );

    /// Cards com informações dos produtos
    final List<Card> produtos = _getProdutos(
      clienteViewModel,
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
              hintText: "Pesquisar produto",
              hintStyle: WidgetStateProperty.all(
                TextStyle(color: AppColors.placeholder, fontSize: 18),
              ),
              onChanged: (text) {
                produtoViewModel.filtrarProdutos(text);
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

  List<Card> _getProdutos(
    ClienteViewModel clienteViewModel,
    ProdutoViewModel produtoViewModel,
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

            /// Rolagem automática para o cliente selecionado
            _scrollController.animateTo(
              index * 126,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
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
                          child: _buildTextFormField(
                            initialValue: produto.codprod.toString(),
                            labelText: "Código",
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 60,
                          child: _buildTextFormField(
                            initialValue: produto.pvenda.toString(),
                            labelText: "Preço de Venda",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    FractionallySizedBox(
                      widthFactor: 0.65,
                      child: _buildTextFormField(
                        initialValue: produto.qtest.toInt().toString(),
                        labelText: "Quantidade disponível",
                      ),
                    ),

                    const SizedBox(height: 10),
                    _buildTextFormField(
                      initialValue: produto.descricao,
                      labelText: "Descrição",
                      maxLines: 3,
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {},
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

  /// Cria um campo de texto com o valor inicial e o rótulo fornecidos.
  /// O campo é somente leitura e possui um estilo de rótulo personalizado.
  TextFormField _buildTextFormField({
    required String initialValue,
    required String labelText,
    int maxLines = 1,
  }) {
    return TextFormField(
      initialValue: initialValue,
      readOnly: true,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
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
}
