import 'package:supabase_flutter/supabase_flutter.dart';

class LoginService {
  Future<AuthResponse> logar(String email, String password) async {
    return await Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
}
