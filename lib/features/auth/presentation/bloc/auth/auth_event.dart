import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  /// retourne une liste vide
  /// car cette classe n'a pas de propriété spécifique.
  List<Object?> get props => [];
}

/// Evenement de type inscription
/// contient l'email et le mot de passe
/// de l'utilisateur
class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  SignInRequested(this.email, this.password);

  @override
  /// retourne une liste contenant l'email et le mot de passe
  /// de l'utilisateur
  /// Sa va servir à savoir si l'utilisateur est déjà inscrit
  List<Object?> get props => [email, password];
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  SignUpRequested(this.email, this.password);

  @override
  /// retourne une liste contenant l'email et le mot de passe
  /// de l'utilisateur
  /// Sa va servir à savoir si l'utilisateur est déjà inscrit
  List<Object?> get props => [email, password];
}

/// Evenement de type déconnexion
class SignOutRequested extends AuthEvent {}

/// Evenement de type vérification de l'état d'authentification
class CheckAuthStatus extends AuthEvent {}

class ResetAuthEvent extends AuthEvent{}
