// ignore_for_file: file_names
import 'package:client/fetch_data.dart';
import 'package:flutter/material.dart';
import 'package:client/main.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: InputFields(),
      backgroundColor: Color.fromARGB(255, 210, 46, 46),
    );
  }
}

class InputFields extends StatefulWidget {
  const InputFields({super.key});

  @override
  State<InputFields> createState() => InputFieldsState();
}

class InputFieldsState extends State<InputFields> {
  String _username = "";
  String _password = "";
  String _email = "";
  bool _isLoggedin = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(4))),
        width: 350,
        height: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("Login", style: TextStyle(fontSize: 28)),
            TextFormField(
              onChanged: (String value) {
                setState(() {
                  _username = value;
                });
              },
              decoration: const InputDecoration(
                hintText: "Username",
              ),
            ),
            TextFormField(
              onChanged: (String value) {
                setState(() {
                  _password = value;
                });
              },
              decoration: const InputDecoration(
                hintText: "Password",
              ),
            ),
            TextFormField(
              onChanged: (String value) {
                _email = value;
              },
              decoration: const InputDecoration(
                hintText: "Email",
              ),
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue)),
              onPressed: () async {
                _isLoggedin = await FetchHandler.sendLogin({
                  "Username": _username,
                  "Password": _password,
                  "Email": _email
                });
                //print(_isLoggedin);
                if (_isLoggedin == true) {
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyHomePage()));
                }
              },
              child: const Text(
                "Continue",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
