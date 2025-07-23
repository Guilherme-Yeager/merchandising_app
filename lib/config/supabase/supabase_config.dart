import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SupabaseConfig {
  static Future<void> initialize() async {
    const url = String.fromEnvironment('URL');
    const anonKey = String.fromEnvironment('ANONKEY');
    await Supabase.initialize(url: url, anonKey: anonKey);
  }
}
