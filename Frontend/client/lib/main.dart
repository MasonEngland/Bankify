// ignore_for_file: unused_import
import "Widgets/pay.dart";
import 'package:client/Pages/login.dart';
import 'package:client/fetch_data.dart';
import 'package:flutter/material.dart';
//import 'Pages/login.dart';
import 'widgets/home.dart';

void main() async {
  runApp(const MaterialApp(title: "Welcome to flutter", home: LoginPage()));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int _currentPageIndex = 0;

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
      body: <Widget>[
        const HomeBody(),
        const PayPage(),
        const SomeTextTest(maintext: "Subtext 2")
      ][_currentPageIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentPageIndex,
        indicatorColor: Colors.red,
        onDestinationSelected: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.house_outlined),
            selectedIcon: Icon(Icons.house),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.wallet_outlined),
            selectedIcon: Icon(Icons.wallet),
            label: "pay",
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: "Settings",
          ),
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
        borderRadius: BorderRadius.circular(4),
        color: Colors.green,
      ),
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
