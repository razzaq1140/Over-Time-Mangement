import 'package:flutter/material.dart';
import 'package:overtime_managment/services/firestore_service.dart';
import 'package:overtime_managment/utilis/utilis.dart';

class OvertimeRequestsScreen extends StatefulWidget {
  const OvertimeRequestsScreen({super.key});

  @override
  _OvertimeRequestsScreenState createState() => _OvertimeRequestsScreenState();
}

class _OvertimeRequestsScreenState extends State<OvertimeRequestsScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _overtimeType, _date, _startTime, _endTime, _reason;
  bool isLoading = false;

  final FireStoreServices _fireStoreServices = FireStoreServices();
  Future<void> _submitOverTimeRequest() async{
    if(_formKey.currentState?.validate() ?? false){
      _formKey.currentState?.save();
      try{
        await _fireStoreServices.saveOverTimeRequest(
            _overtimeType,
            _date,
            _startTime,
            _endTime,
            _reason
        );
        Utilis.toastSuccessMessage('OverTime Request Submitted Successfully');
        setState(() {
          _overtimeType = '';
          _date = '';
          _startTime = '';
          _endTime = '';
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
      body: Container(
        color: Color(0xFF0A65FC),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Text(
              'Overtime Requests',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width * 0.07,
              ),
            ),
            SizedBox(height: 50),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DropdownButtonFormField<String>(
                            dropdownColor: Colors.white,
                            decoration: InputDecoration(
                              labelText: 'Overtime Type',
                              border: OutlineInputBorder(),
                            ),
                            items: [
                              DropdownMenuItem(
                                child: Text(
                                  'Regular Overtime',
                                  style: TextStyle(color: Colors.black),
                                ),
                                value: 'Regular Overtime',
                              ),
                              DropdownMenuItem(
                                child: Text(
                                  'Compensatory Overtime',
                                  style: TextStyle(color: Colors.black),
                                ),
                                value: 'Compensatory Overtime',
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _overtimeType = value ?? '';
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select an overtime type';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Date',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a date';
                              }
                              return null;
                            },
                            onSaved: (value) => _date = value ?? '',
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Start Time',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a start time';
                              }
                              return null;
                            },
                            onSaved: (value) => _startTime = value ?? '',
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'End Time',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter an end time';
                              }
                              return null;
                            },
                            onSaved: (value) => _endTime = value ?? '',
                          ),
                          SizedBox(height: 20),
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
                          SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0A65FC),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                setState(() {
                                  isLoading = true;
                                });
                                _submitOverTimeRequest().then((value){
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
                                :
                            Text(
                              'Submit Overtime Request',
                              style: const TextStyle(
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
