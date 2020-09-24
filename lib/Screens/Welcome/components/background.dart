import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(alignment: Alignment.center, children: [
        Image.asset("assets/images/welcome.png"),
        child,
      ]),
    );
  }
}
