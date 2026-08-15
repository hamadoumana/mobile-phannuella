part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;
  const LoginRequested({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

/// Mode invite (sans compte Keycloak) -- pour explorer l'app sans backend
/// configure. TODO(AUTH): a retirer avant la mise en production.
class GuestLoginRequested extends AuthEvent {
  const GuestLoginRequested();
}

class RegisterRequested extends AuthEvent {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String password;
  final String? email;

  const RegisterRequested({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.password,
    this.email,
  });

  @override
  List<Object?> get props => [firstName, lastName, phoneNumber, password, email];
}

/// Reinitialisation du mot de passe par numero de telephone seul (pas de
/// verification OTP -- cf. commentaire dans ResetPassword.cs cote backend).
class ResetPasswordRequested extends AuthEvent {
  final String phoneNumber;
  final String newPassword;

  const ResetPasswordRequested({required this.phoneNumber, required this.newPassword});

  @override
  List<Object?> get props => [phoneNumber, newPassword];
}
