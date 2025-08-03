import 'package:flutter/material.dart';
import 'package:merchandising_app/domain/models/cliente/cliente_model.dart';
import 'package:merchandising_app/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:merchandising_app/ui/cliente/view_models/cliente_viewmodel.dart';
import 'package:merchandising_app/ui/core/themes/app_colors.dart';
import 'package:provider/provider.dart';

class ClienteScreen extends StatefulWidget {
  const ClienteScreen({super.key});

  @override
  State<ClienteScreen> createState() => _ClienteScreenState();
}

class _ClienteScreenState extends State<ClienteScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<ExpansionTileController> _expansionTileController = [];
  int? _clienteSelecionado;

  @override
  Widget build(BuildContext context) {
    /// Providers
    final ClienteViewModel clienteViewmodel = Provider.of<ClienteViewModel>(
      context,
    );

    final LoginViewmodel loginViewmodel = Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    _sincronizarExpansionTileControllers(
      clienteViewmodel.clientesComFiltro.length,
    );

    /// Cards com informações dos clientes
    final List<Card> clientes = _getClientes(
      clienteViewmodel.clientesComFiltro,
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
                clienteViewmodel.filtrarClientes(text);
              },
              leading: const Icon(Icons.search),
              trailing: <Widget>[
                Tooltip(
                  message: "Limpar pesquisa",
                  child: IconButton(
                    onPressed: () {
                      _searchController.clear();
                      FocusScope.of(context).unfocus();
                      clienteViewmodel.filtrarClientes("");
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
                            await clienteViewmodel.updateClientes(
                              loginViewmodel.userModel!.codusur,
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
  List<Card> _getClientes(List<ClienteModel> clientes) {
    if (clientes.isEmpty) {
      return [];
    }
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
          controller: _expansionTileController[index],
          onExpansionChanged: (value) {
            setState(() {
              if (value) {
                /// Expande o cliente selecionado e colapsa o anterior
                if (_clienteSelecionado != null &&
                    _clienteSelecionado != index) {
                  _expansionTileController[_clienteSelecionado!].collapse();
                  _expansionTileController[index].expand();
                }

                /// Atualiza o cliente selecionado
                _clienteSelecionado = index;

                /// Colapsa o cliente selecionado se ele já estiver expandido
              } else if (isSelected) {
                _clienteSelecionado = null;
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
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FractionallySizedBox(
                      widthFactor: 0.5,
                      child: _buildTextFormField(
                        initialValue: cliente.codcli.toString(),
                        labelText: "Código",
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildTextFormField(
                      initialValue: cliente.cliente,
                      labelText: "Nome",
                    ),
                    const SizedBox(height: 15),
                    _buildTextFormField(
                      initialValue: cliente.fantasia,
                      labelText: "Nome Fantasia",
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Flexible(
                          child: _buildTextFormField(
                            initialValue: cliente.municent,
                            labelText: "Munícipio",
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          flex: 2,
                          child: _buildTextFormField(
                            initialValue: cliente.enderent,
                            labelText: "Endereço",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    FractionallySizedBox(
                      widthFactor: 0.5,
                      child: _buildTextFormField(
                        initialValue: cliente.telent,
                        labelText: "Telefone",
                      ),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonLogin,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                        ),
                        child: const Text(
                          "Novo",
                          style: TextStyle(color: Colors.white, fontSize: 16),
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

  /// Cria um campo de texto com o valor inicial e o rótulo fornecidos.
  /// O campo é somente leitura e possui um estilo de rótulo personalizado.
  TextFormField _buildTextFormField({
    required String initialValue,
    required String labelText,
  }) {
    return TextFormField(
      initialValue: initialValue,
      readOnly: true,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Inicializa a lista [_expansionTileController] se ainda não estiver sincronizada
  /// com o número de clientes. Garante que haja um controller para cada cliente.
  ///
  /// - [tamanhoClientes] é o número de clientes a serem sincronizados.
  void _sincronizarExpansionTileControllers(int tamanhoClientes) {
    if (_expansionTileController.length != tamanhoClientes) {
      _expansionTileController = List.generate(
        tamanhoClientes,
        (_) => ExpansionTileController(),
      );
    }
  }
}
