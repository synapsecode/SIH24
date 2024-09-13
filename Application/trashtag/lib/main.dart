import 'package:flutter/material.dart';
import 'package:trashtag/extensions/extensions.dart';
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
      home: WebLimiter(),
    );
  }
}

class WebLimiter extends StatelessWidget {
  const WebLimiter({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
                  'Desktop Web Version Unsupported! Please use TrashTag on a Mobile Device')
              .color(Colors.white),
        ),
      );
    }
    return const Home();
  }
}
