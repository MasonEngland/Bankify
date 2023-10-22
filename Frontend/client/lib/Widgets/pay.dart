import "package:flutter/material.dart";

class PayPage extends StatelessWidget {
  const PayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(top: 20),
        width: 300,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 60),
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: "Account id",
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 60),
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: "Description",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
