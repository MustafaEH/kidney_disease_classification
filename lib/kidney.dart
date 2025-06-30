import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:kidney/core/routes_manager.dart';
import 'package:kidney/providers/language_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Kidney extends StatelessWidget {
  const Kidney({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LanguageProvider(),
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return ScreenUtilInit(
            designSize: Size(390, 844),
            builder:
                (context, child) => MaterialApp(
                  debugShowCheckedModeBanner: false,
                  locale: languageProvider.currentLocale,
                  supportedLocales: const [
                    Locale('en'), // English
                    Locale('ar'), // Arabic
                  ],
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  routes: RoutesManager.routes,
                  initialRoute: RoutesManager.home,
                ),
          );
        },
      ),
    );
  }
}
