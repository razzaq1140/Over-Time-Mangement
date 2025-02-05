import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overtime_managment/utilis/utilis.dart';

class EditLeaveRequestscreen extends StatefulWidget {
  String username, leaveType, startDate, endDate, reason, id;
  EditLeaveRequestscreen({
    super.key,
    required this.username,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.id,
  });

  @override
  State<EditLeaveRequestscreen> createState() => _EditLeaveRequestscreenState();
}

class _EditLeaveRequestscreenState extends State<EditLeaveRequestscreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  late TextEditingController usernameController;
  late TextEditingController startDateController;
  late TextEditingController endDateController;
  late TextEditingController reasonController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();

    usernameController = TextEditingController(text: widget.username);
    startDateController = TextEditingController(text: widget.startDate);
    endDateController = TextEditingController(text: widget.endDate);
    reasonController = TextEditingController(text: widget.reason);
  }

  @override
  void dispose() {
    usernameController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    reasonController.dispose();
    super.dispose();
  }

  Future<void> updateLeaveRequest(String docId, BuildContext context) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firebaseFirestore
            .collection('createLeaveRequest') // Main collection
            .doc(user.uid) // Specific user's document ID
            .collection("leave_data") // Nested collection
            .doc(docId) // Document ID to be updated
            .update({
          'userName': usernameController.text,
          'leaveType': widget.leaveType,
          'startDate': startDateController.text,
          'endDate': endDateController.text,
          'reason': reasonController.text,
          // 'status': wid, // Update status or other fields
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Leave request updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not logged in')),
        );
      }
    } catch (e) {
      throw Exception('Error updating leave request: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF0A65FC),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Text(
              'Leave Request',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.07,
              ),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: usernameController,
                            decoration: const InputDecoration(
                              labelText: 'User name',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter username';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            value: widget.leaveType,
                            dropdownColor: Colors.white,
                            decoration: const InputDecoration(
                              labelText: 'Leave Type',
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Annual Leave',
                                child: Text('Annual Leave', style: TextStyle(color: Colors.black)),
                              ),
                              DropdownMenuItem(
                                value: 'Sick Leave',
                                child: Text('Sick Leave', style: TextStyle(color: Colors.black)),
                              ),
                              DropdownMenuItem(
                                value: 'Other',
                                child: Text('Other', style: TextStyle(color: Colors.black)),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                widget.leaveType = value ?? '';
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a leave type';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: startDateController,
                            decoration: const InputDecoration(
                              labelText: 'Start Date',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a start date';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: endDateController,
                            decoration: const InputDecoration(
                              labelText: 'End Date',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter an end date';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: reasonController,
                            decoration: const InputDecoration(
                              labelText: 'Reason',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a reason';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0A65FC),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                updateLeaveRequest(widget.id, // Pass the document ID
                                  context,).then((value){
                                    Navigator.pop(context);
                                  setState(() {
                                    isLoading = false;
                                  });
                                });
                              }
                            },
                            child: isLoading
                                ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.0,
                              ),
                            )
                                : const Text(
                              'Update Leave Request',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
