import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mirath/core/constants/route_names.dart';

import 'app_router.dart';
import 'core/network/network_manager.dart';
import 'core/themes/my_theme.dart';
import 'core/utils/my_logger.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/home/presentation/cubit/home_cubit.dart';
import 'generated/l10n.dart';
import 'injection/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NetworkManager.instance.initialize();
  await DI.init();
  MyLogger.info('App Started');
  runApp(
    DevicePreview(
      enabled: !const bool.fromEnvironment(
        'dart.vm.product',
      ), // Disable in release mode
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => sl<AuthCubit>()..checkAuthStatus()),
          BlocProvider(create: (context) => sl<HomeCubit>()),
        ],
        child: const MirathApp(),
      ),
    ),
  );
}

class MirathApp extends StatefulWidget {
  const MirathApp({super.key});

  @override
  State<MirathApp> createState() => _MirathAppState();
}

class _MirathAppState extends State<MirathApp> {
  bool _handledDeepLink = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleDeepLinkIfAny());
  }

  void _handleDeepLinkIfAny() {
    if (_handledDeepLink) return;
    _handledDeepLink = true;

    final uri = Uri.base;
    String path = '';

    // For web with hash routing, the fragment contains the route (e.g. #/papers/123)
    if (kIsWeb && uri.fragment.isNotEmpty) {
      path = uri.fragment;
    } else {
      path = uri.path;
    }

    if (path.isEmpty) return;

    final segments = path.split('/').where((s) => s.isNotEmpty).toList();
    if (segments.isEmpty) return;

    String? target;
    switch (segments[0]) {
      case 'papers':
        if (segments.length > 1) target = RouteNames.paperDetailsRoute(segments[1]);
        break;
      case 'discussions':
        if (segments.length > 1) target = RouteNames.discussionDetailsRoute(segments[1]);
        break;
      case 'users':
        if (segments.length > 1) target = RouteNames.userProfileRoute(segments[1]);
        break;
      case 'reading-lists':
        if (segments.length > 1) target = RouteNames.readingListDetailsRoute(segments[1]);
        break;
      default:
        target = null;
    }

    if (target == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final authStatus = sl<AuthCubit>().state.status;

        if (authStatus == AuthStatus.authenticated) {
          // Authenticated users land on Home first, then the shared item.
          appRouter.go(RouteNames.home);
          appRouter.push(target!);
          return;
        }

        // Unauthenticated users must sign in first to avoid protected screens
        // firing requests and showing auth-token errors.
        appRouter.go(
          RouteNames.signin,
          extra: target,
        );
      } catch (e) {
        MyLogger.error('[DeepLink] Failed to handle deep link: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
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
