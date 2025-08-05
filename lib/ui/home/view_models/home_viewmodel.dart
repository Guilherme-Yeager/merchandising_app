import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  /// Título da AppBar.
  String _titleAppBar = "";

  /// Subtítulo da AppBar.
  String? _subtitleAppBar = "";

  String get titleAppBar => _titleAppBar;
  String? get subtitleAppBar => _subtitleAppBar;

  /// Atualiza o título da AppBar.
  void updateTitleAppBar(String title) {
    _titleAppBar = title;
    notifyListeners();
  }

  /// Atualiza o subtítulo da AppBar.
  void updateSubtitleAppBar(String? subtitleAppBar) {
    _subtitleAppBar = subtitleAppBar;
    notifyListeners();
  }
}
