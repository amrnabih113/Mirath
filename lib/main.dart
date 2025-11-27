import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mirath/app_router.dart';

import 'core/network/network_manager.dart';
import 'core/themes/my_theme.dart';
import 'core/utils/my_logger.dart';
import 'generated/l10n.dart';
import 'injection/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NetworkManager.instance.initialize();
  await DI.init();
  MyLogger.info('App Started');
  runApp(const MirathApp());
}

class MirathApp extends StatelessWidget {
  const MirathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mirath App',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      locale: const Locale('en'),
      routerConfig: appRouter,
      theme: MyTheme.lightTheme(context, const Locale('en')),
      darkTheme: MyTheme.darkTheme(context, const Locale('en')),

      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
    );
  }
}
