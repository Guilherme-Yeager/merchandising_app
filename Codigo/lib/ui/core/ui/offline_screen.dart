import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:merchandising_app/ui/core/themes/app_colors.dart';

class OfflineScreen extends StatefulWidget {
  const OfflineScreen({super.key});

  @override
  State<OfflineScreen> createState() => _OfflineScreenState();
}

class _OfflineScreenState extends State<OfflineScreen> {
  bool _verificandoInternet = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.wifi_off,
                size: 80,
                color: Color.fromARGB(255, 223, 22, 8),
              ),
              const SizedBox(height: 20),
              const Text(
                "Sem conexão com a internet",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Não foi possível carregar as informações. "
                "Verifique sua conexão e tente novamente.",
                style: TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 40),
              if (_verificandoInternet) ...[
                SizedBox(
                  width: 20,
                  height: 20,
                  child: const CircularProgressIndicator(color: Colors.white),
                ),
                const SizedBox(height: 15),
              ],
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _verificandoInternet = !_verificandoInternet;
                  });
                  final List<ConnectivityResult> connectivityResult =
                      await Connectivity().checkConnectivity();
                  if (!connectivityResult.contains(ConnectivityResult.none)) {
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                  setState(() {
                    _verificandoInternet = !_verificandoInternet;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonLogin,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Atualizar",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.refresh, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
