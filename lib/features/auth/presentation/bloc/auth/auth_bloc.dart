import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_signup_app/features/auth/domain/auth_repository.dart';
import 'package:login_signup_app/features/auth/presentation/bloc/auth/auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  /// Constructeur de la classe AuthBloc.
  AuthBloc(this.authRepository) : super(AuthInitial()) {
    /// Ecoute des événements de type SignInRequested.
    /// Si un utilisateur tente de se connecter,
    /// appelle la méthode signIn de l'authRepository.
    /// Si la méthode signIn est réussie,
    /// émet un AuthSuccess.
    /// Si la méthode signIn échoue,
    /// émet un AuthFailure avec le message d'erreur.
    on<SignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.signIn(event.email, event.password);
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.signUp(event.email, event.password);
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    /// Ecoute des événements de type SignOutRequested.
    /// Si un utilisateur tente de se déconnecter,
    /// appelle la méthode signOut de l'authRepository.
    /// Si la méthode signOut est réussie,
    /// émet un AuthInitial.
    /// Si la méthode signOut échoue,
    /// émet un AuthFailure avec le message d'erreur.

    on<SignOutRequested>((event, emit) async {
      //emit(AuthLoading());
      await authRepository.signOut();
      emit(AuthInitial());
    });

    on<CheckAuthStatus>((event, emit) async {
      await Future.delayed(const Duration(seconds: 2));

      /// retourne la première valeur émise par le flux.
      /// Si l'utilisateur n'est pas connecté,
      /// émet un AuthInitial.
      /// Si l'utilisateur est connecté,
      /// émet un AuthSuccess.
      /// Si une erreur se produit,
      /// émet un AuthFailure avec le message d'erreur.
      final isLoggedIn = await authRepository.isSignedIn.first;
      try {
        if (isLoggedIn) {
          emit(AuthSuccess());
        } else {
          emit(AuthInitial());
        }
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
