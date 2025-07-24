import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:merchandising_app/routing/routes.dart';
import 'package:merchandising_app/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:merchandising_app/ui/core/navigator/app_navigator.dart';
import 'package:merchandising_app/ui/core/themes/app_colors.dart';
import 'package:merchandising_app/ui/core/ui/gradiente_linear_custom.dart';
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

  @override
  Widget build(BuildContext context) {
    final LoginViewmodel loginViewmodel = Provider.of<LoginViewmodel>(
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
                            obscureText: true,
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
                                  final bool logar = await loginViewmodel.login(
                                    emailController.text,
                                    senhaController.text,
                                  );
                                  if (logar) {
                                    if (context.mounted) {
                                      AppNavigator.changePage(
                                        context,
                                        Routes.home,
                                      );
                                    }
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.buttonLogin,
                                padding: EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: Text(
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
    );
  }
}
