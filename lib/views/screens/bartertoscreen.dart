import 'package:flutter/material.dart';
import 'package:barterit/models/user.dart';

class BarterToScreen extends StatefulWidget {
  final User user;

  const BarterToScreen({super.key, required this.user});

  @override
  State<BarterToScreen> createState() => _BarterToScreenState();
}

class _BarterToScreenState extends State<BarterToScreen> {
  late double screenHeight, screenWidth;

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
        Row(
          children: [
            Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: isDark ? Colors.grey : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10)),
                child: const Center(
                    child: Text("Electronic Devices",
                        style: TextStyle(fontWeight: FontWeight.bold))))
          ],
        ),
        const SizedBox(height: 20),
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
                onPressed: () {},
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Electronic Devices",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[700])),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
                onTap: () {}, child: const Icon(Icons.add_circle_outline)),
          ],
        ),
        const SizedBox(height: 5),
        Visibility(
          visible: true,
          child: Row(
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
                  onPressed: () {},
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Vehicles",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey[700])),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                  onTap: () {}, child: const Icon(Icons.add_circle_outline)),
            ],
          ),
        ),
      ],
    )));
  }
}
