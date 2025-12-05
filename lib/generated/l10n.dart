// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Instantly Find Any Research`
  String get onboarding_title_1 {
    return Intl.message(
      'Instantly Find Any Research',
      name: 'onboarding_title_1',
      desc: '',
      args: [],
    );
  }

  /// `You can search by keywords, authors, titles, or even paste a block of text to find the exact paper you need.`
  String get onboarding_description_1 {
    return Intl.message(
      'You can search by keywords, authors, titles, or even paste a block of text to find the exact paper you need.',
      name: 'onboarding_description_1',
      desc: '',
      args: [],
    );
  }

  /// `Master Your Papers with Active Notes`
  String get onboarding_title_2 {
    return Intl.message(
      'Master Your Papers with Active Notes',
      name: 'onboarding_title_2',
      desc: '',
      args: [],
    );
  }

  /// `Enhance your learning by highlighting key passages. Write linked notes, track your insights on a separate page, and create your own summaries.`
  String get onboarding_description_2 {
    return Intl.message(
      'Enhance your learning by highlighting key passages. Write linked notes, track your insights on a separate page, and create your own summaries.',
      name: 'onboarding_description_2',
      desc: '',
      args: [],
    );
  }

  /// `Collaborate and Write with Confidence`
  String get onboarding_title_3 {
    return Intl.message(
      'Collaborate and Write with Confidence',
      name: 'onboarding_title_3',
      desc: '',
      args: [],
    );
  }

  /// `Start teams to share resources and notes. Use AI to refine your writing and check journal formatting.`
  String get onboarding_description_3 {
    return Intl.message(
      'Start teams to share resources and notes. Use AI to refine your writing and check journal formatting.',
      name: 'onboarding_description_3',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get get_started {
    return Intl.message(
      'Get Started',
      name: 'get_started',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
