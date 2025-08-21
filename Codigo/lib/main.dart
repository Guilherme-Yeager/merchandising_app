import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:merchandising_app/config/providers/providers_config.dart';
import 'package:merchandising_app/config/supabase/supabase_config.dart';
import 'package:merchandising_app/routing/routes.dart';
import 'package:merchandising_app/ui/core/ui/error_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return ErrorScreen(mensagem: details.exceptionAsString());
  };
  await SupabaseConfig.initialize();
  runApp(
    DevicePreview(
      enabled: kReleaseMode,
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
      initialRoute: Routes.splash,
      routes: Routes.getRoutes(),
      builder: (_, child) => SafeArea(child: child ?? SizedBox.shrink()),
    );
  }
}
