import 'package:flutter/material.dart';
import 'package:barterit/models/user.dart';

class SearchTabScreen extends StatefulWidget {
  final User user;
  const SearchTabScreen({super.key, required this.user});

  @override
  State<SearchTabScreen> createState() => _SearchTabScreenState();
}

class _SearchTabScreenState extends State<SearchTabScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
