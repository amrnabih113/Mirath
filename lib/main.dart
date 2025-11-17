import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/helpers/my_helper_functions.dart';
import 'core/network/network_manager.dart';
import 'core/themes/custom_themes/text_theme.dart';
import 'core/themes/my_theme.dart';
import 'core/utils/my_extenstions.dart';
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
    return MaterialApp(
      title: 'Mirath App',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,

      theme: MyTheme.lightTheme.copyWith(
        textTheme: MyTextTheme.getLightTextTheme(context, const Locale('en')),
      ),
      darkTheme: MyTheme.darkTheme.copyWith(
        textTheme: MyTextTheme.getDarkTextTheme(context, const Locale('en')),
      ),

      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,

      home: const MirathHome(),
    );
  }
}

class MirathHome extends StatefulWidget {
  const MirathHome({super.key});

  @override
  State<MirathHome> createState() => _MirathHomeState();
}

class _MirathHomeState extends State<MirathHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () {
            MyHelperFunctions.showAlertDialog(
              title: 'Title',
              message: "Message",
              context,
            );
          },
          child: Text('Mirath App', style: context.headlineMedium),
        ),
      ),
    );
  }
}
