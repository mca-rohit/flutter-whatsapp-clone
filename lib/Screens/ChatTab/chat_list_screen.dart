/*
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:rohit_chat_app/Utils/credential.dart';
import 'package:rohit_chat_app/models/user_model.dart';


class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  User testUser;

  @override
  void initState() {
    super.initState();
    callInit();
  }

  callInit() async {
    try {
      await QB.settings.init(APP_ID, AUTH_KEY, AUTH_SECRET, ACCOUNT_KEY,
          apiEndpoint: API_ENDPOINT, chatEndpoint: CHAT_ENDPOINT);
    } on PlatformException {
      // Some error occurred, look at the exception message for more details
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<QBUser>>(
        stream: QB.users.getUsers().asStream(),
        builder: (context, user) {
          if (user.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (user.hasData) {
            testUser = user as User;
          }
          return ListView.builder(
            itemCount: user.data.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        user: testUser,
                      ),
                    ),
                  );
                },
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage("assets/images/contact.jpeg"),
                ),
                trailing: Text("12/12/2020"),
                title: Text(
                  user.data[index].fullName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("details"),
              );
            },
          );
        },
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:quickblox_sdk/models/qb_dialog.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:rohit_chat_app/models/message_model.dart';

import 'chat_screen.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  List<QBDialog> dialogList;

  @override
  void initState() {
    fetchAllDialog().then((value) {
      setState(() {
        dialogList = value;
      });
    });
    super.initState();
  }

  Future<List<QBDialog>> fetchAllDialog() async {
    var dialogs = await QB.chat.getDialogs();
    // print(dialogs.length);
    return dialogs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body:
         (dialogList != null)
          ? ListView.builder(
              itemCount: dialogList.length,
              itemBuilder: (BuildContext context, int index) {
                final Message chat = chats[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        dialog: dialogList[index],
                      ),
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: chat.unread
                              ? BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40)),
                                  border: Border.all(
                                    width: 2,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  // shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                    ),
                                  ],
                                )
                              : BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundImage:
                                AssetImage("assets/images/contact.jpeg"),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.78,
                          padding: EdgeInsets.only(
                            left: 20,
                          ),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        dialogList[index].name,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      chat.sender.isOnline
                                          ? Container(
                                              margin: const EdgeInsets.only(
                                                  left: 5),
                                              width: 7,
                                              height: 7,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            )
                                          : Container(
                                              child: null,
                                            ),
                                    ],
                                  ),
                                  Text(
                                    "chat.time",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "chat.text",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              Divider(thickness:1,)
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
        );
  }
}
