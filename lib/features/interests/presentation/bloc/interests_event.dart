import 'package:equatable/equatable.dart';

abstract class InterestsEvent extends Equatable {
  const InterestsEvent();

  @override
  List<Object?> get props => [];
}

class GetAllInterestsEvent extends InterestsEvent {}

class GetInterestByIdEvent extends InterestsEvent {
  final String id;

  const GetInterestByIdEvent(this.id);

  @override
  List<Object> get props => [id];
}
