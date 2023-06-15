import 'package:flutter/material.dart';

class BarterToSelectedWidget extends StatefulWidget {
  final String text;
  bool isSelected;

  BarterToSelectedWidget(this.text, this.isSelected, {super.key});

  @override
  State<BarterToSelectedWidget> createState() => _BarterToSelectedWidgetState();
}

class _BarterToSelectedWidgetState extends State<BarterToSelectedWidget> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isSelected,
      child: Chip(
          label: Text(widget.text),
          deleteIcon: const Icon(Icons.cancel),
          onDeleted: () {}),
    );
  }
}
