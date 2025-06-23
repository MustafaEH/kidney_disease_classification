import 'package:flutter/material.dart';
import 'package:kidney/core/routes_manager.dart';

class Kidney extends StatelessWidget {
  const Kidney({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: RoutesManager.routes,
      initialRoute: RoutesManager.home,
    );
  }
}
