import 'package:flutter/material.dart';

import '../../models/user.dart';

class SearchScreen extends StatefulWidget {
  final User user;
  final String search;

  const SearchScreen({super.key, required this.user, required this.search});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late double screenWidth, screenHeight;
  final TextEditingController _searchEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    _searchEditingController.text = widget.search;
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Container(
            decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            width: double.infinity,
            height: 40,
            child: Center(
              child: TextField(
                controller: _searchEditingController,
                
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search for something',
                    prefixIcon: Icon(Icons.search)),
                onSubmitted: (v) {
                  print("Hello");
                },
              ),
            ),
          ),
        )
      ],
    ));
  }
}
