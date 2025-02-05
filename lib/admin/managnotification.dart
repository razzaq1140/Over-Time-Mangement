import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overtime_managment/notification/enter_notification.dart';
import 'package:overtime_managment/notification/notification_serivce.dart';

class ManagedNotificationScreen extends StatefulWidget {
  const ManagedNotificationScreen({Key? key}) : super(key: key);

  @override
  _ManagedNotificationScreenState createState() => _ManagedNotificationScreenState();
}

class _ManagedNotificationScreenState extends State<ManagedNotificationScreen> {
  final List<NotificationModel> _notifications = [];

  @override
  void initState() {
    super.initState();
    final pushNotificationService = PushNotificationService();
    pushNotificationService.initialize((notification) {
      setState(() {
        _notifications.insert(0, notification); // Add new notification at the top
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Notifications'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: _notifications.isEmpty
                ? const Center(child: Text('No Notifications'))
                : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                return NotificationCard(
                  notification: _notifications[index],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EnterNotificationScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NotificationModel {
  int id;
  String title;
  String message;
  DateTime timestamp;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
  });
}

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationCard({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notification.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(
            notification.message,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(
            'Received on ${DateFormat('dd MMM yyyy hh:mm a').format(notification.timestamp)}',
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
