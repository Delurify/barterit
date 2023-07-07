import 'package:flutter/material.dart';
import 'package:barterit/models/user.dart';

class PurchaseType {
  String credit = "";
  String cost = "";

  PurchaseType({required this.credit, required this.cost});
}

class PurchaseCreditScreen extends StatefulWidget {
  final User user;
  const PurchaseCreditScreen({super.key, required this.user});

  @override
  State<PurchaseCreditScreen> createState() => _PurchaseCreditScreenState();
}

class _PurchaseCreditScreenState extends State<PurchaseCreditScreen> {
  late double screenWidth, screenHeight;
  int axiscount = 3;
  List<PurchaseType> purchaseList = [
    PurchaseType(credit: "30", cost: "3.90"),
    PurchaseType(credit: "280", cost: "19.90"),
    PurchaseType(credit: "640", cost: "59.90"),
    PurchaseType(credit: "1680", cost: "129.90"),
    PurchaseType(credit: "2480", cost: "199.90"),
    PurchaseType(credit: "4980", cost: "399.90"),
  ];

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > 600) {
      axiscount = 4;
    } else {
      axiscount = 3;
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Top Up"),
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                  child: GridView.count(
                      childAspectRatio: 4 / 5,
                      crossAxisCount: axiscount,
                      children: List.generate(
                        purchaseList.length,
                        (index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            clipBehavior: Clip.antiAlias,
                            elevation: 2,
                            child: InkWell(
                              onTap: () async {},
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                        child: Image.asset(
                                            "assets/images/top-up.png")),
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Expanded(
                                          child: SingleChildScrollView(
                                            // for horizontal scrolling
                                            scrollDirection: Axis.horizontal,

                                            child: Text(
                                              purchaseList[index]
                                                  .credit
                                                  .toString(),
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        // Add fovorite icon in here later
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          "RM ${purchaseList[index].cost}",
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ]),
                            ),
                          );
                        },
                      )))
            ],
          ),
        ));
  }
}
