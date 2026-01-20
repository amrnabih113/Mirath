import 'package:equatable/equatable.dart';

import '../../domain/entities/interest.dart';

abstract class InterestsState extends Equatable {
  const InterestsState();

  @override
  List<Object?> get props => [];
}

class InterestsInitial extends InterestsState {}

class InterestsLoading extends InterestsState {}

class InterestsLoaded extends InterestsState {
  final List<Interest> interests;

  const InterestsLoaded(this.interests);

  @override
  List<Object> get props => [interests];
}

class InterestLoaded extends InterestsState {
  final Interest interest;

  const InterestLoaded(this.interest);

  @override
  List<Object> get props => [interest];
}

class InterestsError extends InterestsState {
  final String message;

  const InterestsError(this.message);

  @override
  List<Object> get props => [message];
}
