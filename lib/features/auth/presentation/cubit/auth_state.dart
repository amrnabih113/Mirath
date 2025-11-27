part of 'auth_cubit.dart';

enum AuthStatus {
  initial, // App just started
  loading, // Any API call in progress
  authenticated, // User logged in
  unverified, // User needs to verify account
  unauthenticated, // User logged out
  otpSent, // OTP sent for verification
  otpVerified, // OTP verified successfully
  resetPasswordRequested, // Forgot password OTP sent
  resetPasswordVerified, // OTP for reset verified
  success, // Generic success message
  error, // Generic error message
}

class AuthState extends Equatable {
  final AuthStatus status;
  final String? message;

  const AuthState({required this.status, this.message});

  factory AuthState.initial() => const AuthState(status: AuthStatus.initial);

  
  AuthState copyWith({
    AuthStatus? status,
    String? message,
    bool clearMessage = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [status, message];
}
