import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:merchandising_app/ui/core/logger/app_logger.dart';
import 'package:merchandising_app/ui/core/themes/app_colors.dart';
import 'package:merchandising_app/ui/core/ui/gradiente_linear_custom.dart';
import 'package:merchandising_app/utils/validators/login_validator.dart';
import 'package:validatorless/validatorless.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final LoginValidator loginValidator = LoginValidator();

  @override
  Widget build(BuildContext context) {
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
                            decoration: _inputStyle("Email"),
                            validator: Validatorless.multiple(
                              loginValidator.emailValidator(),
                            ),
                          ),
                          const SizedBox(height: 25),
                          TextFormField(
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
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                if (formKey.currentState!.validate()) {
                                  AppLogger.instance.i(
                                    "Login realizado com sucesso!",
                                  );
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
