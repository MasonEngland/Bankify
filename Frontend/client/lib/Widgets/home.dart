import "package:flutter/material.dart";

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DetailBox(
            name: "MYSTYLE CHECKING",
            number: 80442,
            balance: 82.43,
          ),
        ],
      ),
    );
  }
}

class DetailBox extends StatelessWidget {
  const DetailBox({
    super.key,
    required this.name,
    required this.number,
    required this.balance,
  });

  final double balance;
  final String name;
  final int number;

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
              Text(
                "$number...",
                style: const TextStyle(
                  fontSize: 18,
                ),
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
