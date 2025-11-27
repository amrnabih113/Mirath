import 'package:equatable/equatable.dart';

class SigninData extends Equatable {
  final String email;
  final String password;

  const SigninData({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
