import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overtime_managment/utilis/utilis.dart';

class ManageOvertimeRequestScreen extends StatefulWidget {
  const ManageOvertimeRequestScreen({super.key});

  @override
  _ManageOvertimeRequestScreenState createState() =>
      _ManageOvertimeRequestScreenState();
}

class _ManageOvertimeRequestScreenState
    extends State<ManageOvertimeRequestScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Update status function
  void _updateStatus(String documentId, String newStatus) {
    _firebaseFirestore
        .collection('createOverTimeRequest')
        .doc(documentId)
        .update({'status': newStatus}).then((_) {
      Utilis.toastSuccessMessage('Status updated successfully!');
    }).catchError((error) {
      Utilis.toastErrorMessage('Failed to update status: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: const Color(0xFF0A65FC),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Manage Overtime Requests',
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: (_auth.currentUser?.email == 'admin@gmail.com')
                        ? _firebaseFirestore
                        .collectionGroup('overTime_data')
                        .snapshots()
                        : _firebaseFirestore
                        .collection('createOverTimeRequest')
                        .doc(_auth.currentUser?.uid)
                        .collection('overTime_data')
                        .orderBy('createdAt', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No leave requests found.'));
                      }
                      final overTimeRequests = snapshot.data!.docs.where((doc) {
                        final data = doc.data()
                        as Map<String, dynamic>?; // Safely cast to Map
                        return data != null &&
                            data.containsKey('startDate') &&
                            data.containsKey('endDate');
                      }).toList();

                      if (overTimeRequests.isEmpty) {
                        return Center(child: Text('No valid data available'));
                      }

                      // final overTimeRequests = snapshot.data?.docs ?? [];
                      if (overTimeRequests.isEmpty) {
                        return const Center(
                          child: Text('No overtime requests found.'),
                        );
                      }

                      return ListView.builder(
                        itemCount: overTimeRequests.length,
                        itemBuilder: (context, index) {
                          final requestData = overTimeRequests[index];
                          final docId = requestData.id;
                          final data = requestData.data() as Map<String, dynamic>;
                          DateTime _getDate(dynamic date) {
                            if (date is Timestamp) {
                              return date.toDate();
                            } else if (date is String) {
                              return DateFormat('yyyy-MM-dd').parse(date);
                            }
                            return DateTime.now();
                          }
                          final overtimeRequest = OvertimeRequestModel(
                            id: requestData.id,
                            employeeName: data['userName'] ?? '',
                            overtimeType: data['OverTimeType'] ?? '',
                            startDate: _getDate(data['startDate']),
                            endDate: _getDate(data['endDate']),
                            hours: int.tryParse(data['hours'].toString()) ?? 0,
                            status: data['status'] ?? 'Pending',
                          );

                          return OvertimeRequestCard(
                            overtimeRequest: overtimeRequest,
                            onApprove: () => _updateStatus(docId, 'Approved'),
                            onReject: () => _updateStatus(docId, 'Rejected'),
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

class OvertimeRequestModel {
  final String id;
  final String employeeName;
  final String overtimeType;
  final DateTime startDate;
  final DateTime endDate;
  final int hours;
  final String status;

  OvertimeRequestModel({
    required this.id,
    required this.employeeName,
    required this.overtimeType,
    required this.startDate,
    required this.endDate,
    required this.hours,
    required this.status,
  });
}

class OvertimeRequestCard extends StatelessWidget {
  final OvertimeRequestModel overtimeRequest;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  OvertimeRequestCard({
    super.key,
    required this.overtimeRequest,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0A65FC),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Employee Name: ${overtimeRequest.employeeName}',
              style: TextStyle(
                fontSize: screenWidth * 0.047,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Overtime Type: ${overtimeRequest.overtimeType}',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start Date: ${DateFormat('dd MMM yyyy').format(overtimeRequest.startDate)}',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'End Date: ${DateFormat('dd MMM yyyy').format(overtimeRequest.endDate)}',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Hours: ${overtimeRequest.hours}',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Status: ${overtimeRequest.status}',
              style: const TextStyle(
                fontSize: 15,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: onApprove,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    'Approve',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onReject,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text(
                    'Reject',
                    style: TextStyle(
                      fontSize: 15,
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
    );
  }
}
