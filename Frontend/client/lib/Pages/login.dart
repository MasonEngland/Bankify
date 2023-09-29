import 'package:flutter/material.dart';

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
              decoration: const InputDecoration(
                hintText: "Username",
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: "Password",
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: "Email",
              ),
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue)),
              onPressed: () {},
              child: const Text(
                "Click Me",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
