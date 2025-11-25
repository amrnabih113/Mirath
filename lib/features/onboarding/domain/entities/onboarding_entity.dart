import 'package:equatable/equatable.dart';

class OnboardingEntity extends Equatable {
  final String title;
  final String description;
  final String imagePath;

  const OnboardingEntity({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  List<Object?> get props => [title, description, imagePath];

}
