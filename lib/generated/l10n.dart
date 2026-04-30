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

  /// `Password must contain at least one uppercase letter.`
  String get error_password_uppercase {
    return Intl.message(
      'Password must contain at least one uppercase letter.',
      name: 'error_password_uppercase',
      desc: '',
      args: [],
    );
  }

  /// `Password must contain at least one number.`
  String get error_password_number {
    return Intl.message(
      'Password must contain at least one number.',
      name: 'error_password_number',
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

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Account`
  String get account {
    return Intl.message('Account', name: 'account', desc: '', args: []);
  }

  /// `Account preferences`
  String get account_preferences {
    return Intl.message(
      'Account preferences',
      name: 'account_preferences',
      desc: '',
      args: [],
    );
  }

  /// `Sign in & security`
  String get sign_in_and_security {
    return Intl.message(
      'Sign in & security',
      name: 'sign_in_and_security',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Data privacy`
  String get data_privacy {
    return Intl.message(
      'Data privacy',
      name: 'data_privacy',
      desc: '',
      args: [],
    );
  }

  /// `Support & about`
  String get support_and_about {
    return Intl.message(
      'Support & about',
      name: 'support_and_about',
      desc: '',
      args: [],
    );
  }

  /// `Help & support`
  String get help_and_support {
    return Intl.message(
      'Help & support',
      name: 'help_and_support',
      desc: '',
      args: [],
    );
  }

  /// `Terms & policies`
  String get terms_and_policies {
    return Intl.message(
      'Terms & policies',
      name: 'terms_and_policies',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Edit profile`
  String get edit_profile {
    return Intl.message(
      'Edit profile',
      name: 'edit_profile',
      desc: '',
      args: [],
    );
  }

  /// `Edit picture`
  String get edit_picture {
    return Intl.message(
      'Edit picture',
      name: 'edit_picture',
      desc: '',
      args: [],
    );
  }

  /// `Bio`
  String get bio {
    return Intl.message('Bio', name: 'bio', desc: '', args: []);
  }

  /// `Level of education`
  String get level_of_education {
    return Intl.message(
      'Level of education',
      name: 'level_of_education',
      desc: '',
      args: [],
    );
  }

  /// `University`
  String get university {
    return Intl.message('University', name: 'university', desc: '', args: []);
  }

  /// `Current position`
  String get current_position {
    return Intl.message(
      'Current position',
      name: 'current_position',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get country {
    return Intl.message('Country', name: 'country', desc: '', args: []);
  }

  /// `Keep email private`
  String get keep_email_private {
    return Intl.message(
      'Keep email private',
      name: 'keep_email_private',
      desc: '',
      args: [],
    );
  }

  /// `Interests`
  String get interests {
    return Intl.message('Interests', name: 'interests', desc: '', args: []);
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Save changes`
  String get save_changes {
    return Intl.message(
      'Save changes',
      name: 'save_changes',
      desc: '',
      args: [],
    );
  }

  /// `Create list`
  String get create_list {
    return Intl.message('Create list', name: 'create_list', desc: '', args: []);
  }

  /// `List title`
  String get list_title {
    return Intl.message('List title', name: 'list_title', desc: '', args: []);
  }

  /// `Description (optional)`
  String get description_optional {
    return Intl.message(
      'Description (optional)',
      name: 'description_optional',
      desc: '',
      args: [],
    );
  }

  /// `Public list`
  String get public_list {
    return Intl.message('Public list', name: 'public_list', desc: '', args: []);
  }

  /// `Create`
  String get create {
    return Intl.message('Create', name: 'create', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `Follow`
  String get follow {
    return Intl.message('Follow', name: 'follow', desc: '', args: []);
  }

  /// `Discussions`
  String get discussions {
    return Intl.message('Discussions', name: 'discussions', desc: '', args: []);
  }

  /// `Are you sure you want to sign out?`
  String get are_you_sure_you_want_to_sign_out {
    return Intl.message(
      'Are you sure you want to sign out?',
      name: 'are_you_sure_you_want_to_sign_out',
      desc: '',
      args: [],
    );
  }

  /// `Mirath`
  String get app_title {
    return Intl.message('Mirath', name: 'app_title', desc: '', args: []);
  }

  /// `Recently Published`
  String get recently_published {
    return Intl.message(
      'Recently Published',
      name: 'recently_published',
      desc: '',
      args: [],
    );
  }

  /// `You Might Also Like`
  String get you_might_also_like {
    return Intl.message(
      'You Might Also Like',
      name: 'you_might_also_like',
      desc: '',
      args: [],
    );
  }

  /// `Search papers, authors, keywords...`
  String get search_papers_authors_keywords {
    return Intl.message(
      'Search papers, authors, keywords...',
      name: 'search_papers_authors_keywords',
      desc: '',
      args: [],
    );
  }

  /// `Your Library`
  String get your_library {
    return Intl.message(
      'Your Library',
      name: 'your_library',
      desc: '',
      args: [],
    );
  }

  /// `Projects`
  String get projects {
    return Intl.message('Projects', name: 'projects', desc: '', args: []);
  }

  /// `Reading Lists`
  String get reading_lists {
    return Intl.message(
      'Reading Lists',
      name: 'reading_lists',
      desc: '',
      args: [],
    );
  }

  /// `Reading History`
  String get reading_history {
    return Intl.message(
      'Reading History',
      name: 'reading_history',
      desc: '',
      args: [],
    );
  }

  /// `Read Later`
  String get read_later {
    return Intl.message('Read Later', name: 'read_later', desc: '', args: []);
  }

  /// `Papers updated {days} days ago`
  String papers_updated_days_ago(Object days) {
    return Intl.message(
      'Papers updated $days days ago',
      name: 'papers_updated_days_ago',
      desc: '',
      args: [days],
    );
  }

  /// `Followers`
  String get followers {
    return Intl.message('Followers', name: 'followers', desc: '', args: []);
  }

  /// `Following`
  String get following {
    return Intl.message('Following', name: 'following', desc: '', args: []);
  }

  /// `No results found`
  String get no_results_found {
    return Intl.message(
      'No results found',
      name: 'no_results_found',
      desc: '',
      args: [],
    );
  }

  /// `Try searching with different keywords`
  String get try_searching_with_different_keywords {
    return Intl.message(
      'Try searching with different keywords',
      name: 'try_searching_with_different_keywords',
      desc: '',
      args: [],
    );
  }

  /// `Start searching`
  String get start_searching {
    return Intl.message(
      'Start searching',
      name: 'start_searching',
      desc: '',
      args: [],
    );
  }

  /// `Data not loaded`
  String get data_not_loaded {
    return Intl.message(
      'Data not loaded',
      name: 'data_not_loaded',
      desc: '',
      args: [],
    );
  }

  /// `No reading lists yet`
  String get no_reading_lists_yet {
    return Intl.message(
      'No reading lists yet',
      name: 'no_reading_lists_yet',
      desc: '',
      args: [],
    );
  }

  /// `Could not locate this note in the rendered section.`
  String get error_note_not_located {
    return Intl.message(
      'Could not locate this note in the rendered section.',
      name: 'error_note_not_located',
      desc: '',
      args: [],
    );
  }

  /// `{action} will be available soon.`
  String coming_soon_message(Object action) {
    return Intl.message(
      '$action will be available soon.',
      name: 'coming_soon_message',
      desc: '',
      args: [action],
    );
  }

  /// `Select text to translate first.`
  String get error_select_text_translate {
    return Intl.message(
      'Select text to translate first.',
      name: 'error_select_text_translate',
      desc: '',
      args: [],
    );
  }

  /// `Unable to place highlight in this content section.`
  String get error_highlight_placement {
    return Intl.message(
      'Unable to place highlight in this content section.',
      name: 'error_highlight_placement',
      desc: '',
      args: [],
    );
  }

  /// `Unable to place note in this content section.`
  String get error_note_placement {
    return Intl.message(
      'Unable to place note in this content section.',
      name: 'error_note_placement',
      desc: '',
      args: [],
    );
  }

  /// `Discussions`
  String get discussions_label {
    return Intl.message(
      'Discussions',
      name: 'discussions_label',
      desc: '',
      args: [],
    );
  }

  /// `Start Discussion`
  String get start_discussion_button {
    return Intl.message(
      'Start Discussion',
      name: 'start_discussion_button',
      desc: '',
      args: [],
    );
  }

  /// `No abstract available.`
  String get no_abstract_available {
    return Intl.message(
      'No abstract available.',
      name: 'no_abstract_available',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username_label {
    return Intl.message('Username', name: 'username_label', desc: '', args: []);
  }

  /// `Name`
  String get name_field_label {
    return Intl.message('Name', name: 'name_field_label', desc: '', args: []);
  }

  /// `Bio`
  String get bio_field_label {
    return Intl.message('Bio', name: 'bio_field_label', desc: '', args: []);
  }

  /// `Level of education`
  String get education_level_label {
    return Intl.message(
      'Level of education',
      name: 'education_level_label',
      desc: '',
      args: [],
    );
  }

  /// `University`
  String get university_label {
    return Intl.message(
      'University',
      name: 'university_label',
      desc: '',
      args: [],
    );
  }

  /// `uni`
  String get university_hint {
    return Intl.message('uni', name: 'university_hint', desc: '', args: []);
  }

  /// `Current position`
  String get position_label {
    return Intl.message(
      'Current position',
      name: 'position_label',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get country_label {
    return Intl.message('Country', name: 'country_label', desc: '', args: []);
  }

  /// `Egypt`
  String get country_hint {
    return Intl.message('Egypt', name: 'country_hint', desc: '', args: []);
  }

  /// `Edit`
  String get edit_button {
    return Intl.message('Edit', name: 'edit_button', desc: '', args: []);
  }

  /// `John Doe`
  String get placeholder_name {
    return Intl.message(
      'John Doe',
      name: 'placeholder_name',
      desc: '',
      args: [],
    );
  }

  /// `Physics`
  String get placeholder_interest {
    return Intl.message(
      'Physics',
      name: 'placeholder_interest',
      desc: '',
      args: [],
    );
  }

  /// `35`
  String get placeholder_lists_count {
    return Intl.message(
      '35',
      name: 'placeholder_lists_count',
      desc: '',
      args: [],
    );
  }

  /// `Lists`
  String get lists_label {
    return Intl.message('Lists', name: 'lists_label', desc: '', args: []);
  }

  /// `10`
  String get placeholder_created_count {
    return Intl.message(
      '10',
      name: 'placeholder_created_count',
      desc: '',
      args: [],
    );
  }

  /// `Created`
  String get created_label {
    return Intl.message('Created', name: 'created_label', desc: '', args: []);
  }

  /// `25`
  String get placeholder_saved_count {
    return Intl.message(
      '25',
      name: 'placeholder_saved_count',
      desc: '',
      args: [],
    );
  }

  /// `Saved`
  String get saved_label {
    return Intl.message('Saved', name: 'saved_label', desc: '', args: []);
  }

  /// `2`
  String get placeholder_projects_count {
    return Intl.message(
      '2',
      name: 'placeholder_projects_count',
      desc: '',
      args: [],
    );
  }

  /// `Projects`
  String get projects_label {
    return Intl.message('Projects', name: 'projects_label', desc: '', args: []);
  }

  /// `{papers} papers • Updated {days} days ago`
  String read_later_stats(Object papers, Object days) {
    return Intl.message(
      '$papers papers • Updated $days days ago',
      name: 'read_later_stats',
      desc: '',
      args: [papers, days],
    );
  }

  /// `View All`
  String get view_all_button {
    return Intl.message(
      'View All',
      name: 'view_all_button',
      desc: '',
      args: [],
    );
  }

  /// `List title`
  String get list_title_hint {
    return Intl.message(
      'List title',
      name: 'list_title_hint',
      desc: '',
      args: [],
    );
  }

  /// `Description (optional)`
  String get description_hint {
    return Intl.message(
      'Description (optional)',
      name: 'description_hint',
      desc: '',
      args: [],
    );
  }

  /// `Public list`
  String get public_list_label {
    return Intl.message(
      'Public list',
      name: 'public_list_label',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get create_button {
    return Intl.message('Create', name: 'create_button', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel_button {
    return Intl.message('Cancel', name: 'cancel_button', desc: '', args: []);
  }

  /// `Create New List`
  String get create_new_list_button {
    return Intl.message(
      'Create New List',
      name: 'create_new_list_button',
      desc: '',
      args: [],
    );
  }

  /// `Start browsing discussions`
  String get empty_discussions_message {
    return Intl.message(
      'Start browsing discussions',
      name: 'empty_discussions_message',
      desc: '',
      args: [],
    );
  }

  /// `No discussion data`
  String get no_discussion_data {
    return Intl.message(
      'No discussion data',
      name: 'no_discussion_data',
      desc: '',
      args: [],
    );
  }

  /// `Write a comment...`
  String get comment_hint {
    return Intl.message(
      'Write a comment...',
      name: 'comment_hint',
      desc: '',
      args: [],
    );
  }

  /// `No discussions found`
  String get no_discussions_found {
    return Intl.message(
      'No discussions found',
      name: 'no_discussions_found',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title_hint {
    return Intl.message('Title', name: 'title_hint', desc: '', args: []);
  }

  /// `What do you want to discuss?`
  String get discussion_body_hint {
    return Intl.message(
      'What do you want to discuss?',
      name: 'discussion_body_hint',
      desc: '',
      args: [],
    );
  }

  /// `Search topics (e.g. Computer Science)`
  String get search_topics_hint {
    return Intl.message(
      'Search topics (e.g. Computer Science)',
      name: 'search_topics_hint',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry_button {
    return Intl.message('Retry', name: 'retry_button', desc: '', args: []);
  }

  /// `Write a reply...`
  String get reply_hint {
    return Intl.message(
      'Write a reply...',
      name: 'reply_hint',
      desc: '',
      args: [],
    );
  }

  /// `Jane Doe`
  String get placeholder_researcher_name {
    return Intl.message(
      'Jane Doe',
      name: 'placeholder_researcher_name',
      desc: '',
      args: [],
    );
  }

  /// `Translate`
  String get translate_label {
    return Intl.message(
      'Translate',
      name: 'translate_label',
      desc: '',
      args: [],
    );
  }

  /// `Copied to clipboard`
  String get copied_to_clipboard {
    return Intl.message(
      'Copied to clipboard',
      name: 'copied_to_clipboard',
      desc: '',
      args: [],
    );
  }

  /// `Choose a language`
  String get choose_language_title {
    return Intl.message(
      'Choose a language',
      name: 'choose_language_title',
      desc: '',
      args: [],
    );
  }

  /// `Detected as {language}`
  String detected_language_label(Object language) {
    return Intl.message(
      'Detected as $language',
      name: 'detected_language_label',
      desc: '',
      args: [language],
    );
  }

  /// `Delete Highlight`
  String get delete_highlight_title {
    return Intl.message(
      'Delete Highlight',
      name: 'delete_highlight_title',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this highlight?`
  String get confirm_delete_highlight {
    return Intl.message(
      'Are you sure you want to delete this highlight?',
      name: 'confirm_delete_highlight',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete_button {
    return Intl.message('Delete', name: 'delete_button', desc: '', args: []);
  }

  /// `Highlight`
  String get highlight_button {
    return Intl.message(
      'Highlight',
      name: 'highlight_button',
      desc: '',
      args: [],
    );
  }

  /// `Add Note`
  String get add_note_button {
    return Intl.message(
      'Add Note',
      name: 'add_note_button',
      desc: '',
      args: [],
    );
  }

  /// `Explain`
  String get explain_button {
    return Intl.message('Explain', name: 'explain_button', desc: '', args: []);
  }

  /// `Translate`
  String get translate_button {
    return Intl.message(
      'Translate',
      name: 'translate_button',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get remove_button {
    return Intl.message('Remove', name: 'remove_button', desc: '', args: []);
  }

  /// `Search in Paper`
  String get search_in_paper_button {
    return Intl.message(
      'Search in Paper',
      name: 'search_in_paper_button',
      desc: '',
      args: [],
    );
  }

  /// `Notes ({noteCount})`
  String notes_button_label(Object noteCount) {
    return Intl.message(
      'Notes ($noteCount)',
      name: 'notes_button_label',
      desc: '',
      args: [noteCount],
    );
  }

  /// `Highlights ({highlightCount})`
  String highlights_button_label(Object highlightCount) {
    return Intl.message(
      'Highlights ($highlightCount)',
      name: 'highlights_button_label',
      desc: '',
      args: [highlightCount],
    );
  }

  /// `Font Size`
  String get font_size_button {
    return Intl.message(
      'Font Size',
      name: 'font_size_button',
      desc: '',
      args: [],
    );
  }

  /// `Search in paper...`
  String get search_in_paper_hint {
    return Intl.message(
      'Search in paper...',
      name: 'search_in_paper_hint',
      desc: '',
      args: [],
    );
  }

  /// `Font Size`
  String get font_size_title {
    return Intl.message(
      'Font Size',
      name: 'font_size_title',
      desc: '',
      args: [],
    );
  }

  /// `{size}%`
  String font_size_percentage(Object size) {
    return Intl.message(
      '$size%',
      name: 'font_size_percentage',
      desc: '',
      args: [size],
    );
  }

  /// `Write your note...`
  String get note_hint {
    return Intl.message(
      'Write your note...',
      name: 'note_hint',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get nav_home_label {
    return Intl.message('Home', name: 'nav_home_label', desc: '', args: []);
  }

  /// `Community`
  String get nav_community_label {
    return Intl.message(
      'Community',
      name: 'nav_community_label',
      desc: '',
      args: [],
    );
  }

  /// `Library`
  String get nav_library_label {
    return Intl.message(
      'Library',
      name: 'nav_library_label',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get nav_profile_label {
    return Intl.message(
      'Profile',
      name: 'nav_profile_label',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get attachment_camera {
    return Intl.message(
      'Camera',
      name: 'attachment_camera',
      desc: '',
      args: [],
    );
  }

  /// `Photos`
  String get attachment_photos {
    return Intl.message(
      'Photos',
      name: 'attachment_photos',
      desc: '',
      args: [],
    );
  }

  /// `Files`
  String get attachment_files {
    return Intl.message('Files', name: 'attachment_files', desc: '', args: []);
  }

  /// `Message Mirath AI...`
  String get chat_message_hint {
    return Intl.message(
      'Message Mirath AI...',
      name: 'chat_message_hint',
      desc: '',
      args: [],
    );
  }

  /// `Error loading interests`
  String get error_loading_interests {
    return Intl.message(
      'Error loading interests',
      name: 'error_loading_interests',
      desc: '',
      args: [],
    );
  }

  /// `Search interests...`
  String get interests_search_hint {
    return Intl.message(
      'Search interests...',
      name: 'interests_search_hint',
      desc: '',
      args: [],
    );
  }

  /// `Field`
  String get generic_field_label {
    return Intl.message(
      'Field',
      name: 'generic_field_label',
      desc: '',
      args: [],
    );
  }

  /// `Enter value`
  String get generic_field_hint {
    return Intl.message(
      'Enter value',
      name: 'generic_field_hint',
      desc: '',
      args: [],
    );
  }

  /// `Search...`
  String get generic_search_hint {
    return Intl.message(
      'Search...',
      name: 'generic_search_hint',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search_placeholder {
    return Intl.message(
      'Search',
      name: 'search_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Tag`
  String get generic_tag_label {
    return Intl.message('Tag', name: 'generic_tag_label', desc: '', args: []);
  }

  /// `Error`
  String get error_label {
    return Intl.message('Error', name: 'error_label', desc: '', args: []);
  }

  /// `Error: No paper data provided`
  String get error_no_paper_data {
    return Intl.message(
      'Error: No paper data provided',
      name: 'error_no_paper_data',
      desc: '',
      args: [],
    );
  }

  /// `No discussions yet`
  String get no_discussions_yet_paper {
    return Intl.message(
      'No discussions yet',
      name: 'no_discussions_yet_paper',
      desc: '',
      args: [],
    );
  }

  /// `Be the first to start a discussion about this paper`
  String get be_first_discuss_paper {
    return Intl.message(
      'Be the first to start a discussion about this paper',
      name: 'be_first_discuss_paper',
      desc: '',
      args: [],
    );
  }

  /// `Abstract`
  String get abstract_title {
    return Intl.message('Abstract', name: 'abstract_title', desc: '', args: []);
  }

  /// `Discussions`
  String get abstract_discussions {
    return Intl.message(
      'Discussions',
      name: 'abstract_discussions',
      desc: '',
      args: [],
    );
  }

  /// `View Discussions`
  String get view_discussions {
    return Intl.message(
      'View Discussions',
      name: 'view_discussions',
      desc: '',
      args: [],
    );
  }

  /// `View Discussions ({discussionsCount})`
  String view_discussions_count(Object discussionsCount) {
    return Intl.message(
      'View Discussions ($discussionsCount)',
      name: 'view_discussions_count',
      desc: '',
      args: [discussionsCount],
    );
  }

  /// `Start a Discussion`
  String get start_discussion_here {
    return Intl.message(
      'Start a Discussion',
      name: 'start_discussion_here',
      desc: '',
      args: [],
    );
  }

  /// `Lorem ipsum dolor sit amet,`
  String get bio_hint {
    return Intl.message(
      'Lorem ipsum dolor sit amet,',
      name: 'bio_hint',
      desc: '',
      args: [],
    );
  }

  /// `Keep email private`
  String get keep_email_private_label {
    return Intl.message(
      'Keep email private',
      name: 'keep_email_private_label',
      desc: '',
      args: [],
    );
  }

  /// `Interests`
  String get interests_label {
    return Intl.message(
      'Interests',
      name: 'interests_label',
      desc: '',
      args: [],
    );
  }

  /// `Save to Reading List`
  String get save_to_reading_list {
    return Intl.message(
      'Save to Reading List',
      name: 'save_to_reading_list',
      desc: '',
      args: [],
    );
  }

  /// `Paper unsaved successfully`
  String get paper_unsaved_message {
    return Intl.message(
      'Paper unsaved successfully',
      name: 'paper_unsaved_message',
      desc: '',
      args: [],
    );
  }

  /// `Paper saved successfully`
  String get paper_saved_message {
    return Intl.message(
      'Paper saved successfully',
      name: 'paper_saved_message',
      desc: '',
      args: [],
    );
  }

  /// `Failed to create discussion`
  String get failed_to_create_discussion {
    return Intl.message(
      'Failed to create discussion',
      name: 'failed_to_create_discussion',
      desc: '',
      args: [],
    );
  }

  /// `Discussion created successfully`
  String get discussion_created_successfully {
    return Intl.message(
      'Discussion created successfully',
      name: 'discussion_created_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Failed to unsave paper`
  String get failed_to_unsave_paper {
    return Intl.message(
      'Failed to unsave paper',
      name: 'failed_to_unsave_paper',
      desc: '',
      args: [],
    );
  }

  /// `Info`
  String get info_title {
    return Intl.message('Info', name: 'info_title', desc: '', args: []);
  }

  /// `Please write a comment`
  String get please_write_comment {
    return Intl.message(
      'Please write a comment',
      name: 'please_write_comment',
      desc: '',
      args: [],
    );
  }

  /// `Post`
  String get post_button {
    return Intl.message('Post', name: 'post_button', desc: '', args: []);
  }

  /// `Add Tag`
  String get add_tag_title {
    return Intl.message('Add Tag', name: 'add_tag_title', desc: '', args: []);
  }

  /// `Tags help your discussion reach more people ({count}/5)`
  String tags_help_message(Object count) {
    return Intl.message(
      'Tags help your discussion reach more people ($count/5)',
      name: 'tags_help_message',
      desc: '',
      args: [count],
    );
  }

  /// `No tags found`
  String get no_tags_found {
    return Intl.message(
      'No tags found',
      name: 'no_tags_found',
      desc: '',
      args: [],
    );
  }

  /// `Sending...`
  String get sending_message {
    return Intl.message(
      'Sending...',
      name: 'sending_message',
      desc: '',
      args: [],
    );
  }

  /// `Failed to translate. Please try again.`
  String get failed_translate {
    return Intl.message(
      'Failed to translate. Please try again.',
      name: 'failed_translate',
      desc: '',
      args: [],
    );
  }

  /// `Highlighted Text`
  String get highlighted_text_label {
    return Intl.message(
      'Highlighted Text',
      name: 'highlighted_text_label',
      desc: '',
      args: [],
    );
  }

  /// `Note`
  String get note_label {
    return Intl.message('Note', name: 'note_label', desc: '', args: []);
  }

  /// `Change Color`
  String get change_color_label {
    return Intl.message(
      'Change Color',
      name: 'change_color_label',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save_button {
    return Intl.message('Save', name: 'save_button', desc: '', args: []);
  }

  /// `Copy`
  String get copy_button {
    return Intl.message('Copy', name: 'copy_button', desc: '', args: []);
  }

  /// `Top`
  String get top_label {
    return Intl.message('Top', name: 'top_label', desc: '', args: []);
  }

  /// `Researchers`
  String get researchers_label {
    return Intl.message(
      'Researchers',
      name: 'researchers_label',
      desc: '',
      args: [],
    );
  }

  /// `Reading List`
  String get reading_list_item_title {
    return Intl.message(
      'Reading List',
      name: 'reading_list_item_title',
      desc: '',
      args: [],
    );
  }

  /// `Mock description for reading list`
  String get mock_reading_list_description {
    return Intl.message(
      'Mock description for reading list',
      name: 'mock_reading_list_description',
      desc: '',
      args: [],
    );
  }

  /// `Mock Researcher`
  String get mock_researcher_name {
    return Intl.message(
      'Mock Researcher',
      name: 'mock_researcher_name',
      desc: '',
      args: [],
    );
  }

  /// `Previous`
  String get previous_button {
    return Intl.message(
      'Previous',
      name: 'previous_button',
      desc: '',
      args: [],
    );
  }

  /// `Close search`
  String get close_search_button {
    return Intl.message(
      'Close search',
      name: 'close_search_button',
      desc: '',
      args: [],
    );
  }

  /// `Yellow`
  String get yellow_color {
    return Intl.message('Yellow', name: 'yellow_color', desc: '', args: []);
  }

  /// `Green`
  String get green_color {
    return Intl.message('Green', name: 'green_color', desc: '', args: []);
  }

  /// `Blue`
  String get blue_color {
    return Intl.message('Blue', name: 'blue_color', desc: '', args: []);
  }

  /// `Purple`
  String get purple_color {
    return Intl.message('Purple', name: 'purple_color', desc: '', args: []);
  }

  /// `Red`
  String get red_color {
    return Intl.message('Red', name: 'red_color', desc: '', args: []);
  }

  /// `Cyan`
  String get cyan_color {
    return Intl.message('Cyan', name: 'cyan_color', desc: '', args: []);
  }

  /// `Change Color`
  String get change_color_button {
    return Intl.message(
      'Change Color',
      name: 'change_color_button',
      desc: '',
      args: [],
    );
  }

  /// `Edit Note`
  String get edit_note_button {
    return Intl.message(
      'Edit Note',
      name: 'edit_note_button',
      desc: '',
      args: [],
    );
  }

  /// `Delete Note`
  String get delete_note_button {
    return Intl.message(
      'Delete Note',
      name: 'delete_note_button',
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
