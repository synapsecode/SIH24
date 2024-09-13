import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:trashtag/home.dart';
import 'package:trashtag/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _uc = TextEditingController();
  final _pc = TextEditingController();
  bool showPassword = false;

  @override
  void dispose() {
    _uc.dispose();
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 200, 241, 244),
      appBar: AppBar(
        title: const Text("Log In"),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          width: 300,
          height: 260,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _uc,
                decoration: const InputDecoration(hintText: "Username"),
              ),
              TextField(
                controller: _pc,
                obscureText: !showPassword,
                decoration: InputDecoration(
                  hintText: "Password",
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
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
                child: const Text("Login"),
                onPressed: () async {
                  print(_uc.text);
                  print(_pc.text);
                  ToastContext().init(context);
                  Toast.show('Logging In!');
                  final res = await TrashTraceBackend().login(
                    username: _uc.value.text,
                    password: _pc.value.text,
                  );
                  if (res.result == true) {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('loggedin_username', _uc.text);
                    print('LoginData Saved Successfully!');
                    Toast.show('Logged in!');
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) {
                        return Home();
                      }),
                      (route) => false,
                    );
                  } else {
                    // ignore: use_build_context_synchronously
                    Utils.showUserDialog(
                      context: context,
                      title: 'Login Failed',
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
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Don\'t have an account? Register',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w300,
                      fontSize: 14),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
