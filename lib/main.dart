import 'package:flutter/material.dart';
import 'package:overtime_managment/auth/controller/auth_controller.dart';
import 'package:overtime_managment/auth/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => AuthController(),)]
      ,child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,

        ),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen()
    ),);
  }
}

// ye code firebase firestore hai jo har user ka alg sy data store kar raha hai.
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();  // Firebase initialize karna
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Firebase',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: LoginScreen(),  // Yahan apki login screen
//     );
//   }
// }
//
// class SignupScreen extends StatefulWidget {
//   @override
//   _SignupScreenState createState() => _SignupScreenState();
// }
//
// class _SignupScreenState extends State<SignupScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _auth = FirebaseAuth.instance;
//
//   Future<void> _signup() async {
//     try {
//       await _auth.createUserWithEmailAndPassword(
//         email: _emailController.text,
//         password: _passwordController.text,
//       );
//       // Successfully signed up
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Signup Successful'),
//       ));
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => LoginScreen())); // Redirect to Login
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text(e.toString()),
//       ));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Signup')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _signup,
//               child: Text('Signup'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _auth = FirebaseAuth.instance;
//
//   Future<void> _login() async {
//     try {
//       await _auth.signInWithEmailAndPassword(
//         email: _emailController.text,
//         password: _passwordController.text,
//       );
//       // Successfully logged in
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Login Successful'),
//       ));
//       Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text(e.toString()),
//       ));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _login,
//               child: Text('Login'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => SignupScreen()), // Redirect to Signup
//                 );
//               },
//               child: Text('Create a new account'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final _nameController = TextEditingController();
//   final _ageController = TextEditingController();
//
//   // Firestore instance
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   // FirebaseAuth instance for getting user ID
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   Future<void> _saveData() async {
//     try {
//       // Get current user's UID
//       User? user = _auth.currentUser;
//       if (user != null) {
//         // Firebase Firestore mein data store karna with UID
//         await _firestore.collection('test_users').doc(user.uid).collection('user_data').add({
//           'name': _nameController.text,
//           'age': _ageController.text,
//           'createdAt': Timestamp.now(),  // Date time stamp
//         });
//
//         // Success message
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Data saved successfully!'),
//         ));
//
//         // Clear text fields after saving
//         _nameController.clear();
//         _ageController.clear();
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('User not logged in'),
//         ));
//       }
//     } catch (e) {
//       // Error message
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Error: $e'),
//       ));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Enter Data')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(
//                 labelText: 'Enter Your Name',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 20),
//             TextField(
//               controller: _ageController,
//               decoration: InputDecoration(
//                 labelText: 'Enter Your Age',
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.number,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _saveData,
//               child: Text('Okay'),
//             ),
//           ],
//         ),
//       ),
//       // Floating Action Button (FAB) for showing stored data
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Navigate to DataDisplayScreen
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => DataDisplayScreen()),
//           );
//         },
//         child: Icon(Icons.visibility),
//         tooltip: 'Show Data',
//       ),
//     );
//   }
// }
//
// ye admin@gmail.com k login karny sy sabh ka data show karwa rahay hai
// class DataDisplayScreen extends StatelessWidget {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   @override
//   Widget build(BuildContext context) {
//     print('Logged-in email: +++++++++++ ${_auth.currentUser?.email}');
//     return Scaffold(
//       appBar: AppBar(title: Text('Stored Data')),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: (_auth.currentUser?.email == 'admin@gmail.com')
//             ? _firestore.collectionGroup('user_data').snapshots()
//             : _firestore
//             .collection('test_users')
//             .doc(_auth.currentUser?.uid)
//             .collection('user_data')
//             .orderBy('createdAt', descending: true)
//             .snapshots(),
//         builder: (ctx, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text('No data available'));
//           }
//
//           // Filter valid docs
//           final docs = snapshot.data!.docs.where((doc) {
//             final data = doc.data() as Map<String, dynamic>?; // Safely cast to Map
//             return data != null && data.containsKey('name') && data.containsKey('age');
//           }).toList();
//
//           if (docs.isEmpty) {
//             return Center(child: Text('No valid data available'));
//           }
//
//           return ListView.builder(
//             itemCount: docs.length,
//             itemBuilder: (ctx, index) {
//               final data = docs[index].data() as Map<String, dynamic>;
//
//               final name = data['name'];
//               final age = data['age'];
//
//               return ListTile(
//                 title: Text(name),
//                 subtitle: Text('Age: $age'),
//               );
//             },
//           );
//         },
//       ),
//
//     );
//   }
// }

// ye har user ka alag data show karwa rahay hai

// class DataDisplayScreen extends StatelessWidget {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Stored Data')),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _firestore
//             .collection('users')
//             .doc(_auth.currentUser?.uid)  // User-specific collection
//             .collection('user_data')     // Nested collection
//             .orderBy('createdAt', descending: true)
//             .snapshots(),
//         builder: (ctx, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//
//           final docs = snapshot.data!.docs;
//
//           return ListView.builder(
//             itemCount: docs.length,
//             itemBuilder: (ctx, index) {
//               final data = docs[index];
//               return ListTile(
//                 title: Text(data['name']),
//                 subtitle: Text('Age: ${data['age']}'),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }




// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(); // Initialize Firebase
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: SignUpScreen(),
//     );
//   }
// }
//
// // SignUp Screen
// class SignUpScreen extends StatelessWidget {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Sign Up"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(labelText: "Email"),
//             ),
//             TextField(
//               controller: passwordController,
//               obscureText: true,
//               decoration: InputDecoration(labelText: "Password"),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   await FirebaseAuth.instance.createUserWithEmailAndPassword(
//                     email: emailController.text,
//                     password: passwordController.text,
//                   );
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => LoginScreen()),
//                   );
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text("Error: $e")),
//                   );
//                 }
//               },
//               child: Text("Sign Up"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // Login Screen
// class LoginScreen extends StatelessWidget {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Login"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(labelText: "Email"),
//             ),
//             TextField(
//               controller: passwordController,
//               obscureText: true,
//               decoration: InputDecoration(labelText: "Password"),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   await FirebaseAuth.instance.signInWithEmailAndPassword(
//                     email: emailController.text,
//                     password: passwordController.text,
//                   );
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => HomeScreen()),
//                   );
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text("Error: $e")),
//                   );
//                 }
//               },
//               child: Text("Login"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // Home Screen
// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Home Screen"),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () async {
//               await FirebaseAuth.instance.signOut();
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => LoginScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => EditScreen()),
//             );
//           },
//           child: Text("Edit Email & Password"),
//         ),
//       ),
//     );
//   }
// }
//
// class EditScreen extends StatefulWidget {
//   @override
//   _EditScreenState createState() => _EditScreenState();
// }
//
// class _EditScreenState extends State<EditScreen> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     fetchUserDetails();
//   }
//
//   void fetchUserDetails() {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       emailController.text = user.email ?? "";
//     }
//   }
//
//   Future<void> updateDetails() async {
//     User? user = FirebaseAuth.instance.currentUser;
//
//     try {
//       // Re-authenticate before making sensitive changes (Email & Password)
//       AuthCredential credential = EmailAuthProvider.credential(
//         email: user?.email ?? "",
//         password: passwordController.text, // Current password is required
//       );
//
//       await user?.reauthenticateWithCredential(credential);
//
//       // Update email with verification process
//       if (emailController.text.isNotEmpty && emailController.text != user?.email) {
//         await user?.verifyBeforeUpdateEmail(emailController.text);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Verification email sent. Please verify to update email.")),
//         );
//       }
//
//       // Update password if provided
//       if (passwordController.text.isNotEmpty && passwordController.text.length >= 6) {
//         await user?.updatePassword(passwordController.text);
//       }
//
//       // Reload user info
//       await user?.reload();
//
//       // Sign out user to force login with new credentials after email change
//       await FirebaseAuth.instance.signOut();
//
//       // Navigate back after logout
//       Navigator.pop(context);
//
//       // Show success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Details updated successfully! Please log in again.")),
//       );
//
//       // Navigate to login screen (you can navigate to your login screen here)
//       Navigator.pushReplacementNamed(context, '/login');
//
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e")),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Edit Details"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(labelText: "Email"),
//             ),
//             TextField(
//               controller: passwordController,
//               obscureText: true,
//               decoration: InputDecoration(labelText: "Password"),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: updateDetails,
//               child: Text("Update"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//


// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: SignInScreen(),
//     );
//   }
// }
//
// class SignInScreen extends StatelessWidget {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//
// Future<User?> signInWithGoogle() async {
//   try {
//     // Sign in with Google
//     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//     if (googleUser == null) return null; // User canceled the sign-in
//
//     // Get authentication details
//     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//
//     // Create credentials for Firebase
//     final credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );
//
//     // Sign in to Firebase with the Google credentials
//     final userCredential = await _auth.signInWithCredential(credential);
//     return userCredential.user;
//   } catch (e) {
//     print("Error: $e");
//     return null;
//   }
// }
//
//   Future<void> signOut() async {
//     await _googleSignIn.signOut();
//     await _auth.signOut();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Sign In with Google')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () async {
//                 User? user = await signInWithGoogle();
//                 if (user != null) {
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signed in as ${user.displayName}')));
//                 }
//               },
//               child: Text('Sign in with Google'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 await signOut();
//                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signed out')));
//               },
//               child: Text('Sign out'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:provider/provider.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => AuthService(),
//       child: MaterialApp(
//         home: Consumer<AuthService>(
//           builder: (context, auth, _) =>
//           auth.isAuthenticated ? HomeScreen() : LoginScreen(),
//         ),
//       ),
//     );
//   }
// }


// class AuthService extends ChangeNotifier {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   User? _user;

//   AuthService() {
//     _auth.authStateChanges().listen(_onAuthStateChanged);
//   }

//   User? get user => _user;
//   bool get isAuthenticated => _user != null;

//   Future<void> signUp(String email, String password) async {
//     try {
//       await _auth.createUserWithEmailAndPassword(email: email, password: password);
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> login(String email, String password) async {
//     try {
//       await _auth.signInWithEmailAndPassword(email: email, password: password);
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> logout() async {
//     await _auth.signOut();
//   }

//   void _onAuthStateChanged(User? user) {
//     _user = user;
//     notifyListeners();
//   }
// }

// class LoginScreen extends StatelessWidget {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')),
//             TextField(controller: _passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
//             ElevatedButton(
//               onPressed: () => context.read<AuthService>().login(
//                 _emailController.text.trim(),
//                 _passwordController.text.trim(),
//               ),
//               child: Text('Login'),
//             ),
//             ElevatedButton(
//               onPressed: () => context.read<AuthService>().signUp(
//                 _emailController.text.trim(),
//                 _passwordController.text.trim(),
//               ),
//               child: Text('Sign Up'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final user = context.watch<AuthService>().user;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () => context.read<AuthService>().logout(),
//           )
//         ],
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .doc(user?.uid)
//             .collection('contacts')
//             .snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) return CircularProgressIndicator();
//           var contacts = snapshot.data!.docs;
//           return ListView.builder(
//             itemCount: contacts.length,
//             itemBuilder: (context, index) {
//               var contact = contacts[index];
//               return ListTile(
//                 title: Text(contact['email']),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ChatScreen(chatId: contact.id),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => RequestScreen()),
//           );
//         },
//         child: Icon(Icons.person_add),
//       ),
//     );
//   }
// }

// class RequestScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//     final user = context.watch<AuthService>().user;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Requests'),
//       ),
//       body: StreamBuilder(
//         stream: _firestore.collection('chat_requests').snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) return CircularProgressIndicator();
//           var requests = snapshot.data!.docs;
//           return ListView.builder(
//             itemCount: requests.length,
//             itemBuilder: (context, index) {
//               var request = requests[index];
//               return ListTile(
//                 title: Text(request['email']),
//                 trailing: ElevatedButton(
//                   onPressed: () {
//                     var chatId = _firestore.collection('chat_rooms').doc().id;
//                     _firestore.collection('users').doc(user?.uid).collection('contacts').add({
//                       'email': request['email'],
//                       'uid': request['uid'],
//                       'chatId': chatId,
//                     });
//                     _firestore.collection('users').doc(request['uid']).collection('contacts').add({
//                       'email': user?.email,
//                       'uid': user?.uid,
//                       'chatId': chatId,
//                     });
//                     _firestore.collection('chat_requests').doc(request.id).delete();
//                   },
//                   child: Text('Accept'),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class ChatScreen extends StatelessWidget {
//   final String chatId;

//   ChatScreen({required this.chatId});

//   @override
//   Widget build(BuildContext context) {
//     final TextEditingController _controller = TextEditingController();
//     final user = context.watch<AuthService>().user;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder(
//               stream: FirebaseFirestore.instance
//                   .collection('chat_rooms')
//                   .doc(chatId)
//                   .collection('messages')
//                   .orderBy('timestamp', descending: true)
//                   .snapshots(),
//               builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (!snapshot.hasData) return CircularProgressIndicator();
//                 var messages = snapshot.data!.docs;
//                 return ListView.builder(
//                   reverse: true,
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     var message = messages[index];
//                     return ListTile(
//                       title: Text(message['text']),
//                       subtitle: Text(message['sender']),
//                       trailing: message['sender'] == user?.email
//                           ? Icon(Icons.check)
//                           : null,
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: InputDecoration(labelText: 'Type a message...'),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: () {
//                     FirebaseFirestore.instance
//                         .collection('chat_rooms')
//                         .doc(chatId)
//                         .collection('messages')
//                         .add({
//                       'text': _controller.text,
//                       'sender': user?.email,
//                       'timestamp': FieldValue.serverTimestamp(),
//                     });
//                     _controller.clear();
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Chat App',
//       theme: ThemeData.light(),
//       home: SignUpScreen(),
//     );
//   }
// }
//
// class SignUpScreen extends StatelessWidget {
//   final TextEditingController nameController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Sign Up')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: InputDecoration(labelText: 'Enter your name'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 final userName = nameController.text;
//                 // Save user to Firebase
//                 FirebaseFirestore.instance.collection('users').doc(userName).set({
//                   'name': userName,
//                 });
//
//                 // After sign up, navigate to home screen
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => HomeScreen(userName: userName)),
//                 );
//               },
//               child: Text('Sign Up'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class HomeScreen extends StatelessWidget {
//   final String userName;
//
//   HomeScreen({required this.userName});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Home')),
//       body: Column(
//         children: [
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => RequestScreen(userName: userName),
//                 ),
//               );
//             },
//             child: Text('Send Friend Request'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => RequestListScreen(userName: userName),
//                 ),
//               );
//             },
//             child: Text('View Friend Requests'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               await FirebaseAuth.instance.signOut();
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => SignUpScreen()),
//               );
//             },
//             child: Text('Logout'),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class RequestScreen extends StatefulWidget {
//   final String userName;
//
//   RequestScreen({required this.userName});
//
//   @override
//   _RequestScreenState createState() => _RequestScreenState();
// }
//
// class _RequestScreenState extends State<RequestScreen> {
//   final TextEditingController friendController = TextEditingController();
//
//   void sendRequest() async {
//     final friendName = friendController.text;
//
//     // Send a request to Firestore
//     FirebaseFirestore.instance.collection('requests').add({
//       'sender': widget.userName,
//       'receiver': friendName,
//       'status': 'pending', // Initially set to 'pending'
//     });
//
//     Navigator.pop(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Send Request')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: friendController,
//               decoration: InputDecoration(labelText: 'Enter Friend\'s Name'),
//             ),
//             ElevatedButton(
//               onPressed: sendRequest,
//               child: Text('Send Request'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class RequestListScreen extends StatelessWidget {
//   final String userName;
//
//   RequestListScreen({required this.userName});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Friend Requests')),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('requests')
//             .where('receiver', isEqualTo: userName)
//             .where('status', isEqualTo: 'pending')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) return CircularProgressIndicator();
//
//           final requests = snapshot.data!.docs;
//
//           return ListView.builder(
//             itemCount: requests.length,
//             itemBuilder: (context, index) {
//               final request = requests[index];
//               final sender = request['sender'];
//
//               return ListTile(
//                 title: Text(sender),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.check),
//                       onPressed: () async {
//                         // Accept request and create a chat room
//                         await FirebaseFirestore.instance
//                             .collection('requests')
//                             .doc(request.id)
//                             .update({'status': 'accepted'});
//
//                         // Create chat room
//                         await FirebaseFirestore.instance
//                             .collection('chats')
//                             .doc('${userName}_$sender')
//                             .set({'participants': [userName, sender]});
//
//                         // Navigate to chat screen
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => ChatScreen(chatRoomId: '${userName}_$sender'),
//                           ),
//                         );
//                       },
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.close),
//                       onPressed: () {
//                         // Reject request
//                         FirebaseFirestore.instance
//                             .collection('requests')
//                             .doc(request.id)
//                             .update({'status': 'rejected'});
//                       },
 //                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//
// class ChatScreen extends StatefulWidget {
//   final String chatRoomId; // Unique Chat Room ID for one-to-one messaging
//
//   const ChatScreen({Key? key, required this.chatRoomId}) : super(key: key);
//
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   List<types.Message> _messages = [];
//   final _user = types.User(id: 'user1'); // Current logged-in user
//   final _firestore = FirebaseFirestore.instance;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadMessages();
//   }
//
//   /// Load messages in real-time from Firestore
//   void _loadMessages() {
//     _firestore
//         .collection('chats')
//         .doc(widget.chatRoomId)
//         .collection('messages')
//         .orderBy('createdAt', descending: true)
//         .snapshots()
//         .listen((snapshot) {
//       final messages = snapshot.docs.map((doc) {
//         final data = doc.data();
//         return types.TextMessage(
//           id: doc.id,
//           author: types.User(id: data['authorId']),
//           createdAt: data['createdAt'],
//           text: data['text'],
//         );
//       }).toList();
//
//       setState(() {
//         _messages = messages;
//       });
//     });
//   }
//
//   /// Handle message send
//   void _handleSendPressed(types.PartialText message) async {
//     final newMessage = {
//       'text': message.text, // Text content
//       'authorId': _user.id, // Sender ID
//       'createdAt': DateTime.now().millisecondsSinceEpoch, // Timestamp
//     };
//
//     await _firestore
//         .collection('chats')
//         .doc(widget.chatRoomId)
//         .collection('messages')
//         .add(newMessage);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Chat')),
//       body: Chat(
//         messages: _messages,
//         onSendPressed: _handleSendPressed,
//         user: _user,
//         showUserAvatars: true, // Show avatars for users
//         showUserNames: true, // Display user names
//       ),
//     );
//   }
// }

