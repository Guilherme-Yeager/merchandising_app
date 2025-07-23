import 'package:flutter/material.dart';
import 'package:merchandising_app/ui/core/themes/app_colors.dart';

class GradienteLinearCustom extends StatelessWidget {
  final Widget child;

  const GradienteLinearCustom({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[AppColors.gradientStart, AppColors.gradientEnd],
          stops: <double>[0.25, 1.0],
        ),
      ),
      child: child,
    );
  }
}
