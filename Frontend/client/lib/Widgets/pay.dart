import "package:client/fetch_data.dart";
import "package:flutter/material.dart";

class PayPage extends StatefulWidget {
  const PayPage({super.key});

  @override
  State<PayPage> createState() => PayPageState();
}

class PayPageState extends State<PayPage> {
  String fromId = "";
  String toId = ""; 
  String description = ""; 
  double amount = 0; 


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
                onChanged: (String val) {
                  fromId = val;
                },
                decoration: const InputDecoration(
                  hintText: "Account from (name)",
                )
              )
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 60),
              child: TextFormField(
                onChanged: (String val) {
                  toId = val;
                },
                decoration: const InputDecoration(
                  hintText: "Account to (id)",
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 60),
              child: TextFormField(
                onChanged: (String val) {
                  description = val;
                },
                decoration: const InputDecoration(
                  hintText: "Description",
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 60),
              child: TextFormField(
                onChanged: (String val) {
                  try {
                    amount = double.parse(val);
                  } on TypeError {
                    return;
                  }
                },
                decoration: const InputDecoration(hintText: "Amount"),
                keyboardType: const TextInputType.numberWithOptions(decimal: true,),
              ),
            ),
            TextButton(
              onPressed: () async {
                bool success = await FetchHandler.sendMoney(fromId, toId, amount, description);
                if (!success) {
                  // ignore: use_build_context_synchronously
                  await showDialog(  
                  context: context, 
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      title: Text("Transaction Failed :("),
                    );
                  });
                }
                else {
                  // ignore: use_build_context_synchronously
                  await showDialog(
                    context: context, 
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        title: Text("Success!"),
                      );
                    }
                  );
                  setState(() {
                    fromId = "";
                    toId = "";
                    description = "";
                    amount = 0;
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4), 
                  color: Colors.blue,
                ),
                width: 120,
                height: 50,
                child: const Center(
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
