import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:barterit/models/barter.dart';
import 'package:barterit/models/message.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final User user;
  final Barter barter;
  const ChatScreen({super.key, required this.user, required this.barter});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late double screenWidth, screenHeight;
  final df = DateFormat('yyyy-MM-dd HH:mm:ss.SSSSSS');
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _messageEditingController =
      TextEditingController();
  List<Message> messages = [];
  User otherUser = User();

  @override
  void initState() {
    super.initState();
    loadtrader();
    loadmessages();
  }

  @override
  void dispose() {
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(otherUser.name.toString()),
      ),
      body: GestureDetector(
        onTap: () {
          // Remove focus when tapping outside of the text field
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(children: [
          Expanded(
              child: GroupedListView<Message, DateTime>(
            padding: const EdgeInsets.all(8),
            reverse: true,
            order: GroupedListOrder.DESC,
            useStickyGroupSeparators: true,
            floatingHeader: true,
            elements: messages,
            groupBy: (message) => DateTime(
              df.parse(message.date.toString()).year,
              df.parse(message.date.toString()).month,
              df.parse(message.date.toString()).day,
            ),
            groupHeaderBuilder: (Message message) => SizedBox(
                height: 40,
                child: Center(
                  child: Card(
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                          DateFormat.yMMMd()
                              .format(df.parse(message.date.toString())),
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                )),
            itemBuilder: (context, Message message) => Align(
              alignment: message.sentBy == widget.user.id
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Card(
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(message.text.toString()),
                ),
              ),
            ),
          )),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                child: Container(
                  width: screenWidth * 0.75,
                  decoration: BoxDecoration(
                      color: isDark && !_focusNode.hasFocus
                          ? Colors.grey[900]
                          : isDark && _focusNode.hasFocus
                              ? Colors.grey[800]
                              : !isDark && !_focusNode.hasFocus
                                  ? const Color.fromARGB(255, 255, 185, 79)
                                  : Colors.white,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: TextField(
                    controller: _messageEditingController,
                    focusNode: _focusNode,
                    style: TextStyle(
                        color: _focusNode.hasFocus && !isDark
                            ? Colors.black
                            : !_focusNode.hasFocus && !isDark
                                ? Colors.grey[700]
                                : _focusNode.hasFocus && isDark
                                    ? Colors.white
                                    : Colors.grey),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(12),
                        hintText: '\tType your message here...'),
                    onSubmitted: (text) {
                      if (text != "") {
                        final message = Message(
                          barterid: widget.barter.barterid,
                          text: text,
                          date: DateTime.now().toString(),
                          sentBy: widget.user.id.toString(),
                          sentTo: widget.barter.takeuserid,
                        );
                        _messageEditingController.clear();
                        setState(
                          () => messages.add(message),
                        );
                      }
                    },
                  ),
                ),
              ),
              RawMaterialButton(
                onPressed: () {
                  if (_messageEditingController.text != "") {
                    final message = Message(
                      barterid: widget.barter.barterid,
                      text: _messageEditingController.text,
                      date: DateTime.now().toString(),
                      sentBy: widget.user.id.toString(),
                      sentTo: widget.barter.takeuserid,
                    );
                    _messageEditingController.clear();

                    setState(
                      () => messages.add(message),
                    );
                  }
                },
                elevation: 10,
                fillColor: isDark ? Colors.grey[700] : Colors.orange,
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                shape: const CircleBorder(),
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Icon(
                    Icons.send,
                    size: 20.0,
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  void loadmessages() {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/load_messages.php"),
        body: {
          "barterid": widget.barter.barterid,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        var extractdata = jsondata['data'];
        extractdata['messages'].forEach((v) {
          messages.add(Message.fromJson(v));
        });
      }
      setState(() {});
    });
  }

  void loadtrader() {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/login_user.php"),
        body: {
          "user_id": widget.barter.takeuserid,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        otherUser = User.fromJson(jsondata['data']);
      }
      setState(() {});
    });
  }
}
