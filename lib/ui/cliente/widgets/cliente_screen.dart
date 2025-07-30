import 'package:flutter/material.dart';
import 'package:merchandising_app/ui/core/themes/app_colors.dart';

class ClienteScreen extends StatefulWidget {
  const ClienteScreen({super.key});

  @override
  State<ClienteScreen> createState() => _ClienteScreenState();
}

class _ClienteScreenState extends State<ClienteScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    /// Dados
    final List<Card> clientes = _getClientes();

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
              onTap: () {},
              leading: const Icon(Icons.search),
              trailing: <Widget>[
                Tooltip(
                  message: "Limpar pesquisa",
                  child: IconButton(
                    onPressed: () {
                      _searchController.clear();
                      FocusScope.of(context).unfocus();
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
                      : ListView(children: clientes),
            ),
          ],
        ),
      ),
    );
  }

  /// Retorna uma lista de `Cards` com informações dos clientes.
  List<Card> _getClientes() {
    final List<Map<String, dynamic>> dadosClientes = [];
    return dadosClientes.map((cliente) {
      return Card(
        color: AppColors.inactiveCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: ExpansionTile(
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
                  cliente['id'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                cliente['nome'],
                style: const TextStyle(fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                width: 30,
                child: Divider(thickness: 1, color: AppColors.placeholder),
              ),
              Text(
                cliente['fantasia'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          children: [],
        ),
      );
    }).toList();
  }
}
