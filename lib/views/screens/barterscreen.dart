import 'package:flutter/material.dart';
import 'package:barterit/models/user.dart';

class BarterTabScreen extends StatefulWidget {
  final User user;
  const BarterTabScreen({super.key, required this.user});

  @override
  State<BarterTabScreen> createState() => _BarterTabScreenState();
}

class _BarterTabScreenState extends State<BarterTabScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}