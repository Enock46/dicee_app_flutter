import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: TextField(
                maxLength: 39,
                keyboardType: TextInputType.name,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.login),
              label: Text('Login'),
            )),
          ],
        ),
      ),
    );
  }
}
