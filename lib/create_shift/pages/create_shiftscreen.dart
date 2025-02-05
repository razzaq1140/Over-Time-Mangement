import 'package:flutter/material.dart';
import 'package:overtime_managment/services/firestore_service.dart';
import 'package:overtime_managment/utilis/utilis.dart';

class CreateShiftScreen extends StatefulWidget {
  const CreateShiftScreen({super.key});

  @override
  _CreateShiftScreenState createState() => _CreateShiftScreenState();
}

class _CreateShiftScreenState extends State<CreateShiftScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _shiftName, _shiftDate, _shiftTime, _shiftDuration;
  bool isLoading = false;

  final FireStoreServices _fireStoreServices = FireStoreServices();
  Future<void> _submitCreateShift() async{
    if(_formKey.currentState?.validate() ?? false){
      _formKey.currentState?.save();
      try{
        await _fireStoreServices.saveCreateShift(
            _shiftName,
            _shiftDate,
            _shiftTime,
            _shiftDuration
        );
        Utilis.toastSuccessMessage('Create Shift Submitted Successfully');
        setState(() {
          _shiftName = '';
          _shiftDate = '';
          _shiftTime = '';
          _shiftDuration = '';
        });
        _formKey.currentState!.reset();
      }catch(e){
        Utilis.toastErrorMessage(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double titleFontSize = screenWidth * 0.08;
    double inputFontSize = screenWidth * 0.04;
    double buttonFontSize = screenWidth * 0.05;

    double formPadding = screenWidth * 0.05;
    double verticalSpacing = screenHeight * 0.02;
    double buttonHeight = screenHeight * 0.06;

    return Scaffold(
      body: Container(
        color: Color(0xFF0A65FC),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.1),
            Text(
              'Create Shift',
              style: TextStyle(
                color: Colors.white,
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
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
                    padding: EdgeInsets.all(formPadding),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Shift Name',
                              border: OutlineInputBorder(),
                            ),
                            style: TextStyle(fontSize: inputFontSize),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a shift name';
                              }
                              return null;
                            },
                            onSaved: (value) => _shiftName = value!,
                          ),
                          SizedBox(height: verticalSpacing),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Shift Date',
                              border: OutlineInputBorder(),
                            ),
                            style: TextStyle(fontSize: inputFontSize),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a shift date';
                              }
                              return null;
                            },
                            onSaved: (value) => _shiftDate = value!,
                          ),
                          SizedBox(height: verticalSpacing),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Shift Time',
                              border: OutlineInputBorder(),
                            ),
                            style: TextStyle(fontSize: inputFontSize),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a shift time';
                              }
                              return null;
                            },
                            onSaved: (value) => _shiftTime = value!,
                          ),
                          SizedBox(height: verticalSpacing),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Shift Duration',
                              border: OutlineInputBorder(),
                            ),
                            style: TextStyle(fontSize: inputFontSize),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a shift duration';
                              }
                              return null;
                            },
                            onSaved: (value) => _shiftDuration = value!,
                          ),
                          SizedBox(height: verticalSpacing),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0A65FC),
                              minimumSize: Size(double.infinity, buttonHeight),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                setState(() {
                                  isLoading = true;
                                });
                                _submitCreateShift().then((value){
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
                              'Create Shift',
                              style: TextStyle(
                                fontSize: buttonFontSize,
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
