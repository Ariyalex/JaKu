import 'package:flutter/material.dart';

class NoteDashboard extends StatelessWidget {
  const NoteDashboard({super.key});

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
