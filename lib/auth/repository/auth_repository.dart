import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository{
  final FirebaseAuth _firebaseAuth;
  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<User?> signInWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return userCredential.user;
    }catch(e){
      throw e.toString();
    }
  }

  Future<User?> signUpWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      return userCredential.user;
    }catch(e){
      throw e.toString();
    }
  }

  Future<void> logout()async{
    await _firebaseAuth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw e.toString();
    }
  }
}