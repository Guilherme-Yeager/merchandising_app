import 'package:flutter/material.dart';

class HomeViewmodel extends ChangeNotifier {
  /// Título da AppBar.
  String _titleAppBar = "";

  String get titleAppBar => _titleAppBar;

  /// Atualiza o título da AppBar.
  void updateTitleAppBar(String title) {
    _titleAppBar = title;
    notifyListeners();
  }
}
