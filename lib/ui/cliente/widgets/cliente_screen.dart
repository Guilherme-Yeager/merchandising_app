import 'package:flutter/material.dart';
import 'package:merchandising_app/ui/core/themes/app_colors.dart';

class ClienteScreen extends StatefulWidget {
  const ClienteScreen({super.key});

  @override
  State<ClienteScreen> createState() => _ClienteScreenState();
}

class _ClienteScreenState extends State<ClienteScreen> {
  @override
  Widget build(BuildContext context) {
    // Cards
    final List<Widget> cards = [
      Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.assignment_outlined,
                size: 50,
                color: Colors.black,
              ),
            ),
            Text(
              "Meus dados",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
      Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.logout_outlined, size: 50, color: Colors.black),
            ),
            Text(
              "Sair",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: GridView.builder(
        padding: const EdgeInsets.all(28.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: 40.0,
          mainAxisSpacing: 40.0,
        ),
        itemCount: 2,
        itemBuilder: (_, index) {
          return cards[index];
        },
      ),
    );
  }
}
