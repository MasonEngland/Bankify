import 'package:flutter/material.dart';
import 'Pages/login.dart';
//import 'fetch_data.dart';

void main() async {
  runApp(const MaterialApp(title: "Welcome to flutter", home: LoginPage()));
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bankify"),
        centerTitle: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 30),
            child: const Icon(Icons.notifications),
          )
        ],
        backgroundColor: Colors.red,
      ),
      body: const SomeTextTest(maintext: "Main Test"),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          Text("Cool", textAlign: TextAlign.center),
          Text("Not Cool", textAlign: TextAlign.center),
          Text("Kinda Cool", textAlign: TextAlign.center)
        ],
      ),
    );
  }
}

class SomeTextTest extends StatelessWidget {
  const SomeTextTest({super.key, required this.maintext});

  final String maintext;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4), color: Colors.green),
      margin: const EdgeInsets.only(left: 20, top: 20),
      height: 50,
      width: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(maintext), const Text("Test Two")],
      ),
    );
  }
}
