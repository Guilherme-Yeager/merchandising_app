import 'package:flutter/material.dart';
import 'package:merchandising_app/ui/cliente/view_models/cliente_viewmodel.dart';
import 'package:merchandising_app/ui/core/themes/app_colors.dart';
import 'package:provider/provider.dart';

class PedidoScreen extends StatefulWidget {
  const PedidoScreen({super.key});

  @override
  State<PedidoScreen> createState() => _PedidoScreenState();
}

class _PedidoScreenState extends State<PedidoScreen> {
  @override
  Widget build(BuildContext context) {
    final ClienteViewModel clienteViewModel = Provider.of<ClienteViewModel>(
      context,
      listen: false,
    );
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Center(
        child: Text(
          "Pedido selecionado: ${clienteViewModel.clienteSelecionado!.cliente}",
        ),
      ),
    );
  }
}
