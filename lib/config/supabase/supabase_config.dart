import 'package:merchandising_app/ui/core/logger/app_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SupabaseConfig {
  static Future<void> initialize() async {
    const String url = String.fromEnvironment('URL');
    const String anonKey = String.fromEnvironment('ANONKEY');
    if (url.isNotEmpty && anonKey.isNotEmpty) {
      await Supabase.initialize(url: url, anonKey: anonKey);
      AppLogger.instance.i("Supabase inicializado com sucesso.");
    } else {
      AppLogger.instance.w("Chaves do supabase não encontradas.");
    }
  }
}
