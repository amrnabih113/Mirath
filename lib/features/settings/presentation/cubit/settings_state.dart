part of 'settings_cubit.dart';

abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsSuccess<T> extends SettingsState {
  final T data;

  SettingsSuccess({required this.data});
}

class SettingsFailure extends SettingsState {
  final String errormessage;

  SettingsFailure({required this.errormessage});
}
