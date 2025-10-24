import 'package:flutter/material.dart';
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
import 'package:merchandising_app/ui/core/ui/show_modal_custom.dart';
import 'package:merchandising_app/ui/core/ui/text_form_field_custom.dart';
import 'package:merchandising_app/ui/home/view_models/home_viewmodel.dart';
import 'package:merchandising_app/ui/pedido/view_models/pedido_viewmodel.dart';
import 'package:merchandising_app/ui/produto/view_models/produto_viewmodel.dart';
import 'package:provider/provider.dart';

class ResumoScreen extends StatefulWidget {
  const ResumoScreen({super.key});

  @override
  State<ResumoScreen> createState() => _ResumoScreenState();
}

class _ResumoScreenState extends State<ResumoScreen> {
  TextEditingController observacaoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    /// ViewModels
    final ProdutoViewModel produtoViewModel = Provider.of<ProdutoViewModel>(
      context,
    );
    final LoginViewModel loginViewModel = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );
    final ClienteViewModel clienteViewModel = Provider.of<ClienteViewModel>(
      context,
      listen: false,
    );
    final HomeViewModel homeViewModel = Provider.of<HomeViewModel>(
      context,
      listen: false,
    );
    final PedidoViewModel pedidoViewModel = Provider.of<PedidoViewModel>(
      context,
      listen: false,
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.mainColor,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    produtoViewModel.exibirTelaResumo = false;
                    homeViewModel.updateTitleAppBar("Produtos");
                    homeViewModel.updateSubtitleAppBar(
                      "Total: ${produtoViewModel.produtosComFiltro.length}",
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    textBaseline: TextBaseline.alphabetic,
                    children: const [
                      Icon(
                        Icons.arrow_back_outlined,
                        color: Colors.white,
                        size: 22,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Voltar",
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
              SizedBox(height: 10),
              Text(
                "Detalhes da Venda",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              detalhesCabecalho(
                loginViewModel.userModel!.nome,
                clienteViewModel.clienteSelecionado!.cliente,
              ),
              FractionallySizedBox(
                widthFactor: 0.7,
                child: const Divider(
                  color: Colors.white,
                  height: 32,
                  thickness: 0.8,
                ),
              ),
              Text(
                "Produtos Selecionados",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              if (produtoViewModel.produtosSelecionados.isNotEmpty)
                detalhesCorpo(produtoViewModel, homeViewModel)
              else
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    'Nenhum produto selecionado',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Observação',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(vertical: 4.0),
                child: TextFormFieldCustom.buildTextFormFieldObservation(
                  observacaoController,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          color: const Color.fromARGB(255, 68, 128, 71),
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Center(
            heightFactor: 1.0,
            child: SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  if (produtoViewModel.produtosSelecionados.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Nenhum produto selecionado...'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  }

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    barrierColor: Colors.black54,
                    builder: (BuildContext context) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.lightBlueAccent,
                        ),
                      );
                    },
                  );
                  await Future.delayed(const Duration(seconds: 2), () {});

                  try {
                    /// Definindo o cabeçalho do pedido
                    PedcabModel pedcabModel = PedcabModel(
                      dataPedido: DateFormat(
                        'dd/MM/yyyy',
                      ).format(DateTime.now()),
                      codigoVendedor:
                          loginViewModel.userModel!.codusur.toString(),
                      codigoCliente:
                          clienteViewModel.clienteSelecionado!.codcli
                              .toString(),
                      observacao: observacaoController.text,
                    );

                    /// Inserindo o cabeçalho do pedido e obtendo o código gerado
                    int codPedido = await pedidoViewModel
                        .inserirCabecalhoPedido(pedcabModel);

                    AppLogger.instance.i(
                      "Código do cabeçalho do pedido: $codPedido",
                    );

                    produtoViewModel.produtosSelecionados.forEach((
                      produto,
                      quantidade,
                    ) async {
                      /// Obtendo o preço de venda do produto
                      double precoVenda =
                          await produtoViewModel.getPrecoVenda(
                            produto.codprod,
                          ) ??
                          0.0;

                      /// Definindo o corpo do pedido
                      PedcorpModel pedcorpModel = PedcorpModel(
                        codigoPedido: codPedido,
                        codigoProduto: produto.codprod.toString(),
                        quantidade: quantidade,
                        precoBase: precoVenda,
                        precoVenda: precoVenda,
                      );

                      /// Inserindo o corpo do pedido
                      pedidoViewModel.inserirCorpoPedido(pedcorpModel);
                    });
                  } on ServiceException catch (exception) {
                    if (exception.tipo == TipoErro.offline) {
                      await Future.delayed(Duration(seconds: 1));
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => OfflineScreen()),
                        );
                        return;
                      }
                    } else {
                      await Future.delayed(Duration(seconds: 1));
                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) =>
                                    ErrorScreen(mensagem: exception.mensagem),
                          ),
                        );
                      }
                      return;
                    }
                  }

                  if (context.mounted) {
                    Navigator.pop(context);
                    homeViewModel.updateTitleAppBar("Clientes");
                    clienteViewModel.limparClienteSelecionado();
                    produtoViewModel.exibirTelaResumo = false;
                    produtoViewModel.limparProdutosSelecionados();
                    homeViewModel.updateSubtitleAppBar(
                      "Total: ${clienteViewModel.clientesComFiltro.length}",
                    );
                    pedidoViewModel.salvarPedido();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonLogin,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  side: const BorderSide(color: Colors.white, width: 1.0),
                ),
                child: const Text(
                  'Salvar',
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column detalhesCabecalho(String nomeVendedor, String nomeCliente) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15),
        const Text(
          'Vendedor(a)',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 40,
          child: TextFormField(
            initialValue: nomeVendedor,
            readOnly: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Cliente',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 40,
          child: TextFormField(
            initialValue: nomeCliente,
            readOnly: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Data',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 115,
          height: 40,
          child: TextFormField(
            initialValue: DateFormat('dd/MM/yyyy').format(DateTime.now()),
            readOnly: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Column detalhesCorpo(
    ProdutoViewModel produtoViewModel,
    HomeViewModel homeViewModel,
  ) {
    final Map<ProdutoModel, int> produtos =
        produtoViewModel.produtosSelecionados;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Nome',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 33.0),
                      child: Text(
                        'Quantidade',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: produtos.length,
          itemBuilder: (context, index) {
            final MapEntry<ProdutoModel, int> entry = produtos.entries
                .elementAt(index);
            final ProdutoModel produto = entry.key;
            final int quantidade = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        ShowModalCustom.mostrarDetalhesProduto(
                          context,
                          produto,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  produto.descricao,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 3.0,
                                  right: 18.0,
                                ),
                                child: VerticalDivider(
                                  color: Colors.grey,
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 30.0),
                                child: Text(
                                  quantidade.toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.red,
                          child: IconButton(
                            iconSize: 16,
                            icon: const Icon(Icons.remove),
                            color: Colors.white,
                            onPressed: () {
                              setState(() {
                                produtoViewModel.removerProdutoSelecionado(
                                  produto,
                                );
                              });
                              homeViewModel.updateSubtitleAppBar(
                                "Produtos Selecionados: ${produtoViewModel.produtosSelecionados.values.length}",
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.blue,
                          child: IconButton(
                            iconSize: 16,
                            icon: const Icon(Icons.edit),
                            color: Colors.white,
                            onPressed: () async {
                              await DialogCustom.showDialogQuantItens(
                                context: context,
                                produto: produto,
                                produtoViewModel: produtoViewModel,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
