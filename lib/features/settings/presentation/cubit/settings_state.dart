part of 'settings_cubit.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();
  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

class SettingsSuccess<T> extends SettingsState {
  final T data;
  final bool isUpdating;

  const SettingsSuccess({required this.data, this.isUpdating = false});

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

  const SettingsFailure({required this.errormessage});

  @override
  List<Object?> get props => [errormessage];
}
