import 'package:flutter/material.dart';
import 'package:overtime_managment/notification/notification_serivce.dart';

class EnterNotificationScreen extends StatefulWidget {
  const EnterNotificationScreen({Key? key}) : super(key: key);

  @override
  State<EnterNotificationScreen> createState() => _EnterNotificationScreenState();
}

class _EnterNotificationScreenState extends State<EnterNotificationScreen> {
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  final PushNotificationService _pushNotificationService = PushNotificationService();

  void sendNotification() async {
    final token = _tokenController.text.trim();
    final title = _titleController.text.trim();
    final message = _messageController.text.trim();

    if (token.isNotEmpty && title.isNotEmpty && message.isNotEmpty) {
      await _pushNotificationService.sendNotificationToUser(token, title, message);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Notification Sent!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("All fields are required!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Send Notification")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tokenController,
              decoration: const InputDecoration(labelText: "Enter User Token"),
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Enter Title"),
            ),
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(labelText: "Enter Message"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendNotification,
              child: const Text("Send Notification"),
            ),
          ],
        ),
      ),
    );
  }
}
