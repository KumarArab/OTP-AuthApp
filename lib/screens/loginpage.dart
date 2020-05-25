import 'package:authapp/screens/homepage.dart';
import 'package:authapp/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nice_button/nice_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String verificationId;
  String code;
      TextEditingController _phoneNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {

    var firstColor = Color(0xff5b86e5), secondColor = Color(0xff36d1dc);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome Back!",
                  style: TextStyle(
                      fontSize: 40.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 50.0,
                ),
                TextField(
                  autofocus: true,
                  controller: _phoneNumber,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Enter your Phone Number",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40.0))),
                    prefixText: "+91 ",
                    prefixStyle: TextStyle(color: Colors.white, fontSize: 17.0),
                  ),
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                ),
                SizedBox(
                  height: 50.0,
                ),
                NiceButton(
                  width: double.infinity,
                  radius: 40,
                  padding: const EdgeInsets.all(15),
                  text: "Login",
                  background: null,
                  gradientColors: [secondColor, firstColor],
                  onPressed: () {
                    final String phone = '+91' + _phoneNumber.text;
                    initLogin(phone, context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> initLogin(String phone, BuildContext context) async {
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 5),
        verificationCompleted: (AuthCredential credential) {
          _firebaseAuth.signInWithCredential(credential).then((value) async {
            final FirebaseUser currentUser = await _firebaseAuth.currentUser();
            if (value.user.uid == currentUser.uid) {
                  Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return HomePage(username: currentUser.phoneNumber.toString());
                },
              ),
            );
            } else {
              print("Not registered yet");
            }
          });
        },
        verificationFailed: (AuthException exception) {
          showDialog(context: context,builder: (context){
            return AlertDialog(title: Text("Please Enter correct mobile number!"),actions: [FlatButton(onPressed: (){
              Navigator.pop(context);
                  setState(() {
                    _phoneNumber.text = "";
                  });
            }, child: Text("OK"))],);
          });
        },
        codeSent: (String verificationID, [int forceResending]) {
          showDialog(context: context,builder: (context){
            return AlertDialog(title: Text("You are not signed up yet !"),actions: [FlatButton(onPressed: (){
                    Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return SignUpPage();
                },
              ),
            );
            }, child: Text("Signup"))],);
          });
          this.verificationId = verificationID;
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          this.verificationId = verificationID;
        });
  }
}
