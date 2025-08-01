import 'package:flutter/material.dart';

class TaskDashboard extends StatelessWidget {
  const TaskDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Note"),
      ),
      body: Center(
        child: Text("data"),
      ),
    );
  }
}
