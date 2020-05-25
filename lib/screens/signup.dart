import 'package:authapp/screens/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nice_button/nice_button.dart';
import 'dart:async';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _code = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  String verificationId;

  Future<void> signUpUser(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 10),
        verificationCompleted: (AuthCredential credential) async {
          AuthResult result = await _auth.signInWithCredential(credential);
          FirebaseUser user = result.user;

          if (user != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return HomePage(username: user.toString());
                },
              ),
            );
          }
        },
        verificationFailed: (AuthException exception) {
           showDialog(context: context,builder: (context){
            return AlertDialog(title: Text("Sign Up Failed!\nPlease Enter correct mobile number!"),actions: [FlatButton(onPressed: (){
              Navigator.pop(context);
                  setState(() {
                    _phoneNumber.text = "";
                  });
            }, child: Text("OK"))],);
          });
        },
        codeSent: (String verificationID, [int forceRespondingToken]) async {
          AuthCredential credential = PhoneAuthProvider.getCredential(
              verificationId: verificationID, smsCode: _code.text.trim());
          AuthResult result = await _auth.signInWithCredential(credential);

          FirebaseUser user = result.user;
          if (user != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return HomePage(username: user.phoneNumber);
                },
              ),
            );
          }
        },
        codeAutoRetrievalTimeout: (String verificaitonID) {
          this.verificationId = verificaitonID;
        });
  }

  @override
  Widget build(BuildContext context) {
    var firstColor = Color(0xff5b86e5), secondColor = Color(0xff36d1dc);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome",
              style: TextStyle(
                  fontSize: 40.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 50,
            ),
            Column(
              children: [
                TextField(
                  controller: _phoneNumber,
                  autofocus: true,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Enter you phone number",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40.0))),
                    prefixText: '+91 ',
                    prefixStyle: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                ),
                 TextField(
                  controller: _name,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Enter you Name",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40.0))),
                    prefixText: '+91 ',
                    prefixStyle: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                ),
                 TextField(
                  controller: _email,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Enter you Email",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40.0))),
                    prefixText: '+91 ',
                    prefixStyle: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            NiceButton(
              width: double.infinity,
              radius: 40,
              padding: const EdgeInsets.all(15),
              text: "Register",
              background: null,
              gradientColors: [secondColor, firstColor],
              onPressed: () {
                if(_name.text != "" && _email.text != "" && _phoneNumber.text != ""){
                  final String phone = '+91' + _phoneNumber.text;
                  signUpUser(phone, context);
                }
                else{
                   showDialog(context: context,builder: (context){
            return AlertDialog(title: Text("Please fill all the fields!"),actions: [FlatButton(onPressed: (){
              Navigator.pop(context);
                  setState(() {
                    _phoneNumber.text = "";
                    _name.text = "";
                    _email.text = "";
                  });
            }, child: Text("OK"))],);
          });
                }
                
              },
            ),
          ],
        )),
      ),
    );
  }
}
