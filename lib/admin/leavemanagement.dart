import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ManageLeaveRequestsScreen extends StatefulWidget {
  ManageLeaveRequestsScreen({super.key});

  @override
  State<ManageLeaveRequestsScreen> createState() =>
      _ManageLeaveRequestsScreenState();
}

class _ManageLeaveRequestsScreenState extends State<ManageLeaveRequestsScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF0A65FC),
        ),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.1),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color(0xFF0A65FC),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Text(
                'Manage Leave Requests',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: (_auth.currentUser?.email == 'admin@gmail.com')
                        ? _firebaseFirestore
                            .collectionGroup('leave_data')
                            .snapshots()
                        : _firebaseFirestore
                            .collection('createLeaveRequest')
                            .doc(_auth.currentUser?.uid)
                            .collection('leave_data')
                            .orderBy('createdAt', descending: true)
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No leave requests found.'));
                      }
                      final leaveRequests = snapshot.data!.docs.where((doc) {
                        final data = doc.data()
                            as Map<String, dynamic>?; // Safely cast to Map
                        return data != null &&
                            data.containsKey('startDate') &&
                            data.containsKey('endDate');
                      }).toList();

                      if (leaveRequests.isEmpty) {
                        return Center(child: Text('No valid data available'));
                      }
                      // final leaveRequests = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: leaveRequests.length,
                        itemBuilder: (context, index) {
                          final request = leaveRequests[index];
                          final docId = request.id;
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            decoration: BoxDecoration(
                              color: Color(0xFF0A65FC),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(
                                  '${request['userName']}\nLeave Type: ' +
                                      request['leaveType'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                'Start Date: ${request['startDate']} \nEnd Date: ${request['endDate']} \nReason: ${request['reason']}',
                                style: TextStyle(color: Colors.white),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Accept Button (Green)
                                  IconButton(
                                    icon: Icon(Icons.check, color: Colors.green),
                                    onPressed: () async {
                                      try {
                                        // Ensure you're referencing the correct path
                                        var docRef = _firebaseFirestore
                                            .collection('createLeaveRequest')
                                            .doc(_auth.currentUser?.uid)
                                            .collection('leave_data')
                                            .doc(docId); // Use docId from the leave request

                                        // Get the document snapshot
                                        var docSnapshot = await docRef.get();

                                        // Check if the document exists
                                        if (!docSnapshot.exists) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Document not found')),
                                          );
                                          return;
                                        }

                                        // If document exists, update the status
                                        await docRef.update({
                                          'status': 'Accepted', // or 'Rejected'
                                        });

                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Leave request accepted')),
                                        );
                                      } catch (e) {
                                        print('Error: $e');
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Failed to update request: $e')),
                                        );
                                      }
                                    },
                                  ),
                                  // Reject Button (Red)
                                  IconButton(
                                    icon: Icon(Icons.close, color: Colors.red),
                                    onPressed: () async {
                                      try {
                                        await _firebaseFirestore
                                            .collection('leaveRequest')
                                            .doc(docId)
                                            .update({
                                          'status': 'Rejected',
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content:
                                                Text('Leave request rejected!'),
                                          ),
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Failed to reject request: $e'),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
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
