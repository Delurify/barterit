import 'dart:convert';

import 'package:flutter/material.dart';

import '../../models/item.dart';
import '../../models/user.dart';
import '../../myconfig.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  final User user;
  final String search;

  const SearchScreen({super.key, required this.user, required this.search});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late double screenWidth, screenHeight;
  late Item singleItem;
  late final TabController _tabController =
      TabController(length: 2, vsync: this);
  List<Item> itemList = <Item>[];
  List<Item> newItems = <Item>[];
  int offset = 0;
  int limit = 10;
  bool firstLoad = true;
  bool isLoading = false;
  bool hasMore = true;

  final TextEditingController _searchEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    _searchEditingController.text = widget.search;
    searchitems(widget.search);
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          pinned: true,
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
          bottom: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              tabs: const [
                Tab(text: 'Items'),
                Tab(
                  text: 'People',
                )
              ]),

          
        )
      ],
    ));
  }

  void searchitems(String search) {
    if (isLoading) return;
    isLoading = true;

    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/load_items.php"),
        body: {
          "search": search,
          "offset": offset.toString(),
          "limit": limit.toString(),
        }).then((response) {
      offset = offset + limit;
      newItems.clear();
      if (firstLoad) {
        itemList.clear();
        firstLoad = false;
      }

      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        var extractdata = jsondata['data'];
        extractdata['items'].forEach((v) {
          singleItem = Item.fromJson(v);
          newItems.add(singleItem);
        });
        newItems.shuffle();
        itemList.addAll(newItems);
      }

      setState(() {
        isLoading = false;

        if (newItems.length < limit) {
          hasMore = false;
        }
      });
    });
  }
}
