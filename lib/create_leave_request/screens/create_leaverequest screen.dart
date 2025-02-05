import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overtime_managment/services/firestore_service.dart';
import 'package:overtime_managment/utilis/utilis.dart';

class CreateLeaveRequestScreen extends StatefulWidget {
  const CreateLeaveRequestScreen({super.key});

  @override
  _CreateLeaveRequestScreenState createState() =>
      _CreateLeaveRequestScreenState();
}

class _CreateLeaveRequestScreenState extends State<CreateLeaveRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _leaveType, _startDate, _endDate, _reason, _userId;
  // late DateTime _startDateDateTime, _endDateDateTime;
  bool isLoading = false;

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  final FireStoreServices _fireStoreServices = FireStoreServices();
  Future<void> _submitCreateLeaveRequest() async{
    if(_formKey.currentState?.validate() ?? false){
      _formKey.currentState?.save();
      try{
       await _fireStoreServices.createLeaveRequest(
            _leaveType,
            _startDate,
            _endDate,
            _reason
        );
        Utilis.toastSuccessMessage('Create Leave Request Submitted Successfully');
        setState(() {
          _leaveType = '';
          _reason = '';
          _startDate = '';
          _endDate = '';
          _startDateController.clear();
          _endDateController.clear();
        });

       _formKey.currentState?.reset();
      }catch(e){
        Utilis.toastErrorMessage(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double buttonHeight = screenHeight * 0.06;

    double titleFontSize = screenWidth * 0.07;

    return Scaffold(
      body: Container(
        color: Color(0xFF0A65FC),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.1),
            Text(
              'Create Leave Request',
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Leave Type',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please select a leave type';
                              }
                              return null;
                            },
                            onSaved: (value) => _leaveType = value ?? '',
                          ),
                          SizedBox(height: screenHeight * 0.02),
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
                                    final DateTime? picked =
                                    await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2025),
                                    );
                                    if (picked != null) {
                                      setState(() {
                                        _startDateController.text =
                                            DateFormat('yyyy-MM-dd')
                                                .format(picked);
                                        _startDate = DateFormat('yyyy-MM-dd').format(picked);
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
                                    labelText: 'End Date',
                                    border: OutlineInputBorder(),
                                  ),
                                  readOnly: true,
                                  onTap: () async {
                                    final DateTime? picked =
                                    await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2025),
                                    );
                                    if (picked != null) {
                                      setState(() {
                                        _endDateController.text =
                                            DateFormat('yyyy-MM-dd')
                                                .format(picked);
                                        _endDate = DateFormat('yyyy-MM-dd').format(picked);
                                      });
                                    }
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please select an end date';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          TextFormField(
                            decoration: InputDecoration(
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
                          SizedBox(height: screenHeight * 0.03),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0A65FC),
                              minimumSize: Size(double.infinity, buttonHeight),
                            ),
                            onPressed: (){
                              if(_formKey.currentState?.validate() ?? false){
                                _formKey.currentState!.save();
                                setState(() {
                                  isLoading = true;
                                });
                                _submitCreateLeaveRequest().then((value){
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
                                : Text('Create Leave Request',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),),
                          )

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
