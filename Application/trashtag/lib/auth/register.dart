import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:trashtag/auth/login.dart';

import '../home.dart';
import '../utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nc = TextEditingController();
  final _uc = TextEditingController();
  final _pc = TextEditingController();
  bool showPassword = false;
  @override
  void dispose() {
    _nc.dispose();
    _uc.dispose();
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 200, 241, 244),
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          width: 300,
          height: 310,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nc,
                decoration: const InputDecoration(hintText: "Name"),
              ),
              TextField(
                controller: _uc,
                decoration: const InputDecoration(hintText: "Username"),
              ),
              TextField(
                obscureText: !showPassword,
                controller: _pc,
                decoration: InputDecoration(
                  hintText: "Password",
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(
                        () {
                          showPassword = !showPassword;
                        },
                      );
                    },
                    icon: Icon(
                        showPassword ? Icons.visibility : Icons.visibility_off),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: const Text("Register"),
                onPressed: () async {
                  ToastContext().init(context);
                  Toast.show('Registering!');
                  final res = await TrashTraceBackend().register(
                    username: _uc.value.text,
                    name: _nc.value.text,
                    password: _pc.value.text,
                  );
                  if (res.result == true) {
                    print('Register Successful!');
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('loggedin_username', _uc.text);
                    print('LoginData Saved Successfully!');
                    Toast.show('Registered!');
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) {
                        return const Home();
                      }),
                      (route) => false,
                    );
                  } else {
                    // ignore: use_build_context_synchronously
                    Utils.showUserDialog(
                      context: context,
                      title: 'Register Failed',
                      content: res.message,
                    );
                  }
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Already have an account? Login',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w300,
                      fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
