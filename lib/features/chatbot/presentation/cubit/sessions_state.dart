import 'package:equatable/equatable.dart';
import '../../domain/entities/session.dart';

sealed class SessionsState extends Equatable {
  const SessionsState();

  @override
  List<Object?> get props => [];
}

class SessionsInitial extends SessionsState {
  const SessionsInitial();
}

class SessionsLoading extends SessionsState {
  const SessionsLoading();
}

class SessionsLoaded extends SessionsState {
  final List<Session> sessions;

  const SessionsLoaded({required this.sessions});

  @override
  List<Object?> get props => [sessions];
}

class SessionsError extends SessionsState {
  final String message;

  const SessionsError({required this.message});

  @override
  List<Object?> get props => [message];
}
