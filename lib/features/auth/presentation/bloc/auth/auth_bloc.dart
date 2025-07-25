import 'package:firebase_auth/firebase_auth.dart';
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

    on<ResetAuthEvent>((event, emit) {
      emit(AuthInitial());
    });

    on<SignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.signIn(event.email, event.password);
        final user = FirebaseAuth.instance.currentUser;
        if (user != null && !user.emailVerified) {
          emit(AuthFailure('email-not-verified'));
          return;
        } else {
          emit(AuthSuccess());
        }
      } on FirebaseException catch (e) {
        String message;
        switch (e.code) {
          case 'user-not-found':
            message = 'Utilisateur non trouvé';
            break;
          case 'wrong-password':
            message = 'Mot de passe incorrect';
            break;
          case 'invalid-email':
            message = 'Email invalide';
            break;
          case 'invalid-credential':
            message = 'Email ou mot de passe incorrect!';
            break;
          default:
            message = 'Pas de connexion internet,\nessayez plus tard';
        }
        emit(AuthFailure(message));
      } catch (e) {
        emit(AuthFailure('Un probleme est survenu , essayez plus tard'));
      }
    });

    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.signUp(event.email, event.password);
        // Envoyer l'email de vérification ici directement après inscription.
        await authRepository.sendEmailVerification();
        emit(EmailVerificationSent());
      } on FirebaseAuthException catch (e) {
        String message;
        switch (e.code) {
          case 'email-already-in-use':
            message = 'Cet email est déjà utilisé.';
            break;
          case 'invalid-email':
            message = 'Email invalide.';
            break;
          case 'weak-password':
            message = 'Mot de passe trop faible.';
            break;
          default:
            message = 'Pas de connexion internet,\nessayez plus tard';
        }
        emit(AuthFailure(message));
      } catch (e) {
        emit(AuthFailure('Un probleme est survenu , essayez plus tard'));
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
      emit(AuthLoading());
      await Future.delayed(const Duration(seconds: 1));
      await authRepository.signOut();
      emit(AuthInitial());
    });

    on<CheckAuthStatus>((event, emit) async {
      await Future.delayed(const Duration(seconds: 2));
      try {
        final isLoggedIn = await authRepository.isSignedIn.first;

        if (isLoggedIn) {
          // Vérifier si l'utilisateur a déjà envoyé un email de vérification
          final user = FirebaseAuth.instance.currentUser;
          if (user != null && !user.emailVerified) {
            //
            emit(AuthEmailNotVerified());
          } else {
            // L'utilisateur est connecté et l'email a déjà été vérifié
            emit(AuthSuccess());
          }
        } else {
          emit(AuthInitial());
        }
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });


    //
    on<CheckEmailVerified>((event, emit) async {
      emit(AuthLoading());
      await Future.delayed(const Duration(seconds: 2));
      try {
        final user = FirebaseAuth.instance.currentUser;
        await user?.reload();
        final refreshedUser = FirebaseAuth.instance.currentUser;
        if (refreshedUser != null && refreshedUser.emailVerified) {
          emit(AuthEmailVerified());
        } else {
          emit(AuthEmailNotVerified());
        }
      } on FirebaseAuthException catch (e) {
        String message;
        switch (e.code) {
          case 'user-not-found':
            message = 'Utilisateur non trouvé';
            break;
          case 'invalid-email':
            message = 'Email invalide';
            break;
          default:
            message = 'Pas de connexion internet,\nessayez plus tard';
        }
        emit(AuthFailure(message));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
