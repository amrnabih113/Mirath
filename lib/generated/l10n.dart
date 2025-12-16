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

  /// `Password Reset`
  String get Password_Reset {
    return Intl.message(
      'Password Reset',
      name: 'Password_Reset',
      desc: '',
      args: [],
    );
  }

  /// `We just sent a 6-digit code to your email, enter it below:`
  String get OTP_code_description {
    return Intl.message(
      'We just sent a 6-digit code to your email, enter it below:',
      name: 'OTP_code_description',
      desc: '',
      args: [],
    );
  }

  /// `Verify code`
  String get Verify_code {
    return Intl.message(
      'Verify code',
      name: 'Verify_code',
      desc: '',
      args: [],
    );
  }

  /// `Haven’t got the email yet?`
  String get Have_not_got_yet {
    return Intl.message(
      'Haven’t got the email yet?',
      name: 'Have_not_got_yet',
      desc: '',
      args: [],
    );
  }

  /// `Resend code`
  String get Resend_code {
    return Intl.message(
      'Resend code',
      name: 'Resend_code',
      desc: '',
      args: [],
    );
  }

  /// `Set a new password`
  String get Set_a_new_password {
    return Intl.message(
      'Set a new password',
      name: 'Set_a_new_password',
      desc: '',
      args: [],
    );
  }

  /// `Create a new password. Ensure it differs fromprevious ones for security`
  String get Create_a_new_password_description {
    return Intl.message(
      'Create a new password. Ensure it differs fromprevious ones for security',
      name: 'Create_a_new_password_description',
      desc: '',
      args: [],
    );
  }

  /// `Your new password`
  String get Your_new_password {
    return Intl.message(
      'Your new password',
      name: 'Your_new_password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password`
  String get Confirm_password {
    return Intl.message(
      'Confirm password',
      name: 'Confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Update password`
  String get Update_password {
    return Intl.message(
      'Update password',
      name: 'Update_password',
      desc: '',
      args: [],
    );
  }

  /// `Verify your email`
  String get Verify_your_email {
    return Intl.message(
      'Verify your email',
      name: 'Verify_your_email',
      desc: '',
      args: [],
    );
  }

  /// `Verify email`
  String get Verify_email {
    return Intl.message(
      'Verify email',
      name: 'Verify_email',
      desc: '',
      args: [],
    );
  }

  /// `Resend code in`
  String get Resend_code_in {
    return Intl.message(
      'Resend code in',
      name: 'Resend_code_in',
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
