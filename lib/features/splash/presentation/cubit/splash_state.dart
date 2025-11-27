part of 'splash_cubit.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object> get props => [];
}

class SplashInitial extends SplashState {}

class SplashNavigateToOnboarding extends SplashState {}

class SplashNavigateToSignIn extends SplashState {}

class SplashNavigateToVerifyAccount extends SplashState {}

class SplashNavigateToHome extends SplashState {}
