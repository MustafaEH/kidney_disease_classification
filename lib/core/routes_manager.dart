import 'package:flutter/material.dart';
import 'package:kidney/home.dart';
import 'package:kidney/result.dart';

class RoutesManager {
  static const String home = "/";
  static const String result = "/result";

  static Map<String, Widget Function(BuildContext)> routes = {
    home: (context) => const Home(),
    result: (context) => const Result(),
  };
}
