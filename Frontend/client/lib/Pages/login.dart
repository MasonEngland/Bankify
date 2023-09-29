import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Please Register"),
        backgroundColor: Colors.red,
      ),
      body: const InputFields(),
      backgroundColor: Colors.grey,
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
        width: 300,
        height: 500,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(hintText: "Username"),
            )
          ],
        ),
      ),
    );
  }
}
