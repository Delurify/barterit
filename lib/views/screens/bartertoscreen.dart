import 'package:flutter/material.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/widgets/bartertoselectedwidget.dart';
import 'package:barterit/widgets/bartertowidget.dart';

class BarterTo {
  int limit;
  bool electDevice;
  bool vehicle;
  bool furniture;
  bool bookStation;
  bool homeAppliance;
  bool fashionCosmetic;
  bool gameConsole;
  bool forChildren;
  bool musicalInstrument;
  bool sport;
  bool foodNutrition;
  bool other;

  BarterTo(
      {required this.limit,
      required this.electDevice,
      required this.vehicle,
      required this.furniture,
      required this.bookStation,
      required this.homeAppliance,
      required this.fashionCosmetic,
      required this.gameConsole,
      required this.forChildren,
      required this.musicalInstrument,
      required this.sport,
      required this.foodNutrition,
      required this.other});
}

class BarterToScreen extends StatefulWidget {
  final User user;

  const BarterToScreen({super.key, required this.user});

  @override
  State<BarterToScreen> createState() => _BarterToScreenState();
}

class _BarterToScreenState extends State<BarterToScreen> {
  late double screenHeight, screenWidth;
  BarterTo isSelected = BarterTo(
      limit: 5,
      electDevice: false,
      vehicle: false,
      furniture: false,
      bookStation: false,
      homeAppliance: false,
      fashionCosmetic: false,
      gameConsole: false,
      forChildren: false,
      musicalInstrument: false,
      sport: false,
      foodNutrition: false,
      other: false);

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
        body: Center(
            child: Column(
      children: [
        SizedBox(height: screenHeight * 0.07),
        Padding(
          padding: EdgeInsets.fromLTRB(
              screenWidth * 0.05, 0, screenWidth * 0.05, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Barter Category",
                  style: Theme.of(context).textTheme.titleLarge),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: isDark
                          ? Colors.white
                          : Theme.of(context).primaryColor),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "   Done   ",
                    style: isDark
                        ? TextStyle(color: Colors.grey[700])
                        : const TextStyle(color: Colors.white),
                  )),
            ],
          ),
        ),
        const Text("You can select up to 5 item categories! Add them up! 😎"),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          children: [
            Visibility(
              visible: isSelected.electDevice,
              child: Chip(
                  label: const Text("Electronic Devices"),
                  deleteIcon: Icon(Icons.cancel, color: Colors.red[600]),
                  onDeleted: () {
                    setState(() {
                      isSelected.electDevice = false;
                    });
                  }),
            ),
            Visibility(
              visible: isSelected.vehicle,
              child: Chip(
                  label: const Text("Vehicles"),
                  deleteIcon: Icon(Icons.cancel, color: Colors.red[600]),
                  onDeleted: () {
                    setState(() {
                      isSelected.vehicle = false;
                    });
                  }),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // BarterToWidget("Electronic Devices", isSelected.electDevice),
        Visibility(
          visible: isSelected.electDevice ? false : true,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: screenWidth * 0.7,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: isDark
                              ? Colors.grey[800]
                              : const Color.fromARGB(255, 246, 232, 222)),
                      onPressed: () {
                        setState(() {
                          isSelected.electDevice = true;
                        });
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Electronic Devices",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[700])),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          isSelected.electDevice = true;
                        });
                      },
                      child: const Icon(Icons.add_circle_outline)),
                ],
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),

        Visibility(
          visible: isSelected.vehicle ? false : true,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: screenWidth * 0.7,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: isDark
                              ? Colors.grey[800]
                              : Color.fromARGB(255, 246, 232, 222)),
                      onPressed: () {
                        setState(() {
                          isSelected.vehicle = true;
                        });
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Vehicles",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[700])),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const SizedBox(width: 10),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          isSelected.vehicle = true;
                        });
                      },
                      child: const Icon(Icons.add_circle_outline)),
                ],
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),

        Visibility(
          visible: isSelected.furniture ? false : true,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: screenWidth * 0.7,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: isDark
                              ? Colors.grey[800]
                              : Color.fromARGB(255, 246, 232, 222)),
                      onPressed: () {
                        setState(() {
                          isSelected.furniture = true;
                        });
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Furniture & Accessories",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[700])),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const SizedBox(width: 10),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          isSelected.furniture = true;
                        });
                      },
                      child: const Icon(Icons.add_circle_outline)),
                ],
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ],
    )));
  }
}
