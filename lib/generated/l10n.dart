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
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
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
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
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
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Get Started`
  String get get_started {
    return Intl.message('Get Started', name: 'get_started', desc: '', args: []);
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
    return Intl.message('Verify code', name: 'Verify_code', desc: '', args: []);
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
    return Intl.message('Resend code', name: 'Resend_code', desc: '', args: []);
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

  /// `Login Here`
  String get login_here {
    return Intl.message('Login Here', name: 'login_here', desc: '', args: []);
  }

  /// `Welcome back to Mirath!`
  String get welcome_back {
    return Intl.message(
      'Welcome back to Mirath!',
      name: 'welcome_back',
      desc: '',
      args: [],
    );
  }

  /// `Email or Username`
  String get email_or_username {
    return Intl.message(
      'Email or Username',
      name: 'email_or_username',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Forgot Password?`
  String get forgot_password {
    return Intl.message(
      'Forgot Password?',
      name: 'forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get sign_in {
    return Intl.message('Sign In', name: 'sign_in', desc: '', args: []);
  }

  /// `Don't have an account? `
  String get dont_have_account {
    return Intl.message(
      'Don\'t have an account? ',
      name: 'dont_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get sign_up {
    return Intl.message('Sign Up', name: 'sign_up', desc: '', args: []);
  }

  /// `Or sign in with`
  String get or_sign_in_with {
    return Intl.message(
      'Or sign in with',
      name: 'or_sign_in_with',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get create_account {
    return Intl.message(
      'Create Account',
      name: 'create_account',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to Mirath! Create an account\nfor better research experience.`
  String get welcome_to_mirath {
    return Intl.message(
      'Welcome to Mirath! Create an account\nfor better research experience.',
      name: 'welcome_to_mirath',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message('Username', name: 'username', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Confirm Password`
  String get confirm_password_hint {
    return Intl.message(
      'Confirm Password',
      name: 'confirm_password_hint',
      desc: '',
      args: [],
    );
  }

  /// `I agree to the `
  String get i_agree_to {
    return Intl.message(
      'I agree to the ',
      name: 'i_agree_to',
      desc: '',
      args: [],
    );
  }

  /// `Terms and Conditions`
  String get terms_and_conditions {
    return Intl.message(
      'Terms and Conditions',
      name: 'terms_and_conditions',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account? `
  String get already_have_account {
    return Intl.message(
      'Already have an account? ',
      name: 'already_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Log in`
  String get log_in {
    return Intl.message('Log in', name: 'log_in', desc: '', args: []);
  }

  /// `Forget Password`
  String get forget_password {
    return Intl.message(
      'Forget Password',
      name: 'forget_password',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email to receive a reset OTP.`
  String get enter_email_reset {
    return Intl.message(
      'Enter your email to receive a reset OTP.',
      name: 'enter_email_reset',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get email_address {
    return Intl.message(
      'Email Address',
      name: 'email_address',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get reset_password {
    return Intl.message(
      'Reset Password',
      name: 'reset_password',
      desc: '',
      args: [],
    );
  }

  /// `Success!`
  String get success {
    return Intl.message('Success!', name: 'success', desc: '', args: []);
  }

  /// `Verified!`
  String get verified {
    return Intl.message('Verified!', name: 'verified', desc: '', args: []);
  }

  /// `OTP sent successfully.`
  String get otp_sent_success {
    return Intl.message(
      'OTP sent successfully.',
      name: 'otp_sent_success',
      desc: '',
      args: [],
    );
  }

  /// `Account verified successfully.`
  String get account_verified_success {
    return Intl.message(
      'Account verified successfully.',
      name: 'account_verified_success',
      desc: '',
      args: [],
    );
  }

  /// `Account created. Please verify your email.`
  String get account_created_verify {
    return Intl.message(
      'Account created. Please verify your email.',
      name: 'account_created_verify',
      desc: '',
      args: [],
    );
  }

  /// `Please verify your account`
  String get please_verify_account {
    return Intl.message(
      'Please verify your account',
      name: 'please_verify_account',
      desc: '',
      args: [],
    );
  }

  /// `Oh no!`
  String get error_title {
    return Intl.message('Oh no!', name: 'error_title', desc: '', args: []);
  }

  /// `Warning`
  String get warning_title {
    return Intl.message('Warning', name: 'warning_title', desc: '', args: []);
  }

  /// `Something went wrong.`
  String get something_went_wrong {
    return Intl.message(
      'Something went wrong.',
      name: 'something_went_wrong',
      desc: '',
      args: [],
    );
  }

  /// `You must agree to the Terms and Conditions to sign up.`
  String get terms_agreement_required {
    return Intl.message(
      'You must agree to the Terms and Conditions to sign up.',
      name: 'terms_agreement_required',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong on the server. Please try again later.`
  String get error_server {
    return Intl.message(
      'Something went wrong on the server. Please try again later.',
      name: 'error_server',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection. Please check your connection and try again.`
  String get error_network {
    return Intl.message(
      'No internet connection. Please check your connection and try again.',
      name: 'error_network',
      desc: '',
      args: [],
    );
  }

  /// `The request took too long. Please try again later.`
  String get error_timeout {
    return Intl.message(
      'The request took too long. Please try again later.',
      name: 'error_timeout',
      desc: '',
      args: [],
    );
  }

  /// `The request was cancelled.`
  String get error_cancelled {
    return Intl.message(
      'The request was cancelled.',
      name: 'error_cancelled',
      desc: '',
      args: [],
    );
  }

  /// `You are not authorized. Please log in again.`
  String get error_unauthorized {
    return Intl.message(
      'You are not authorized. Please log in again.',
      name: 'error_unauthorized',
      desc: '',
      args: [],
    );
  }

  /// `Access denied. You do not have permission.`
  String get error_forbidden {
    return Intl.message(
      'Access denied. You do not have permission.',
      name: 'error_forbidden',
      desc: '',
      args: [],
    );
  }

  /// `Some fields are invalid. Please review your input.`
  String get error_validation {
    return Intl.message(
      'Some fields are invalid. Please review your input.',
      name: 'error_validation',
      desc: '',
      args: [],
    );
  }

  /// `A data conflict occurred. Please refresh and try again.`
  String get error_conflict {
    return Intl.message(
      'A data conflict occurred. Please refresh and try again.',
      name: 'error_conflict',
      desc: '',
      args: [],
    );
  }

  /// `Requested resource was not found.`
  String get error_not_found {
    return Intl.message(
      'Requested resource was not found.',
      name: 'error_not_found',
      desc: '',
      args: [],
    );
  }

  /// `An unexpected error occurred. Please try again.`
  String get error_unexpected {
    return Intl.message(
      'An unexpected error occurred. Please try again.',
      name: 'error_unexpected',
      desc: '',
      args: [],
    );
  }

  /// `Google Sign-In was cancelled.`
  String get error_google_signin_cancelled {
    return Intl.message(
      'Google Sign-In was cancelled.',
      name: 'error_google_signin_cancelled',
      desc: '',
      args: [],
    );
  }

  /// `Google Sign-In failed. Please try again.`
  String get error_google_signin_failed {
    return Intl.message(
      'Google Sign-In failed. Please try again.',
      name: 'error_google_signin_failed',
      desc: '',
      args: [],
    );
  }

  /// `Network error during Google Sign-In. Check your connection.`
  String get error_google_signin_network {
    return Intl.message(
      'Network error during Google Sign-In. Check your connection.',
      name: 'error_google_signin_network',
      desc: '',
      args: [],
    );
  }

  /// `Google Sign-In is not configured properly.`
  String get error_google_signin_config {
    return Intl.message(
      'Google Sign-In is not configured properly.',
      name: 'error_google_signin_config',
      desc: '',
      args: [],
    );
  }

  /// `Apple Sign-In is not available on this device.`
  String get error_apple_signin_not_available {
    return Intl.message(
      'Apple Sign-In is not available on this device.',
      name: 'error_apple_signin_not_available',
      desc: '',
      args: [],
    );
  }

  /// `Apple Sign-In was cancelled.`
  String get error_apple_signin_cancelled {
    return Intl.message(
      'Apple Sign-In was cancelled.',
      name: 'error_apple_signin_cancelled',
      desc: '',
      args: [],
    );
  }

  /// `Apple Sign-In failed. Please try again.`
  String get error_apple_signin_failed {
    return Intl.message(
      'Apple Sign-In failed. Please try again.',
      name: 'error_apple_signin_failed',
      desc: '',
      args: [],
    );
  }

  /// `Email is required.`
  String get error_email_required {
    return Intl.message(
      'Email is required.',
      name: 'error_email_required',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email format.`
  String get error_email_invalid {
    return Intl.message(
      'Invalid email format.',
      name: 'error_email_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Password is required.`
  String get error_password_required {
    return Intl.message(
      'Password is required.',
      name: 'error_password_required',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters long.`
  String get error_password_short {
    return Intl.message(
      'Password must be at least 6 characters long.',
      name: 'error_password_short',
      desc: '',
      args: [],
    );
  }

  /// `This field is required.`
  String get error_field_required {
    return Intl.message(
      'This field is required.',
      name: 'error_field_required',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match.`
  String get error_passwords_not_match {
    return Intl.message(
      'Passwords do not match.',
      name: 'error_passwords_not_match',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password is required.`
  String get error_confirm_password_required {
    return Intl.message(
      'Confirm password is required.',
      name: 'error_confirm_password_required',
      desc: '',
      args: [],
    );
  }

  /// `Phone number is required.`
  String get error_phone_required {
    return Intl.message(
      'Phone number is required.',
      name: 'error_phone_required',
      desc: '',
      args: [],
    );
  }

  /// `Invalid phone number format.`
  String get error_phone_invalid {
    return Intl.message(
      'Invalid phone number format.',
      name: 'error_phone_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Profile set up successfully.`
  String get profile_setup_success {
    return Intl.message(
      'Profile set up successfully.',
      name: 'profile_setup_success',
      desc: '',
      args: [],
    );
  }

  /// `Password reset successfully.`
  String get password_reset_success {
    return Intl.message(
      'Password reset successfully.',
      name: 'password_reset_success',
      desc: '',
      args: [],
    );
  }

  /// `OTP verified. You can now reset your password.`
  String get otp_verified_success {
    return Intl.message(
      'OTP verified. You can now reset your password.',
      name: 'otp_verified_success',
      desc: '',
      args: [],
    );
  }

  /// `Password reset code sent to your email.`
  String get password_reset_code_sent {
    return Intl.message(
      'Password reset code sent to your email.',
      name: 'password_reset_code_sent',
      desc: '',
      args: [],
    );
  }

  /// `Set Up Your Profile`
  String get set_up_profile {
    return Intl.message(
      'Set Up Your Profile',
      name: 'set_up_profile',
      desc: '',
      args: [],
    );
  }

  /// `Upload Picture`
  String get upload_picture {
    return Intl.message(
      'Upload Picture',
      name: 'upload_picture',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Enter your name`
  String get enter_your_name {
    return Intl.message(
      'Enter your name',
      name: 'enter_your_name',
      desc: '',
      args: [],
    );
  }

  /// `Choose a username`
  String get choose_username {
    return Intl.message(
      'Choose a username',
      name: 'choose_username',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email`
  String get enter_your_email {
    return Intl.message(
      'Enter your email',
      name: 'enter_your_email',
      desc: '',
      args: [],
    );
  }

  /// `Education Level`
  String get education_level {
    return Intl.message(
      'Education Level',
      name: 'education_level',
      desc: '',
      args: [],
    );
  }

  /// `Select your education level`
  String get select_education_level {
    return Intl.message(
      'Select your education level',
      name: 'select_education_level',
      desc: '',
      args: [],
    );
  }

  /// `High School`
  String get high_school {
    return Intl.message('High School', name: 'high_school', desc: '', args: []);
  }

  /// `Undergraduate`
  String get undergraduate {
    return Intl.message(
      'Undergraduate',
      name: 'undergraduate',
      desc: '',
      args: [],
    );
  }

  /// `Graduated`
  String get graduated {
    return Intl.message('Graduated', name: 'graduated', desc: '', args: []);
  }

  /// `University Name`
  String get university_name {
    return Intl.message(
      'University Name',
      name: 'university_name',
      desc: '',
      args: [],
    );
  }

  /// `Enter your university name`
  String get enter_university_name {
    return Intl.message(
      'Enter your university name',
      name: 'enter_university_name',
      desc: '',
      args: [],
    );
  }

  /// `Sign Out`
  String get sign_out {
    return Intl.message('Sign Out', name: 'sign_out', desc: '', args: []);
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
