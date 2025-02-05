import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManageShiftsScreen extends StatefulWidget {
  const ManageShiftsScreen({super.key});

  @override
  _ManageShiftsScreenState createState() => _ManageShiftsScreenState();
}

class _ManageShiftsScreenState extends State<ManageShiftsScreen> {
  void addShift() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddShiftScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: 100,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 50),
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Color(0xFF0A65FC),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100),
                topRight: Radius.circular(10),
              ),
            ),
            child: const Center(
              child: Text(
                'Manage Shifts',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('createShiftRequest')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error fetching shifts'),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No Shifts Available',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                // Extracting shifts
                final shifts = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return {
                    'shiftTime': data['shiftTime'] ?? 'N/A',
                    'date': data['shiftDate'] ?? 'N/A',
                    'assignedTo': data['assignedTo'] ?? 'N/A',
                  };
                }).toList();

                return ListView.builder(
                  itemCount: shifts.length,
                  itemBuilder: (context, index) {
                    final shift = shifts[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A65FC),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(
                          'Shift: ${shift['shiftTime']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Date: ${shift['date']}, Assigned to: ${shift['assignedTo']}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0A65FC),
        foregroundColor: Colors.white,
        onPressed: addShift,
        tooltip: 'Add Shift',
        child: const Icon(Icons.add),
      ),
    );
  }
}



class AddShiftScreen extends StatefulWidget {
  @override
  _AddShiftScreenState createState() => _AddShiftScreenState();
}

class _AddShiftScreenState extends State<AddShiftScreen> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController assignedToController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TimeOfDay? selectedTime;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  Future<void> _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  Future<void> saveShiftData(String shiftDate, String shiftTime, String assignedTo) async {
    try {
      String createShiftId = DateTime.now().millisecondsSinceEpoch.toString();
      await _firestore.collection('createShiftRequest').doc(createShiftId).set({
        'shiftDate': shiftDate,
        'shiftTime': shiftTime,
        'assignedTo': assignedTo,
        'shiftId': createShiftId,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Shift saved successfully!')),
      );
      _resetForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving shift: $e')),
      );
    }
  }

  void _resetForm() {
    setState(() {
      dateController.clear();
      assignedToController.clear();
      selectedTime = null;
    });
    _formKey.currentState?.reset();
  }

  void _submitShift() {
    if (_formKey.currentState?.validate() ?? false) {
      if (selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a shift time!')),
        );
        return;
      }
      saveShiftData(
        dateController.text,
        selectedTime!.format(context),
        assignedToController.text,
      );
    }
  }

  Widget _buildInputField({
    required String hintText,
    required TextEditingController controller,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field cannot be empty';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Assigned To: ${assignedToController.text}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Shift'),
        backgroundColor: const Color(0xFF0A65FC),
      ),
      backgroundColor: const Color(0xFF0A65FC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildInputField(
                        hintText: 'Date (YYYY-MM-DD)',
                        controller: dateController,
                        readOnly: true,
                        onTap: _pickDate,
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _pickTime,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            selectedTime == null
                                ? 'Select Shift Time'
                                : 'Shift Time: ${selectedTime!.format(context)}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.black87),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInputField(
                        hintText: 'Assigned To',
                        controller: assignedToController,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _submitShift,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.blueAccent,
                        ),
                        child: const Text(
                          'Save Shift',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
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


