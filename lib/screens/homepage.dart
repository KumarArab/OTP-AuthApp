import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String username;

  HomePage({this.username});
  @override
  Widget build(BuildContext context) {
    var firstColor = Color(0xff5b86e5), secondColor = Color(0xff36d1dc);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
            child: Text(
          "Hello $username",
          style: TextStyle(
              color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.bold),
        )),
      ),
    );
  }
}
