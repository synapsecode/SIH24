import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trashtag/auth/login.dart';
import 'package:trashtag/extensions/extensions.dart';
import 'package:trashtag/home.dart';

void main() {
  runApp(const TrashTagApplication());
}

class TrashTagApplication extends StatefulWidget {
  const TrashTagApplication({super.key});

  @override
  State<TrashTagApplication> createState() => _TrashTagApplicationState();
}

class _TrashTagApplicationState extends State<TrashTagApplication> {
  String? _user;
  _checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    _user = prefs.getString('x-user');
    setState(() {});
  }

  @override
  void initState() {
    _checkUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "TrashTag",
        debugShowCheckedModeBanner: false,
        home: WebLimiter(
          home: _user == null ? LoginScreen() : Home(),
        ));
  }
}

class WebLimiter extends StatelessWidget {
  final Widget home;
  const WebLimiter({super.key, required this.home});

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
    return home;
  }
}
