import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashViewModel extends ChangeNotifier {
  bool estaLogado() {
    return Supabase.instance.client.auth.currentSession != null ? true : false;
  }
}
