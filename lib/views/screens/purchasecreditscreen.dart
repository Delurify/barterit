import 'package:barterit/views/screens/billscreen.dart';
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
  String selected = "";
  String credit = "";
  int axiscount = 3;
  List<PurchaseType> purchaseList = [
    PurchaseType(credit: "30", cost: "3.90"),
    PurchaseType(credit: "280", cost: "19.90"),
    PurchaseType(credit: "640", cost: "59.90"),
    PurchaseType(credit: "1680", cost: "129.90"),
    PurchaseType(credit: "3180", cost: "199.90"),
    PurchaseType(credit: "6480", cost: "399.90"),
  ];

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    if (screenWidth > 600) {
      axiscount = 4;
    } else {
      axiscount = 3;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Top Up",
            style: TextStyle(color: isDark ? Colors.grey : Colors.white),
          ),
          iconTheme: IconThemeData(color: isDark ? Colors.grey : Colors.white),
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.1,
              ),
              Expanded(
                  child: GridView.count(
                      childAspectRatio: 4 / 5,
                      crossAxisCount: axiscount,
                      children: List.generate(
                        purchaseList.length,
                        (index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                    color: selected == purchaseList[index].cost
                                        ? Colors.orange
                                        : Colors.grey,
                                    width: selected == purchaseList[index].cost
                                        ? 2
                                        : 1)),
                            clipBehavior: Clip.antiAlias,
                            elevation: 2,
                            child: InkWell(
                              onTap: () async {
                                selected = purchaseList[index].cost;
                                credit = purchaseList[index].credit;
                                setState(() {});
                              },
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
                                              "${purchaseList[index].credit} cred",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: selected ==
                                                        purchaseList[index].cost
                                                    ? Colors.white
                                                    : Colors.grey,
                                              ),
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
                      ))),
              ElevatedButton(
                onPressed: () async {
                  if (selected != "") {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (content) => BillScreen(
                                  user: widget.user,
                                  totalprice: double.parse(selected),
                                  credit: credit,
                                ))).then((value) {});
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Please select a top-up option")));
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.white : Colors.orange),
                child: Text(
                  "Purchase",
                  style: TextStyle(
                      color: isDark ? Colors.black : Colors.white,
                      fontSize: 24),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.1,
              )
            ],
          ),
        ));
  }
}
