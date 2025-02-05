import 'package:flutter/material.dart';
import 'package:overtime_managment/admin/admin_login.dart';
import 'package:overtime_managment/create_leave_request/screens/create_leaverequest%20screen.dart';
import 'package:overtime_managment/create_overtime_request/screens/create_overtime_requestscreen.dart';
import 'package:overtime_managment/create_shift/pages/create_shiftscreen.dart';
import 'package:overtime_managment/edit_leave_requestscreen.dart';
import 'package:overtime_managment/edit_overtimescreen.dart';
import 'package:overtime_managment/home/generateshift.dart';
import 'package:overtime_managment/leave_request/screens/leave_requestscreen.dart';
import 'package:overtime_managment/notificationscreen.dart';
import 'package:overtime_managment/overtime_request/screens/overtime_requestscreen.dart';
import 'package:overtime_managment/userprofilescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _logoScaleAnimation;
  String email = '';
  String password = '';
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email') ?? '';
      password = prefs.getString('password') ?? '';
    });
  }
  @override
  void initState() {
    super.initState();
    _loadUserData();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF0A65FC),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60, left: 90),
              child: Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: screenWidth * 0.09,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 100),
              child: ScaleTransition(
                scale: _logoScaleAnimation,
                child: SizedBox(
                  height: 130,
                  width: 150,
                  child: Image.asset('assets/images/logo.png'),
                ),
              ),
            ),
            Flexible(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildGridRow(
                          context,
                          screenWidth,
                          'Shifts',
                          'assets/images/shift.png',
                          const ShiftScreen1(),
                          'Leave Request',
                          'assets/images/leave.png',
                          const LeaveRequestsScreen(),
                        ),
                        const SizedBox(height: 20),
                        _buildGridRow(
                          context,
                          screenWidth,
                          'Overtime Request',
                          'assets/images/shifttt.gif',
                          const CreateOvertimeRequestScreen(),
                          'User Profile',
                          'assets/images/profile.png',
                          const UserProfileScreen(),
                        ),
                        const SizedBox(height: 20),
                        _buildGridRow(
                          context,
                          screenWidth * 0.75,
                          'Admin',
                          'assets/images/admin1.png',
                          Expanded(child: const AdminLoginScreen()),
                        ),
                        const SizedBox(height: 20),
                        // _buildGridRow(
                        //   context,
                        //   screenWidth,
                        //   'Notifications',
                        //   'assets/images/notification.png',
                        //   const NotificationsScreen(),
                        //   'Overtime Requests',
                        //   'assets/images/overtime.png',
                        //   const OvertimeRequestsScreen(),
                        // ),
                      ],
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

  Widget _buildGridRow(
      BuildContext context,
      double screenWidth,
      String label1,
      String asset1,
      Widget route1, [
        String? label2,
        String? asset2,
        Widget? route2,
      ]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (label2 != null && asset2 != null && route2 != null)
          ...[
            _buildGridItem(context, screenWidth * 0.4, label1, asset1, route1),
            _buildGridItem(context, screenWidth * 0.4, label2, asset2, route2),
          ]
        else
          _buildGridItem(context, screenWidth, label1, asset1, route1),
      ],
    );
  }

  Widget _buildGridItem(
      BuildContext context,
      double width,
      String label,
      String assetPath,
      Widget route) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => route),
        );
      },
      child: Container(
        height: 100,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: SizedBox(
                height: 60,
                width: 60,
                child: Image.asset(assetPath),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A65FC),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
