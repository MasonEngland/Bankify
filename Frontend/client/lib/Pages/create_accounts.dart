import "package:client/main.dart";
import "package:flutter/material.dart";
import "package:client/fetch_data.dart";

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => CreateAccountPageState();
}

class CreateAccountPageState extends State<CreateAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text(
            "Create New Bank Account",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const MyHomePage(),
                  ),
                );
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
          backgroundColor: Colors.red,
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
              child: TextFormField(
                decoration: const InputDecoration(hintText: "Account Name"),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 45, right: 20, left: 20),
              child: TextFormField(
                decoration: const InputDecoration(hintText: "Initial deposit"),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 45, right: 20, left: 20),
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: "Bankify Banker ID (leave blank for default)",
                ),
              ),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.only(top: 30),
                child: TextButton(
                  onPressed: () {},
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    width: 100,
                    height: 40,
                    child: const Center(
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
