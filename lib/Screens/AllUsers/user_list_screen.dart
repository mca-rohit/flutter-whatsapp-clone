import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_dialog.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:rohit_chat_app/Screens/ChatTab/chat_screen.dart';

class UsersList extends StatefulWidget {
  final String searchString;

  const UsersList({Key key, this.searchString}) : super(key: key);

  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  List<QBUser> qbUserList;
  List<QBUser> qbUserListforDisplay;
  QBDialog createdDialog;

  @override
  void initState() {
    getUsersList().then((value) {
      setState(() {
        qbUserList = value;
        for (int i = 0; i < qbUserList.length; i++) {
          if (qbUserList[i].id == 122430715) {
            qbUserList.removeAt(i);
          }
        }
        qbUserListforDisplay = qbUserList;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (qbUserList != null)
          ? ListView.builder(
              itemCount: qbUserListforDisplay.length + 1,
              itemBuilder: (BuildContext context, int index) {
                return index == 0 ? searchBar() : _listItems(index - 1);
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Future<List<QBUser>> getUsersList() async {
    List<QBUser> users;
    users = await QB.users.getUsers();
    // print(
    //     "userName::->${qbUserList[0].fullName} length::->${qbUserList.length}");
    /* qbUserList= qbUserList.where((element){
      var user=element.fullName.toString();
      return user.contains("test");
    }
    ).toList();*/
    return users;
  }

  searchBar() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextField(
        decoration: InputDecoration(
            hintText: "Search...", prefixIcon: Icon(Icons.search)),
        onChanged: (searchQuery) {
          setState(() {
            searchQuery = searchQuery.toLowerCase();
            qbUserListforDisplay = qbUserList.where((users) {
              var userFullName = users.fullName.toLowerCase();
              return userFullName.contains(searchQuery);
            }).toList();
          });
        },
      ),
    );
  }

  _listItems(int index) {
    return GestureDetector(
      onTap: () async {
        try {
          createdDialog = await QB.chat.createDialog(
              [qbUserListforDisplay[index].id], "Private Chat",
              dialogType: QBChatDialogTypes.CHAT);
          print("createDialog");
          print(createdDialog.id);
          print(createdDialog.userId);
          print(createdDialog.name);
          print(createdDialog.createdAt);
          print(createdDialog.customData);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (_) => ChatScreen(
                    dialog: createdDialog,
                  )));
        } on PlatformException catch (e) {
          // Some error occured, look at the exception message for more details
          print("Exception while creating dialog::$e");
        }

        //         // create Dialog

        //show all dialogs
        /*try {
          // int dialogs = await QB.chat.getDialogsCount();
          List<QBDialog> dialogList = await QB.chat.getDialogs();
          print(dialogList.length);
          for (int i = 0; i < dialogList.length; i++) {
            print(
                "dialog Name ::${dialogList[i].name}<-->dialogId::${dialogList[i].id}<--->dialogCreateUser::${dialogList[i].userId}");
          }
        } on PlatformException catch (e) {
          // Some error occured, look at the exception message for more details
        }*/

        // try {
        //   QBDialog createdDialog = await QB.chat.createDialog(
        //       [234234324, 3243243],
        //       "Private Chat",
        //       dialogType: QBChatDialogTypes.CHAT);
        // } on PlatformException catch (e) {
        //   // Some error occured, look at the exception message for more details
        // }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(2),
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
                radius: 25,
                backgroundImage: AssetImage("assets/images/contact.jpeg"),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.65,
              padding: EdgeInsets.only(
                left: 20,
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "${qbUserListforDisplay[index].fullName}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          /*Container(
                            margin: const EdgeInsets.only(left: 5),
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.orange,
                            ),
                          )*/
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
