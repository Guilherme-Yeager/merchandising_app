import 'package:flutter/material.dart';

abstract class TextFormFieldCustom {
  /// Cria um campo de texto com o valor inicial e o rótulo fornecidos.
  /// O campo é somente leitura e possui um estilo de rótulo personalizado.
  static TextFormField buildTextFormField({
    required String initialValue,
    required String labelText,
    int maxLines = 1,
  }) {
    return TextFormField(
      initialValue: initialValue,
      readOnly: true,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  static TextFormField buildTextFormFieldObservation(
    TextEditingController controller, {
    int maxLines = 4,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
