import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mirath/features/onboarding/presentation/screens/onboarding_screen.dart';
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
      themeMode: ThemeMode.dark,
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

// class MirathHome extends StatefulWidget {
//   const MirathHome({super.key});

//   @override
//   State<MirathHome> createState() => _MirathHomeState();
// }

// class _MirathHomeState extends State<MirathHome> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: InkWell(
//           onTap: () {
//             MyHelperFunctions.showAlertDialog(
//               title: 'Title',
//               message: "Message",
//               context,
//             );
//           },
//           child: Text('Mirath App', style: context.headlineMedium),
//         ),
//       ),
//     );
//   }
// }
