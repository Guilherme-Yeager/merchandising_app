import 'package:validatorless/validatorless.dart';

class LoginValidator {
  List<String? Function(String?)> emailValidator() {
    return [
      Validatorless.required("Campo obrigatório"),
      Validatorless.email("Email inválido"),
    ];
  }

  List<String? Function(String?)> senhaValidator() {
    return [
      Validatorless.required("Campo obrigatório"),
      Validatorless.min(6, "Mínimo 6 carecteres"),
      Validatorless.max(8, "Máximo 6 carecteres"),
      Validatorless.regex(RegExp(r'^\S+$'), "Não pode conter espaços"),
    ];
  }
}
