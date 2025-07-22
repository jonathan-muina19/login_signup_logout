import 'package:firebase_auth/firebase_auth.dart';
import '../domain/auth_repository.dart';

/// implemets : Implémenter cette interface qu'on a définie.
/// Implémentation de l'interface AuthRepository.
class AuthRepositoryImpl implements AuthRepository {
  /// The Firebase Authentication instance.
  final FirebaseAuth _auth;

  /// Constructeur de la classe AuthRepositoryImpl.
  AuthRepositoryImpl(this._auth);

  @override
  /// inscription d'un utilisateur
  Future<void> signUp(String email, String password) async {
    /// Appel de la méthode createUserWithEmailAndPassword
    /// de Firebase Authentication.
    /// Cette méthode permet d'enregistrer un nouvel utilisateur
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  /// Connexion d'un utilisateur
  Future<void> signIn(String email, String password) async {
    /// Appel de la méthode signInWithEmailAndPassword
    /// de Firebase Authentication.
    /// Cette méthode permet de connecter un utilisateur existant.
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  /// Déconnexion d'un utilisateur
  Future<void> signOut() async {
    /// Appel de la méthode signOut de Firebase Authentication.
    /// Cette méthode permet de se déconnecter de l'application.
    await _auth.signOut();
  }

  /// Lors de l'inscription on envoie un email de
  /// confirmation a l'utilisateur
  @override
  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  @override
  /// Vérifie si l'utilisateur est connecté
  Stream<bool> get isSignedIn =>
      _auth.authStateChanges().map((user) => user != null);
}
