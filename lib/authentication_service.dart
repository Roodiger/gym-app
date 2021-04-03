import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationService {

  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return "Signed in";
    } on FirebaseAuthException catch(e) {
      return e.message;
    }
  }


  Future<String> signUp({String email, String password, String firstName, String lastName}) async {
    try {
        await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
        this.addUserToUsersTable(firstName, lastName, email);
        return "Signed up";
    } on FirebaseAuthException catch(e) {
      return e.message;
    }
  }

  Future<DocumentReference> addUserToUsersTable(String firstName, String lastName, String email) {
    if (_firebaseAuth.currentUser == null) {
      throw Exception('Must be logged in');
    }

    return FirebaseFirestore.instance.collection('users').add({
      'user_id': FirebaseAuth.instance.currentUser.uid,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'created_at': DateTime.now(),
    });
  }

  getEmail() {
      var email =_firebaseAuth.currentUser.email;
      return email;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}