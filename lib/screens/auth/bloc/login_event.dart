part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

final class AuthLoginEvent extends LoginEvent {
  final TextEditingController username;
  final TextEditingController password;

  AuthLoginEvent({required this.username, required this.password});
}
