import 'package:flutter/material.dart';

class BarterToSelectedWidget extends StatefulWidget {
  final String text;
  bool isSelected;
  final ValueChanged<bool> onSelectionChanged; //Callback function

  BarterToSelectedWidget(this.text, this.isSelected,
      {required Key key, required this.onSelectionChanged})
      : super(key: key);

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
          onDeleted: () {
            widget.onSelectionChanged(!widget.isSelected);
          }),
    );
  }
}
