import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashViewModel extends ChangeNotifier {
  final SupabaseClient _supabaseClient;

  SplashViewModel({required SupabaseClient supabaseClient})
    : _supabaseClient = supabaseClient;

  /// Acessa o `shared_preferences` para verificar se a sessão
  /// atual é válida. Assim, sendo possível entrar no sistema
  /// sem precisar fazer login;
  bool sessaoEstaValida() {
    return _supabaseClient.auth.currentSession != null;
  }
}
