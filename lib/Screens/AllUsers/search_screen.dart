/*
import 'package:flutter/material.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:rohit_chat_app/Screens/AllUsers/user_list_screen.dart';
class UsersSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) => [

  ];
  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: Icon(Icons.close),
        onPressed: () => Navigator.of(context).pop(),
      );

  @override
  Widget buildResults(BuildContext context) => Text('Result');

  @override
  Widget buildSuggestions(BuildContext context) {
    return UsersList();
  }
}
class SearchUser extends StatefulWidget {
  @override
  _SearchUserState createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  List<QBUser> qbUserList;
  int userCount = 0;
  @override
  void initState() {
    super.initState();
    getUsersList();
  }
  Future<List<QBUser>> getUsersList() async {
    qbUserList = await QB.users.getUsers();
    userCount = qbUserList.length;
    print(
        "userName::->${qbUserList[0].fullName} length::->${qbUserList.length}");
    return qbUserList;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text("Users"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
              onPressed: () => showSearch(
                context: context,
                delegate: UsersSearchDelegate(),
              ),
          ),
        ],
      ),
      body: UsersList(),
    );
  }

}

*/
