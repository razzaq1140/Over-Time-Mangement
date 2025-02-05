import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FireStoreServices{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loginData(String name, String email) async{
    try{
      String userLoginId = DateTime.now().millisecondsSinceEpoch.toString();
      await _firestore.collection('login').doc(userLoginId).set({
        'name': name,
        'email': email,
        'userId': userLoginId
      });
    }catch(e){
      throw Exception('Error saving signUp request: $e');
    }
  }

  Future<void> saveSignUpData(String name, String email) async{
    try{
      String userSignUpId = DateTime.now().millisecondsSinceEpoch.toString();
      await _firestore.collection('signUp').doc(userSignUpId).set({
        'name': name,
        'email': email,
        'userId': userSignUpId
      });
    }catch(e){
      throw Exception('Error saving signUp request: $e');
    }
  }

  //Post of data leave request
  Future<void> saveLeaveRequest(String username, String leaveType, String startDate, String endDate, String reason,BuildContext context) async{
    try{
      // String leaveRequestId = DateTime.now().millisecondsSinceEpoch.toString();
      User? user = _auth.currentUser;
      if(user != null){
        await _firestore.collection('createLeaveRequest').doc(user.uid).collection("leave_data").add({
          'userName': username,
          'leaveType': leaveType,
          'startDate': startDate,
          'endDate': endDate,
          'reason': reason,
          'status': 'Pending',
          // 'createdAt': FieldValue.serverTimestamp(),
          'userId': user.uid,
          'createdAt': Timestamp.now(),
        });
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User not login')));
      }
      if (kDebugMode) {
        print("leaveRequestId ${user?.uid}");
      }
    }catch(e){
      throw Exception('Error saving leave request: $e');
    }
  }

  // Get all leave requests (existing method)
  Future<List<Map<String, dynamic>>> getLeaveRequests() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('leaveRequest').get();

      List<Map<String, dynamic>> leaveRequests = [];
      for (var doc in querySnapshot.docs) {
        leaveRequests.add(doc.data() as Map<String, dynamic>);
      }

      return leaveRequests;
    } catch (e) {
      throw Exception('Error getting leave requests: $e');
    }
  }

  // Post of data overTime request
  Future<void> saveOverTimeRequest(String overTimeType, String date, String startTime, String endTime, String reason) async{
    try{
      String overTimeRequestId = DateTime.now().millisecondsSinceEpoch.toString();
      await _firestore.collection('overTimeRequest').doc(overTimeRequestId).set({
        'overTimeType': overTimeType,
        'date': date,
        'startTime': startTime,
        'endTime': endTime,
        'reason': reason,
        'userId': overTimeRequestId,
      });
    }catch(e){
      throw Exception('Error saving overTime request: $e');
    }
  }

  // Post of data create shift
  Future<void> saveCreateShift(String shiftName, String shiftDate, String shiftTime, String shiftDuration, ) async{
    try{
      String createShiftId = DateTime.now().millisecondsSinceEpoch.toString();
      await _firestore.collection('createShift').doc(createShiftId).set({
        'shiftName': shiftName,
        'shiftDate': shiftDate,
        'shiftTime': shiftTime,
        'shiftDuration': shiftDuration,
        'userId': createShiftId
      });
    }catch(e){
      throw Exception('Error saving create shift request: $e');
    }
  }

  // Post of data create leve request
  Future<void> createLeaveRequest(String leaveType, String startDate, String endDate, String reason) async{
    try{
      String createLeaveRequestId = DateTime.now().millisecondsSinceEpoch.toString();
      await _firestore.collection('createLeaveRequest').doc(createLeaveRequestId).set({
        'leaveType': leaveType,
        'startDate': startDate,
        'endDate': endDate,
        'reason': reason,
        'userId': createLeaveRequestId,
      });
    }catch(e){
      throw Exception('Error saving create leave request');
    }
  }

  // Post of data create overTime request
  Future<void> createOverTimeRequest(String userName,String overTimeType, String startDate, String endDate, String reason, String hours, BuildContext context) async{
    try{
      // String createOverTimeRequestId = DateTime.now().millisecondsSinceEpoch.toString();
      User? user = _auth.currentUser;
      if(user != null){
        await _firestore.collection('createOverTimeRequest').doc(user.uid).collection('overTime_data').add({
          'userName': userName,
          'OverTimeType': overTimeType,
          'startDate': startDate,
          'endDate': endDate,
          'reason': reason,
          'hours': hours,
          'status': 'Pending',
          'userId': user.uid,
          'createdAt': Timestamp.now(),
        });
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User not login')));
      }
    }catch(e){
      throw Exception('Error saving create overtime request');
    }
  }

  Future<void> saveShiftData(String shiftDate, String shiftTime, String shiftAssignTask,) async{
    try{
      String createShiftId = DateTime.now().millisecondsSinceEpoch.toString();
      await _firestore.collection('createShiftRequest').doc(createShiftId).set({
        'shiftDate': shiftDate,
        'shiftTime': shiftTime,
        'shiftTaskAssign': shiftAssignTask,
        'userId': createShiftId,
      });
    }catch(e){
      throw Exception('Error saving create overtime request');
    }
  }
}