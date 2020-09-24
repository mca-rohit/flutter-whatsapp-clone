import 'package:flutter/material.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:rohit_chat_app/Screens/AllUsers/user_list_screen.dart';
import 'package:rohit_chat_app/Screens/ChatTab/chat_list_screen.dart';
import 'constant.dart';

class HomeScreen extends StatefulWidget {
  final QBUser qbUser;

  const HomeScreen({Key key, this.qbUser}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  Widget appBarTitle = Padding(
    padding: const EdgeInsets.only(left: 12.0),
    child: Text("WhatsApp"),
  );
  Icon actionIcon = new Icon(Icons.search);

  @override
  void initState() {
    super.initState();
    getAllChats();
    tabController = TabController(length: 4, vsync: this);
  }

  getAllChats() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: false,
        elevation: 0,
        actions: <Widget>[
          IconButton(
              icon: actionIcon,
              onPressed: () {
                setState(() {
                  if (this.actionIcon.icon == Icons.search) {
                    this.actionIcon = new Icon(Icons.close);
                    this.appBarTitle = new TextField(
                      style: new TextStyle(
                        color: Colors.white,
                      ),
                      decoration: new InputDecoration(
                          prefixIcon:
                              new Icon(Icons.search, color: Colors.white),
                          hintText: "Search...",
                          hintStyle: new TextStyle(color: Colors.white)),
                    );
                  } else {
                    this.actionIcon = new Icon(Icons.search);
                    this.appBarTitle = new Text("WhatsApp");
                  }
                });
              }),
          PopupMenuButton<String>(
            onSelected: choiceAction,
            icon: Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) {
              return MenuConstants.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
        bottom: TabBar(
          controller: tabController,
          // isScrollable: true,
          // indicatorSize:TabBarIndicatorSize.label,
          indicator: UnderlineTabIndicator(
              insets: EdgeInsets.symmetric(horizontal: 1.0)),
          tabs: [
            Tab(
              child: Icon(Icons.camera_alt),
            ),
            Tab(
              child: Text("CHATS"),
            ),
            Tab(
              child: Text("STATUS"),
            ),
            Tab(
              child: Text("CALLS"),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          Container(child: Center(child: Text("camera"))),
          Container(child: ChatList()),
          Container(child: Center(child: Text("status"))),
          Container(child: Center(child: Text("calls"))),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => UsersList())),
        /* onPressed: ()async{
          try {
            List<QBDialog> dialogs = await QB.chat.getDialogs(
               */ /* sort: qbSort,
                filter: qbFilter,
                limit: limit,
                skip: skip*/ /*);
            print(dialogs);
          } on PlatformException catch (e) {
            // Some error occurred, look at the exception message for more details
          }
        },*/
        child: Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ),
    );
  }

  void choiceAction(String choice) {
    if (choice == MenuConstants.newGroup) {
      print('New Group');
    } else if (choice == MenuConstants.newBroadcast) {
      print('New Broadcast');
    } else if (choice == MenuConstants.whatsAppWeb) {
      print('WhatsApp web');
    } else if (choice == MenuConstants.settings) {
      print('Settings');
    }
  }
}
