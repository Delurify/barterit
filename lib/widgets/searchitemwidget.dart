import 'package:flutter/material.dart';

class SearchItemWidget extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  late double screenHeight, screenWidth;

  SearchItemWidget(this.color, this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * 0.25,
      height: screenWidth * 0.25,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              color: Color.fromARGB(255, 214, 214, 214),
              width: 2.0,
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              icon,
              size: screenWidth * 0.1,
              color: color,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
