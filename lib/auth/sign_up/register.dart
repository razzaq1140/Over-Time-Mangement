import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overtime_managment/auth/controller/auth_controller.dart';
import 'package:overtime_managment/auth/login/loginscreen.dart';
import 'package:overtime_managment/services/firestore_service.dart';
import 'package:overtime_managment/utilis/utilis.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  // final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  File? _selectedImage; // To hold the selected image
  final ImagePicker _imagePicker = ImagePicker();
  Future<void> _openCamera() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _openGallery() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }


  @override
  void dispose() {
    _firstNameController.dispose();
    // _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool isLoading = false;

  final FireStoreServices _fireStoreServices = FireStoreServices();
  Future<void> _submitSignUpData() async{
    if(_formKey.currentState?.validate() ?? false){
      _formKey.currentState?.save();
      try{
        await _fireStoreServices.saveSignUpData(
            _firstNameController.text,
            _emailController.text
        );
        setState(() {
          _firstNameController.clear();
          _emailController.clear();
        });
        _formKey.currentState?.reset();
      }catch(e){
        Utilis.toastErrorMessage(e.toString());
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final signUpController = Provider.of<AuthController>(context);
    return Scaffold(
      backgroundColor: const Color(0xFF0A65FC),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // const Text(
                //   '"Complete your detail to see your day ahead and clockin and out shifts "',
                //   style: TextStyle(
                //     fontSize: 20,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.white,
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                SizedBox(
                  height: 170,
                  width: 170,
                  child: Image.asset('assets/images/logo.png'),
                ),
                // SizedBox(
                //   height: 200,
                //   width: 200,
                //   child: Image.asset('assets/images/logo.png'),
                // ),
                GestureDetector(
                  onTap: (){
                      _showImageSourceBottomSheet();
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 65,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!) // Display the selected image
                        : null,
                    child: _selectedImage == null
                        ? Icon(
                      Icons.camera_alt,
                      color: Colors.black.withOpacity(0.5),
                      size: 35,
                    )
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField('Name', Icons.person, _firstNameController,
                    (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                }),
                const SizedBox(height: 10),
                _buildTextField(
                  'Email',
                  Icons.email,
                  _emailController,
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                        .hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                _buildTextField('Phone Number', Icons.phone, _phoneController,
                    (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number is required';
                  } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                    return 'Enter a valid 10-digit phone number';
                  }
                  return null;
                }),
                const SizedBox(height: 10),
                _buildTextField('Password', Icons.lock, _passwordController,
                    (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                }, obscureText: true),
                const SizedBox(height: 10),
                _buildTextField('Confirm Password', Icons.lock_outline,
                    _confirmPasswordController, (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm your password';
                  } else if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                }, obscureText: true),
                const SizedBox(height: 20),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });

                      Future.delayed(const Duration(milliseconds: 1000),
                          () async {
                        setState(() {
                          isLoading = false;
                        });
                        signUpController.signUp(
                          _emailController.text.toString(),
                          _passwordController.text.toString(),
                        ).then((value){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                          _submitSignUpData();
                          Utilis.toastSuccessMessage('SignUp Successful');
                        }).onError((error, stackTrace){
                          Utilis.toastErrorMessage(error.toString());
                        });
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(content: Text(message ?? 'Error')),
                        // );
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Color(0xFF0A65FC),
                      strokeWidth: 2.0,
                    ),
                  )
                      : const Text('SignUp',
                      style: TextStyle(color: Colors.black)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.black54),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Text(
                        'SIGN IN',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon,
      TextEditingController controller, FormFieldValidator<String>? validator,
      {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 1.5,
          ),
        ),
        fillColor: Colors.white,
        filled: true,
      ),
      validator: validator,
    );
  }

  void _showImageSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Choose Image Source',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Open Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _openCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Open Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _openGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

}
