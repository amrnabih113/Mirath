part of 'settings_cubit.dart';

abstract class SettingsState extends Equatable {}

class SettingsInitial extends SettingsState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class SettingsLoading extends SettingsState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class SettingsSuccess<T> extends SettingsState {
  final T data;
  final bool isUpdating;
  

  SettingsSuccess({required this.data, this.isUpdating = false});

  SettingsSuccess<T> copyWith({T? data, bool? isUpdating}) {
    return SettingsSuccess<T>(
      data: data ?? this.data,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }

  @override
  List<Object?> get props => [data, isUpdating]; // مهم جداً لتحديث الـ UI
}

class SettingsFailure<T> extends SettingsState {
  final String errormessage;
  final String? request;

  SettingsFailure({required this.errormessage, this.request});

  @override
  List<Object?> get props => throw UnimplementedError();
}
