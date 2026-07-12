import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

class MyValidator {
  static String? validateEmptyText(
    BuildContext context,
    String? fieldName,
    String? text,
  ) {
    if (text == null || text.isEmpty) {
      return S.of(context).error_field_required;
    }
    return null;
  }

  static String? validateEmail(BuildContext context, String? email) {
    if (email == null || email.isEmpty) {
      return S.of(context).error_email_required;
    }

    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return S.of(context).error_email_invalid;
    }
    return null;
  }

  static String? validatePassword(BuildContext context, String? password) {
    if (password == null || password.isEmpty) {
      return S.of(context).error_password_required;
    }

    if (password.length < 6) {
      return S.of(context).error_password_short;
    }

    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return S.of(context).error_password_uppercase;
    }

    // Check for at least one number
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return S.of(context).error_password_number;
    }

    return null;
  }

  static String? validatePhoneNumber(
    BuildContext context,
    String? phoneNumber,
  ) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return S.of(context).error_phone_required;
    }

    final RegExp phoneNumberRegex = RegExp(r'^\d{11}$');
    if (!phoneNumberRegex.hasMatch(phoneNumber)) {
      return S.of(context).error_phone_invalid;
    }

    return null;
  }

  static String? validateConfirmPassword(
    BuildContext context,
    String? password,
    String? confirmPassword,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return S.of(context).error_confirm_password_required;
    }
    if (password != confirmPassword) {
      return S.of(context).error_passwords_not_match;
    }
    return null;
  }

  static String? usernameValidator(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }

    if (value.contains('@')) {
      return 'Username cannot contain @';
    }

    if (value.trim().length < 3) {
      return 'Username must be at least 3 characters';
    }

    return null;
  }
}
