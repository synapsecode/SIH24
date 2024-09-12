import 'package:flutter/material.dart';
import 'package:trashtag/home.dart';

void main() {
  runApp(const TrashTagApplication());
}

class TrashTagApplication extends StatelessWidget {
  const TrashTagApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TrashTag",
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
