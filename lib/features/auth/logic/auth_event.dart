part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  const LoginRequested({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}

final class RegisterRequested extends AuthEvent {
  final User user;
  final String password;

  const RegisterRequested({required this.user, required this.password});

  @override
  List<Object> get props => [user];
}

final class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}
