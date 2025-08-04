import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:merchandising_app/config/providers/providers_config.dart';
import 'package:merchandising_app/config/supabase/supabase_config.dart';
import 'package:merchandising_app/routing/routes.dart';
import 'package:merchandising_app/ui/core/logger/app_logger.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder:
          (_) => MultiProvider(
            providers: ProvidersConfig.providers,
            child: MainApp(),
          ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Locale('pt', 'BR'),
      initialRoute: Routes.login,
      routes: Routes.getRoutes(),
      builder: (_, child) => SafeArea(child: child ?? SizedBox.shrink()),
    );
  }
}
