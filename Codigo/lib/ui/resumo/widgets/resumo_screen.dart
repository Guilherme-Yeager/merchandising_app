import 'package:flutter/material.dart';
import 'package:merchandising_app/ui/core/themes/app_colors.dart';
import 'package:merchandising_app/ui/home/view_models/home_viewmodel.dart';
import 'package:merchandising_app/ui/produto/view_models/produto_viewmodel.dart';
import 'package:provider/provider.dart';

class ResumoScreen extends StatefulWidget {
  const ResumoScreen({super.key});

  @override
  State<ResumoScreen> createState() => _ResumoScreenState();
}

class _ResumoScreenState extends State<ResumoScreen> {
  @override
  Widget build(BuildContext context) {
    /// ViewModels
    final ProdutoViewModel produtoViewModel = Provider.of<ProdutoViewModel>(
      context,
    );
    final HomeViewModel homeViewModel = Provider.of<HomeViewModel>(
      context,
      listen: false,
    );
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
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
                Icon(Icons.arrow_back_outlined, color: Colors.white, size: 22),
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
      ),
    );
  }
}
