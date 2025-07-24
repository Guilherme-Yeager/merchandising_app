import 'package:flutter/material.dart';

abstract class AppNavigator {
  static void changePage(BuildContext context, String routeName) {
    Navigator.popAndPushNamed(context, routeName);
  }
}
