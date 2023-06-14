import 'package:flutter/material.dart';
import 'package:barterit/models/user.dart';

class BarterToScreen extends StatefulWidget {
  final User user;

  const BarterToScreen({super.key, required this.user});

  @override
  State<BarterToScreen> createState() => _BarterToScreenState();
}

class _BarterToScreenState extends State<BarterToScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
