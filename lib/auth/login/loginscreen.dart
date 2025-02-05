import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:overtime_managment/Auth/forgotscreen.dart';
import 'package:overtime_managment/auth/controller/auth_controller.dart';
import 'package:overtime_managment/auth/forget/forgotscreen.dart';
import 'package:overtime_managment/auth/sign_up/register.dart';

import 'package:overtime_managment/homepagescreen.dart';
import 'package:overtime_managment/utilis/utilis.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<Offset> _textFieldSlideAnimation;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _textFieldSlideAnimation =
        Tween<Offset>(begin: const Offset(0, -1), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _buttonScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }
  Future<void> _saveUserData(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
    prefs.setString('password', password);
  }
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  final _firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AuthController>(context);
    return Scaffold(
      backgroundColor: const Color(0xFF0A65FC),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 80,
                ),
                const Text(
                  ' Sign in ',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 0,
                ),
                ScaleTransition(
                  scale: _logoScaleAnimation,
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
                const SizedBox(height: 10),
                SlideTransition(
                  position: _textFieldSlideAnimation,
                  child: CustomTextField(
                    controller: emailController,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                SlideTransition(
                  position: _textFieldSlideAnimation,
                  child: CustomTextField(
                    controller: passwordController,
                    label: 'Password',
                    suffixIcon: controller.isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    onPress: (){
                      controller.togglePasswordVisibility();
                    },
                    isPassword: controller.isPasswordVisible,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                ScaleTransition(
                  scale: _buttonScaleAnimation,
                  child: SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          final result = await controller.login(emailController.text, passwordController.text);
                          setState(() {
                            isLoading = false;
                          });
                          if (result == 'Login Successful') {
                            _saveUserData(emailController.text, passwordController.text);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePageScreen(),
                              ),
                            );
                            Utilis.toastSuccessMessage(result.toString());
                            emailController.clear();
                            passwordController.clear();
                          } else {
                            Utilis.toastErrorMessage(result.toString()); // Display the error message.
                          }
                        }
                      },

                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Color(0xFF0A65FC),
                                strokeWidth: 2.0,
                              ),
                            )
                          : const Text(
                              'Login',
                              style: TextStyle(color: Colors.black),
                            ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegistrationScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Forgetscreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final bool isPassword;
  final IconData? suffixIcon;
  final String? Function(String?) validator;
  final VoidCallback? onPress;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    required this.validator,
    this.onPress,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword,
      decoration: InputDecoration(
        suffixIcon: IconButton(onPressed: onPress, icon: Icon(suffixIcon)),
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF300F1C),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
        ),
      ),
      validator: validator,
    );
  }
}
