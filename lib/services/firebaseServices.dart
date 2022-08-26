import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  User? user;
  AuthenticationService(this._firebaseAuth);
  Future<void> siginout() async {
    await _firebaseAuth.signOut();
  }

  User? getuser() {
    return _firebaseAuth.currentUser;
  }

  String? getemail() {
    return _firebaseAuth.currentUser!.email;
  }

  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();
  Future<String?> signIn({String? email, String? password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email!, password: password!);
      return "Signed In";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  /* user = auth.CurrentUser; */
  Future<String?> signUp({String? email, String? password}) async {
    final authresult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email!, password: password!);
    try {
      await authresult.user!.sendEmailVerification();
      return 'verified email';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
