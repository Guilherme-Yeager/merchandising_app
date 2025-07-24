import 'package:flutter/material.dart';
import 'package:merchandising_app/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<LoginViewmodel>(
          builder: (_, loginViewmodel, __) {
            String nome = loginViewmodel.userModel?.nome ?? "Nome";
            return Text(nome);
          },
        ),
      ),
    );
  }
}
