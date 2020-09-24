import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_dialog.dart';
import 'package:quickblox_sdk/models/qb_message.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';

class ChatScreen extends StatefulWidget {
  final QBDialog dialog;

  ChatScreen({this.dialog});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<QBMessage> messageList;
  bool connectedServer = false;
  var messageBodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    connectServer().then((value) {
      setState(() {
        connectedServer = value;
      });
    });
    fetchChatHistory().then((value) {
      setState(() {
        messageList = value;
      });
    });
    subScribeChannel();
  }

  subScribeChannel() async {
    try {
      await QB.chat.subscribeChatEvent(QBChatEvents.RECEIVED_NEW_MESSAGE,
          (data) {
        Map<String, Object> map = new Map<String, dynamic>.from(data);
        String messageType = map["type"];
        if (messageType == QBChatEvents.RECEIVED_NEW_MESSAGE) {
          fetchChatHistory().then((value) {
            setState(() {
              messageList = value;
            });
          });
        }
        if (messageType == QBChatEvents.MESSAGE_DELIVERED) {
          fetchChatHistory().then((value) {
            setState(() {
              messageList = value;
            });
          });
        }
      });
    } on PlatformException catch (e) {
      print(e);
      // Some error occured, look at the exception message for more details
    }
  }

  _chatBubble(QBMessage message, bool isMe, bool isSameUser) {
    if (isMe) {
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                message.body,
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          !isSameUser
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      getTimeFormMillis(message.dateSent),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
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
                        radius: 15,
                        backgroundImage:
                            AssetImage("assets/images/contact.jpeg"),
                      ),
                    ),
                  ],
                )
              : Container(
                  child: null,
                ),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                message.body,
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          !isSameUser
              ? Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
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
                        radius: 15,
                        backgroundImage:
                            AssetImage("assets/images/contact.jpeg"),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      getTimeFormMillis(message.dateSent),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                )
              : Container(
                  child: null,
                ),
        ],
      );
    }
  }

  _sendMessageArea() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.white,
        ),
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo),
              iconSize: 25,
              color: Theme.of(context).primaryColor,
              onPressed: () async {},
            ),
            Expanded(
              child: TextField(
                controller: messageBodyController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Send a message..',
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              iconSize: 25,
              color: Theme.of(context).primaryColor,
              onPressed: () async {
                print("messageBody::${messageBodyController.text}");
                try {
                  await QB.chat.sendMessage(widget.dialog.id,
                      body: messageBodyController.text,
                      /*attachments: attachments,
                      properties: properties,*/
                      markable: false,
                      /*  dateSent: dateSent,*/
                      saveToHistory: true);
                  messageBodyController.clear();
                } on PlatformException catch (e) {
                  print("Exception while send message::$e");
                  // Some error occured, look at the exception message for more details
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> connectServer() async {
    try {
      bool connected = await QB.chat.isConnected();
      return connected;
    } on PlatformException catch (e) {
      print("Exception Checking connection status::$e");
      // Some error occured, look at the exception message for more details
    }
    return false;
  }

  Future<List<QBMessage>> fetchChatHistory() async {
    try {
      List<QBMessage> messages =
          await QB.chat.getDialogMessages(widget.dialog.id, markAsRead: true);
      //sorting dcsending order
      messages.sort((a, b) => b.dateSent.compareTo(a.dateSent));

      return messages;
    } on PlatformException catch (e) {
      print(e);
      // Some error occured, look at the exception message for more details
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    int prevUserId;
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                  text: "${widget.dialog.name}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
              TextSpan(text: '\n'),
              /* widget.user.isOnline
                  ? TextSpan(
                      text: 'Online',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  : */
              TextSpan(
                text: 'Offline',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/chat_background.jpg"),
                fit: BoxFit.cover),
            color: Colors.orange),
        child: Column(
          children: <Widget>[
            Expanded(
              child: (messageList != null)
                  ? ListView.builder(
                      reverse: true,
                      padding: EdgeInsets.all(20),
                      itemCount: messageList.length,
                      itemBuilder: (BuildContext context, int index) {
                        // final Message message = messages[index];
                        final bool isMe =
                            122430715 == messageList[index].senderId;
                        final bool isSameUser =
                            prevUserId == messageList[index].senderId;
                        prevUserId = messageList[index].senderId;
                        return _chatBubble(
                            messageList[index], isMe, isSameUser);
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
            _sendMessageArea(),
          ],
        ),
      ),
    );
  }

  String getTimeFormMillis(int dateSent) {
    DateTime date;
    if (dateSent > 0) {
      date = new DateTime.fromMillisecondsSinceEpoch(dateSent);
    }
    print("${date.hour}:${date.minute}");
    String formattedTime = DateFormat('hh:mm:a').format(date);
    return formattedTime;
  }
}
