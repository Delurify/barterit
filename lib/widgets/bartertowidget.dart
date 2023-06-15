import 'package:flutter/material.dart';

class BarterToWidget extends StatefulWidget {
  final String text;
  bool isSelected;

  BarterToWidget(this.text, this.isSelected, {super.key});

  @override
  State<BarterToWidget> createState() => _BarterToWidgetState();
}

class _BarterToWidgetState extends State<BarterToWidget> {
  // We need to show the widget when it is not selected.
  late double screenWidth, screenHeight;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Visibility(
      visible: widget.isSelected ? false : true,
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
                      : const Color.fromARGB(255, 246, 232, 222)),
              onPressed: () {
                setState(() {
                  widget.isSelected = true;
                });
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(widget.text,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[700])),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
              onTap: () {
                setState(() {
                  widget.isSelected = true;
                });
              },
              child: const Icon(Icons.add_circle_outline)),
        ],
      ),
    );
  }
}
