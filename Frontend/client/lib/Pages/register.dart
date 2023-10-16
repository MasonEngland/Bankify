// ignore_for_file: file_names
import 'package:client/Pages/login.dart';
import 'package:client/fetch_data.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
  // state
  String _username = "";
  String _password = "";
  String _email = "";

  // private
  bool isRegistered = false;

  // handlers
  void clickHandler() async {
    if (_username == "" || _password == "" || _email == "") {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text("Register Failed"),
          );
        },
      );
      return;
    }
    isRegistered = await FetchHandler.sendRegister(
      {"Username": _username, "Password": _password, "Email": _email},
    );
    //print(isRegistered);
    if (isRegistered != true) {
      // ignore: use_build_context_synchronously
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text("Register Failed"),
          );
        },
      );
      return;
    }
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        width: 350,
        height: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("Register", style: TextStyle(fontSize: 28)),
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
              obscureText: true,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const LoginPage(),
                      ),
                    );
                  },
                  child: const Text("Login"),
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                  onPressed: clickHandler, // onPressed
                  child: const Text(
                    "Continue",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
