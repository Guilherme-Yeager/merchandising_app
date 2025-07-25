import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  Future<Map<String, dynamic>?> get(String uuid) async {
    return await Supabase.instance.client
        .from('pcusuari')
        .select('codusur, nome')
        .eq('user_id', uuid)
        .maybeSingle();
  }
}
