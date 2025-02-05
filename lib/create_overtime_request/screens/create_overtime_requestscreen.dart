import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overtime_managment/create_overtime_request/screens/edit_overtime_request.dart';
import 'package:overtime_managment/services/firestore_service.dart';
import 'package:overtime_managment/utilis/utilis.dart';
import 'package:overtime_managment/admin/manageOvertime.dart';

class CreateOvertimeRequestScreen extends StatefulWidget {
  const CreateOvertimeRequestScreen({super.key});

  @override
  _CreateOvertimeRequestScreenState createState() =>
      _CreateOvertimeRequestScreenState();
}

class _CreateOvertimeRequestScreenState
    extends State<CreateOvertimeRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _overtimeType, _reason, _hours, _username;
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  bool isLoading = false;
  final auth = FirebaseAuth.instance;

  final FireStoreServices _fireStoreServices = FireStoreServices();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> _submitCreateOverTimeRequest() async{
    if(_formKey.currentState?.validate() ?? false){
      _formKey.currentState?.save();
      try{
        await _fireStoreServices.createOverTimeRequest(
            _username,
            _overtimeType,
            _startDateController.text,
            _endDateController.text,
            _reason,
            _hours,
          context
        );
        Utilis.toastSuccessMessage('Create OverTime Request Submitted Successfully');
        setState(() {
          _username = '';
          _overtimeType = '';
          _reason = '';
          _hours = '';
          _startDateController.clear();
          _endDateController.clear();
        });
        _formKey.currentState?.reset();
      }catch(e){
        Utilis.toastErrorMessage(e.toString());
      }
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _startDateController.text = pickedDate.toString().split(' ')[0];
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _endDateController.text = pickedDate.toString().split(' ')[0];
      });
    }
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double titleFontSize = screenWidth * 0.08;
    double inputFontSize = screenWidth * 0.04;
    double buttonFontSize = screenWidth * 0.04;
    double formPadding = screenWidth * 0.05;
    double verticalSpacing = screenHeight * 0.02;
    double buttonHeight = screenHeight * 0.07;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFF0A65FC),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.1),
              Text(
                'Create Overtime Request',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.all(formPadding),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'UserName',
                            border: OutlineInputBorder(),
                          ),
                          style: TextStyle(fontSize: inputFontSize),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a username';
                            }
                            return null;
                          },
                          onSaved: (value) => _username = value!,
                        ),
                        SizedBox(height: verticalSpacing),
                        // Form fields and buttons
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
                              _overtimeType = value ?? '';
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a leave type';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: verticalSpacing),
                        // Start and End date fields
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _startDateController,
                                decoration: const InputDecoration(
                                  labelText: 'Start Date',
                                  border: OutlineInputBorder(),
                                ),
                                readOnly: true,
                                onTap: () async {
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),  // Ensure initialDate is within the range
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2025, 12, 31), // Adjust lastDate to a valid range
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      _startDateController.text = DateFormat('yyyy-MM-dd').format(picked);
                                    });
                                  }
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please select a start date';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.03),
                            Expanded(
                              child: TextFormField(
                                controller: _endDateController,
                                decoration: const InputDecoration(
                                  labelText: 'Start Date',
                                  border: OutlineInputBorder(),
                                ),
                                readOnly: true,
                                onTap: () async {
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),  // Ensure initialDate is within the range
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2025, 12, 31), // Adjust lastDate to a valid range
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      _endDateController.text = DateFormat('yyyy-MM-dd').format(picked);
                                    });
                                  }
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please select a start date';
                                  }
                                  return null;
                                },
                              ),
                            ),

                          ],
                        ),
                        SizedBox(height: verticalSpacing),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Reason',
                            border: OutlineInputBorder(),
                          ),
                          style: TextStyle(fontSize: inputFontSize),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a reason';
                            }
                            return null;
                          },
                          onSaved: (value) => _reason = value!,
                        ),
                        SizedBox(height: verticalSpacing),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Hours',
                            border: OutlineInputBorder(),
                          ),
                          style: TextStyle(fontSize: inputFontSize),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the number of hours';
                            }
                            return null;
                          },
                          onSaved: (value) => _hours = value!,
                        ),
                        SizedBox(height: verticalSpacing),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0A65FC),
                            minimumSize: Size(double.infinity, buttonHeight),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              setState(() {
                                isLoading = true;
                              });
                              _submitCreateOverTimeRequest().then((value) {
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
                              : Text(
                            'Create Overtime Request',
                            style: TextStyle(
                              fontSize: buttonFontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        // ListView inside SingleChildScrollView
                  StreamBuilder(
                    stream: _firebaseFirestore
                        .collection('createOverTimeRequest')
                        .doc(auth.currentUser?.uid)
                        .collection("overTime_data")
                        .orderBy("createdAt", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No overtime request found.'));
                      }
                      final overTimeRequest = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: overTimeRequest.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final request = overTimeRequest[index];
                          final userName = request['userName'] ?? 'No Username';
                          final overTimeType = request['OverTimeType'] ?? 'N/A';
                          final status = request['status'] ?? 'Pending';
                          final startDate = request['startDate'] ?? 'N/A';
                          final endDate = request['endDate'] ?? 'N/A';
                          final reason = request['reason'] ?? 'N/A';
                          final hours = request['hours'] ?? 'N/A';
                          return Container(
                            margin:
                            const EdgeInsets.symmetric(vertical: 8.0),
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
                                "Name: $userName \nLeave Type: $overTimeType",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'Status: $status \nStart Date: $startDate \nEnd Date: $endDate \nReason: $reason \nHours: $hours',
                                style:
                                const TextStyle(color: Colors.white),
                              ),
                              trailing: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0A65FC),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditOverTimeRequestScreen(
                                          userName: userName,
                                          leaveType: overTimeType,
                                          startDate: startDate,
                                          endDate: endDate,
                                          reason: reason,
                                          hours: hours,
                                          id: request.id,
                                        ),
                                      ));
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
