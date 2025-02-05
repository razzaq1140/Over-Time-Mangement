import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  _ManageUsersScreenState createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('signUp').get();
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id, // Document ID
          'userId': doc['userId'], // Firebase Auth ID
          'name': doc['name'],
          'email': doc['email'],
          'role': 'User', // Default role (if applicable)
        };
      }).toList();
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  void editUser(Map<String, dynamic> user) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUserScreen(user: user),
      ),
    );
    setState(() {}); // Refresh data
  }

  void deleteUser(Map<String, dynamic> user) async {
    try {
      // Delete user data from Firestore
      await FirebaseFirestore.instance.collection('signUp').doc(user['id']).delete();

      // Delete user authentication
      FirebaseAuth auth = FirebaseAuth.instance;
      User? firebaseUser = await _getUserByEmail(user['email']);
      if (firebaseUser != null) {
        await firebaseUser.delete();
      }

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted successfully')),
      );

      // Refresh the list
      setState(() {});
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting user: $e')),
      );
    }
  }

// Helper function to get a user by email
  Future<User?> _getUserByEmail(String email) async {
    try {
      List<User> users = (await FirebaseAuth.instance.fetchSignInMethodsForEmail(email)).map((method) {
        return FirebaseAuth.instance.currentUser!;
      }).toList();
      return users.isNotEmpty ? users.first : null;
    } catch (e) {
      print("Error fetching user by email: $e");
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFF0A65FC)),
        child: Column(
          children: [
            const SizedBox(height: 100),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                'Manage Users',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: Color(0xFF0A65FC)),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No users found.'),
                      );
                    } else {
                      final users = snapshot.data!;
                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0A65FC),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: Text(
                                user['name']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                user['email']!,
                                style: const TextStyle(color: Colors.white),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF0A65FC),
                                    ),
                                    onPressed: () => editUser(user),
                                    child: const Text(
                                      'Edit',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  // const SizedBox(width: 8),
                                  // ElevatedButton(
                                  //   style: ElevatedButton.styleFrom(
                                  //     backgroundColor: Colors.red,
                                  //   ),
                                  //   onPressed: () => deleteUser(user),
                                  //   child: const Text(
                                  //     'Delete',
                                  //     style: TextStyle(
                                  //       color: Colors.white,
                                  //       fontWeight: FontWeight.bold,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class EditUserScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const EditUserScreen({required this.user, Key? key}) : super(key: key);

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late String role;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user['name']);
    emailController = TextEditingController(text: widget.user['email']);
    role = widget.user['role'] ?? 'User';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFF0A65FC)),
        child: Column(
          children: [
            const SizedBox(height: 100),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Color(0xFF0A65FC),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: const Text(
                'Edit User',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      DropdownButton<String>(
                        value: role,
                        onChanged: (newValue) {
                          setState(() {
                            role = newValue!;
                          });
                        },
                        items: ['Admin', 'Manager', 'Employee', 'User'] // Include 'User' if it's valid
                            .map((role) => DropdownMenuItem(
                          value: role,
                          child: Text(role),
                        ))
                            .toList(),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A65FC),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () async {
                          try {
                            await FirebaseFirestore.instance
                                .collection('signUp')
                                .doc(widget.user['id']) // Assuming 'id' is the document ID
                                .update({
                              'name': nameController.text,
                              'email': emailController.text,
                              'role': role,
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('User updated successfully')),
                            );
                            Navigator.pop(context, true);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error updating user: $e')),
                            );
                          }
                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

