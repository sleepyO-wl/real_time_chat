import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'auth_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc({required this.authService}) : super(AuthInitial()) {
    on<LoginEvent>(_onLoginEvent);
    on<SignupEvent>(_onSignupEvent);
    on<LogoutEvent>(_onLogoutEvent);
    on<CheckAuthenticationEvent>(_onCheckAuthenticationEvent);
  }

  Future<void> _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final username = await authService.authenticate(event.username, event.password);
      if (username != null) {
        emit(AuthAuthenticated(username: username));
      } else {
        emit(AuthError(message: "Authentication failed"));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onSignupEvent(SignupEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final username = await authService.register(event.username, event.password);
      if (username != null) {
        emit(AuthAuthenticated(username: username));
      } else {
        emit(AuthError(message: "Signup failed"));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  void _onLogoutEvent(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await authService.logout();
    emit(AuthUnauthenticated());
  }

  Future<void> _onCheckAuthenticationEvent(CheckAuthenticationEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final isAuthenticated = await authService.isAuthenticated();
    if (isAuthenticated) {
      final username = await authService.getCurrentUser();
      emit(AuthAuthenticated(username: username));
    } else {
      emit(AuthUnauthenticated());
    }
  }
}
