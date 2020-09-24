import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickblox_sdk/auth/module.dart';
import 'package:quickblox_sdk/models/qb_session.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:rohit_chat_app/Screens/Home/home_screen.dart';
import 'package:rohit_chat_app/Utils/credential.dart';

class LoginSingUpScreen extends StatefulWidget {
  @override
  _LoginSingUpScreenState createState() => _LoginSingUpScreenState();
}

class _LoginSingUpScreenState extends State<LoginSingUpScreen>
    with SingleTickerProviderStateMixin {
  var loginSignUpKey = GlobalKey<FormState>();
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  bool isChatConnected = false;

  QBLoginResult result;
  QBUser qbUser;
  QBSession qbSession;

  @override
  void initState() {
    super.initState();
    callInit();
  }

  callInit() async {
    try {
      await QB.settings.init(APP_ID, AUTH_KEY, AUTH_SECRET, ACCOUNT_KEY,
          apiEndpoint: API_ENDPOINT, chatEndpoint: CHAT_ENDPOINT);
    } on PlatformException {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Form(
              key: loginSignUpKey,
              child: Column(
                children: [
                  //userName TextField
                  TextFormField(
                    controller: usernameController,
                  ),
                  TextFormField(
                    controller: passwordController,
                  ),
                  RaisedButton(
                    onPressed: () async {
                      try {
                        print(
                            "userName::${usernameController.text.toString()} password::${passwordController.text}");
                        try {
                          qbSession = await QB.auth.getSession();
                        } on PlatformException catch (e) {
                          print(e);
                          // Some error occured, look at the exception message for more details
                        }
                        print("qbSession::${qbSession.token}");
                        result = await QB.auth.login(
                            usernameController.text, passwordController.text);
                        isChatConnected = await QB.chat.isConnected();
                        if (!isChatConnected) {
                          await QB.chat.connect(
                              result.qbUser.id, passwordController.text);
                        }
                        qbUser = result.qbUser;
                        qbSession = result.qbSession;
                        if (qbUser != null) {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen(
                                        qbUser: qbUser,
                                      )),
                              (route) => false);
                        }
                      } on PlatformException catch (e) {
                        print("Exception raised in Authentication::$e");
                        // Some error occurred, look at the exception message for more details
                      }
                    },
                    child: Text("Login"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
