// but : Definir ce qu'on veut faire, pas comment.
/// Interface for the authentication repository.
abstract class AuthRepository {
  Future<void> signUp(String email, String password);
  Future<void> signIn(String email, String password);
  Future<void> signOut();

  /// Returns the current user's email.
  Stream<bool> get isSignedIn;
}
