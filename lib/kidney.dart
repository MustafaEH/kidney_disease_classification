import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kidney/core/routes_manager.dart';

class Kidney extends StatelessWidget {
  const Kidney({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(390, 844),
      builder:
          (context, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            routes: RoutesManager.routes,
            initialRoute: RoutesManager.home,
          ),
    );
  }
}
