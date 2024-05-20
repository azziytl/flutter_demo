import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class AttendanceDetail extends StatelessWidget {
  final Map<String, dynamic> attendance;

  AttendanceDetail({required this.attendance});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade100,
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        title: Text(
          'Attendance Details',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Attendance Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(
                  color: Colors.black,
                  height: 20,
                  thickness: 1,
                ),
                Text(
                  'User: ${attendance["user"]}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Phone: ${attendance["phone"]}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'Check-in Time: ${attendance["checkIn"]}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _shareAttendance(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                    ),
                    child: Text(
                      'Share Contact',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _shareAttendance(BuildContext context) {
    final String user = attendance["user"];
    final String phone = attendance["phone"];
    final String checkIn = attendance["checkIn"];

    final String text = 'User: $user\nPhone: $phone\nCheck-in Time: $checkIn';

    Share.share(text, subject: 'Attendance Information');
  }
}
