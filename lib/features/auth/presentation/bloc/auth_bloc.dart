import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/network/keycloak_service.dart';
import '../../data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final KeycloakService _keycloakService;
  final AuthRepository _authRepository;

  AuthBloc(this._keycloakService, this._authRepository) : super(const AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<GuestLoginRequested>(_onGuestLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      await _keycloakService.login(username: event.username, password: event.password);
      emit(const AuthSuccess());
    } catch (e) {
      emit(AuthFailure(ErrorHandler.handle(e).message));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    await _keycloakService.logout();
    emit(const AuthLoggedOut());
  }

  Future<void> _onGuestLoginRequested(
    GuestLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _keycloakService.loginAsGuest();
    emit(const AuthSuccess());
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _authRepository.register(
        firstName: event.firstName,
        lastName: event.lastName,
        phoneNumber: event.phoneNumber,
        password: event.password,
        email: event.email,
      );
      // Le compte Keycloak est cree, on connecte directement l'utilisateur
      // avec les identifiants qu'il vient de choisir.
      await _keycloakService.login(username: event.phoneNumber, password: event.password);
      emit(const AuthSuccess());
    } catch (e) {
      emit(AuthFailure(ErrorHandler.handle(e).message));
    }
  }

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _authRepository.resetPassword(
        phoneNumber: event.phoneNumber,
        newPassword: event.newPassword,
      );
      emit(const PasswordResetSuccess());
    } catch (e) {
      emit(AuthFailure(ErrorHandler.handle(e).message));
    }
  }
}
