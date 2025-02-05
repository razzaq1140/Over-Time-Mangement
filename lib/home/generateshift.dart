import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:overtime_managment/admin/shiftmangment.dart';
import 'package:path_provider/path_provider.dart';

class ShiftScreen1 extends StatefulWidget {
  const ShiftScreen1({super.key});

  @override
  _ShiftScreen1State createState() => _ShiftScreen1State();
}

class _ShiftScreen1State extends State<ShiftScreen1> {
  void addShift() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddShiftScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Shifts',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF0A65FC),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Container(
          //   height: 100,
          //   width: double.infinity,
          //   margin: const EdgeInsets.only(top: 50),
          //   padding: const EdgeInsets.all(16.0),
          //   decoration: const BoxDecoration(
          //     color: Color(0xFF0A65FC),
          //     borderRadius: BorderRadius.only(
          //       topLeft: Radius.circular(10),
          //       bottomLeft: Radius.circular(100),
          //       bottomRight: Radius.circular(100),
          //       topRight: Radius.circular(10),
          //     ),
          //   ),
          //   child: const Center(
          //     child:
          //   ),
          // ),
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
    );
  }
}