import 'package:flutter/material.dart';
import 'package:overtime_managment/auth/repository/auth_repository.dart';

class AuthController with ChangeNotifier {
  final AuthRepository _authRepository;
  bool _isLoading = false;

  AuthController({AuthRepository? loginRepository})
      : _authRepository = loginRepository ?? AuthRepository();

  bool get isLoading => _isLoading;

  bool _isPasswordVisible  = true;
  bool get isPasswordVisible  => _isPasswordVisible ;

  togglePasswordVisibility(){
    _isPasswordVisible =! _isPasswordVisible;
    notifyListeners();
  }

  Future<String?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await _authRepository.signInWithEmailAndPassword(email, password);
      _isLoading = false;
      notifyListeners();
      if (user != null) {
        return 'Login Successful';
      } else {
        return 'Login Failed';
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }



  Future<String?> signUp(String email, String password) async{
    _isLoading = true;
    notifyListeners();
    try {
      final user = await _authRepository.signUpWithEmailAndPassword(email, password);
      _isLoading = false;
      notifyListeners();
      return user != null ? 'SignUp Successful' : 'SignUp Failed';

    }catch(e){
      _isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  Future<String> sendPasswordResetEmail(String email) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _authRepository.sendPasswordResetEmail(email);

      _isLoading = false;
      notifyListeners();
      return 'Password reset email sent successfully';
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }


}
