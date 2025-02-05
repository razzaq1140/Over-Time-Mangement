import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overtime_managment/leave_request/screens/edit_leave_requestscreen.dart';
import 'package:overtime_managment/services/firestore_service.dart';
import 'package:overtime_managment/utilis/utilis.dart';

class LeaveRequestsScreen extends StatefulWidget {
  const LeaveRequestsScreen({super.key});

  @override
  _LeaveRequestsScreenState createState() => _LeaveRequestsScreenState();
}

class _LeaveRequestsScreenState extends State<LeaveRequestsScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _username = '',  _leaveType = '', _startDate = '', _endDate = '', _reason = '';
  bool isLoading = false;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FireStoreServices _fireStoreServices = FireStoreServices();
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> _submitLeaveRequest() async{
    if(_formKey.currentState?.validate() ?? false){
      _formKey.currentState!.save();
      try{
        await _fireStoreServices.saveLeaveRequest(
          _username,
            _leaveType,
            _startDate,
            _endDate,
            _reason,
          context
        );
        Utilis.toastSuccessMessage('Leave Request Submitted Successfully');
        setState(() {
          _username = '';
          _leaveType = '';
          _startDate = '';
          _endDate = '';
          _reason = '';
        });
        _formKey.currentState!.reset();
      }catch(e){
        Utilis.toastErrorMessage(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // `SingleChildScrollView` puri body ko wrap kar raha hai
        child: Container(
          color: const Color(0xFF0A65FC),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Text(
                'Leave Request',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.07),
              ),
              const SizedBox(height: 50),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
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
                          onSaved: (value) => _username = value ?? '',
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          dropdownColor: Colors.white,
                          decoration: const InputDecoration(
                            labelText: 'Leave Type',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            const DropdownMenuItem(
                              value: 'Annual Leave',
                              child: Text('Annual Leave', style: TextStyle(color: Colors.black)),
                            ),
                            const DropdownMenuItem(
                              value: 'Sick Leave',
                              child: Text('Sick Leave', style: TextStyle(color: Colors.black)),
                            ),
                            const DropdownMenuItem(
                              value: 'Other',
                              child: Text('Other', style: TextStyle(color: Colors.black)),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _leaveType = value ?? '';
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
                          onSaved: (value) => _startDate = value ?? '',
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
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
                          onSaved: (value) => _endDate = value ?? '',
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
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
                          onSaved: (value) => _reason = value ?? '',
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0A65FC),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              setState(() {
                                isLoading = true;
                              });
                              _submitLeaveRequest().then((value) {
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
                            'Submit Leave Request',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        StreamBuilder(
                          stream: _firebaseFirestore
                              .collection('createLeaveRequest')
                              .doc(auth.currentUser?.uid)
                              .collection("leave_data")
                              .orderBy("createdAt", descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.connectionState == ConnectionState.none || snapshot.hasError) {
                              return const Center(
                                child: Text(
                                  'Something went wrong. Please try again later',
                                  style: TextStyle(color: Colors.red),
                                ),
                              );
                            }
                            final leaveRequest = snapshot.data?.docs ?? [];
                            if (leaveRequest.isEmpty) {
                              return const Center(child: Text('No leave request found.'));
                            }
                            return ListView.builder(
                              itemCount: leaveRequest.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final request = leaveRequest[index];
                                final userName = request.data()['userName'] ?? 'No Username';
                                final leaveType = request.data()['leaveType'] ?? 'N/A';
                                final status = request.data()['status'] ?? 'Pending';
                                final startDate = request.data()['startDate'] ?? 'N/A';
                                final endDate = request.data()['endDate'] ?? 'N/A';
                                final reason = request.data()['reason'] ?? 'N/A';

                                return Container(
                                  margin: const EdgeInsets.symmetric(vertical: 8.0),
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
                                  child: ListTile(
                                    title: Text(
                                      '$userName\nLeave Type: $leaveType',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Status: $status\nStart Date: $startDate\nEnd Date: $endDate\nReason: $reason',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    trailing: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF0A65FC),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditLeaveRequestscreen(
                                              username: userName,
                                              leaveType: leaveType,
                                              startDate: startDate,
                                              endDate: endDate,
                                              reason: reason,
                                              id: request.id,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Edit',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
