import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:merchandising_app/data/service/exception/service_exception.dart';
import 'package:merchandising_app/routing/routes.dart';
import 'package:merchandising_app/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:merchandising_app/ui/cliente/view_models/cliente_viewmodel.dart';
import 'package:merchandising_app/ui/core/themes/app_colors.dart';
import 'package:merchandising_app/ui/core/ui/dialog_custom.dart';
import 'package:merchandising_app/ui/core/ui/error_screen.dart';
import 'package:merchandising_app/ui/core/ui/gradiente_linear_custom.dart';
import 'package:merchandising_app/ui/core/ui/offline_screen.dart';
import 'package:merchandising_app/ui/produto/view_models/produto_viewmodel.dart';
import 'package:merchandising_app/utils/validators/login_validator.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final LoginValidator loginValidator = LoginValidator();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  bool _loading = false;
  bool _mostrarSenha = false;

  @override
  Widget build(BuildContext context) {
    /// ViewModels
    final LoginViewModel loginViewModel = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );
    final ClienteViewModel clienteViewModel = Provider.of<ClienteViewModel>(
      context,
      listen: false,
    );
    final ProdutoViewModel produtoViewModel = Provider.of<ProdutoViewModel>(
      context,
      listen: false,
    );
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: GradienteLinearCustom(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Image.asset(
                    "assets/images/logo.png",
                    width: 310,
                    height: 200,
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            controller: emailController,
                            decoration: _inputStyle("Email"),
                            validator: Validatorless.multiple(
                              loginValidator.emailValidator(),
                            ),
                          ),
                          const SizedBox(height: 25),
                          TextFormField(
                            controller: senhaController,
                            decoration: _inputStyle("Senha"),
                            obscureText: !_mostrarSenha,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(8),
                            ],
                            validator: Validatorless.multiple(
                              loginValidator.senhaValidator(),
                            ),
                          ),
                          const SizedBox(height: 40),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                if (formKey.currentState!.validate()) {
                                  _loading = true;
                                  setState(() {});
                                  bool logar = false;
                                  try {
                                    logar = await loginViewModel.login(
                                      emailController.text,
                                      senhaController.text,
                                    );
                                  } on ServiceException catch (exception) {
                                    if (exception.tipo ==
                                        TipoErro.userBadLogin) {
                                      if (context.mounted) {
                                        DialogCustom.showDialogError(
                                          message: exception.mensagem,
                                          context: context,
                                        );
                                      }
                                    } else if (exception.tipo ==
                                        TipoErro.offline) {
                                      await Future.delayed(
                                        Duration(seconds: 1),
                                      );
                                      if (context.mounted) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => OfflineScreen(),
                                          ),
                                        );
                                      }
                                    }
                                  }
                                  if (logar) {
                                    try {
                                      await loginViewModel.carregarDependencias(
                                        clienteViewModel,
                                        produtoViewModel,
                                        loginViewModel
                                                .userModel!
                                                .codLinhaProd ??
                                            0,
                                      );
                                    } on ServiceException catch (exception) {
                                      if (exception.tipo == TipoErro.offline) {
                                        await Future.delayed(
                                          Duration(seconds: 1),
                                        );
                                        if (context.mounted) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => OfflineScreen(),
                                            ),
                                          );
                                        }
                                      } else {
                                        await Future.delayed(
                                          Duration(seconds: 1),
                                        );
                                        if (context.mounted) {
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
                                    if (context.mounted) {
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        Routes.home,
                                        (route) => false,
                                      );
                                    }
                                  }
                                }
                                _loading = false;
                                setState(() {});
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.buttonLogin,
                                padding: EdgeInsets.symmetric(vertical: 16),
                              ),
                              child:
                                  _loading
                                      ? CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                      : Text(
                                        'Entrar',
                                        style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.white,
                                        ),
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: AppColors.placeholder,
        fontStyle: FontStyle.italic,
      ),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      errorStyle: TextStyle(
        color: AppColors.textError,
        fontWeight: FontWeight.bold,
      ),
      suffixIcon:
          label == "Senha"
              ? IconButton(
                iconSize: 24,
                icon: Icon(
                  _mostrarSenha ? Icons.visibility : Icons.visibility_off,
                  color:
                      _mostrarSenha
                          ? AppColors.gradientStart
                          : AppColors.gradientEnd,
                ),
                color: AppColors.placeholder,
                onPressed: () => setState(() => _mostrarSenha = !_mostrarSenha),
              )
              : null,
    );
  }
}
