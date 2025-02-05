import 'package:flutter/material.dart';
import 'package:overtime_managment/auth/controller/auth_controller.dart';
import 'package:overtime_managment/utilis/utilis.dart';
import 'package:provider/provider.dart';

class Forgetscreen extends StatefulWidget {
  const Forgetscreen({super.key});

  @override
  State<Forgetscreen> createState() => _ForgetscreenState();
}

class _ForgetscreenState extends State<Forgetscreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A65FC),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.asset('assets/images/logo.png'),
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Email',
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
                        color: Color(0xFF5053D5),
                        width: 2.0,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Consumer<AuthController>(
                  builder: (context, controller, child) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async{
                      if (_formKey.currentState!.validate()){
                        String email = _emailController.text;
                        String response = await controller.sendPasswordResetEmail(email);

                        if (response == 'Password reset email sent successfully') {
                          Navigator.pop(context);
                          _emailController.clear();
                          Utilis.toastSuccessMessage('Please check the Email');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(response)),
                          );
                        }
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const OTPVerificationScreen(),
                        //   ),
                        // );
                      }
                    },
                    child: controller.isLoading
                        ? const CircularProgressIndicator(
                      color: Color(0xFF0A65FC),
                      strokeWidth: 2.0,
                    )
                        :  const Text(
                      'Send OTP',
                      style: TextStyle(color: Color(0xFF0A65FC)),
                    ),
                  );
                },)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
