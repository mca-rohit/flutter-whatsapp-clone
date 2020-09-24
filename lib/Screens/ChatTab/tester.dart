/*
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:rohit_chat_app/Utils/credential.dart';

class ChatScreen extends StatefulWidget {
  final QBUser users;

  const ChatScreen({Key key, this.users}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  bool isType = false;
  final chatKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var textController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connectToChatServer();
  }
  connectToChatServer() async{
    try {
      await QB.chat.connect(LOGGED_USER_ID, USER_PASSWORD);
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        brightness: Brightness.dark,
        backgroundColor: Colors.green,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BackButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CircleAvatar(
              backgroundImage: AssetImage("assets/images/contact.jpeg"),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "${widget.users.fullName}",
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: Container(),
      bottomSheet: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: textController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      prefixIcon: IconButton(
                        icon: Icon(Icons.insert_emoticon),
                        onPressed: () {},
                      ),
                      hintText: "Enter"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 30,
                child: IconButton(
                  icon: Icon(Icons.keyboard_voice),
                  onPressed: () {},
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
*/
