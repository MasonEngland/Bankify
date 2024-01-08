import "package:client/fetch_data.dart";
import "package:flutter/material.dart";

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => HomeBodyState();
}

class HomeBodyState extends State<HomeBody> {
  List<Widget> _detailBoxes = [];
  static bool set = false;

  void handle() async {
    List<Widget> output = [];
    List data = await FetchHandler.getAccounts();
    for (var item in data) {
      if (item["failed"] != null) {
        throw ErrorDescription("could not fetch accounts");
      }
      output.add(DetailBox(
        name: item["name"],
        number: trunkate(item["id"]),
        fullNumber: item["id"],
        balance: item["balance"].toDouble(),
      ));
    }
    setState(() {
      _detailBoxes = output;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_detailBoxes.isEmpty) {
      handle();
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: _detailBoxes,
      ),
    );
  }
}

class DetailBox extends StatelessWidget {
  const DetailBox({
    super.key,
    required this.name,
    required this.number,
    required this.fullNumber,
    required this.balance,
  });

  final double balance;
  final String name;
  final String number;
  final String fullNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
            offset: Offset(3, 3),
          )
        ],
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(13)),
      ),
      width: 330,
      height: 130,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              TextButton(
                child: Text(
                  "$number...",
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(fullNumber),
                      );
                    },
                  );
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "\$$balance",
                style: const TextStyle(
                  fontSize: 34,
                ),
              ),
              const Text("available now")
            ],
          )
        ],
      ),
    );
  }
}

// ignore this, too small to warrent putting in a differnet place
String trunkate(String word) {
  return word.substring(0, 5);
}
