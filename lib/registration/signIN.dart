import 'package:chat_app/chat/chatroom.dart';
import 'package:chat_app/registration/datastore.dart';
import 'package:chat_app/registration/signUP.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _emailcontroller1 = new TextEditingController();
  TextEditingController _passcontroller1 = new TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  Datastore datastore = new Datastore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _key,
        child: WillPopScope(
          onWillPop: () {
            SystemNavigator.pop();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.deepOrange[900],
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(50),
                          bottomLeft: Radius.circular(50))),
                  width: double.infinity,
                  height: 150,
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "CHAT APP",
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Log In",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
                ),
                SizedBox(
                  height: 70,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 35,
                      ),
                      TextField(
                        style: TextStyle(
                            fontWeight: FontWeight.bold, letterSpacing: 2),
                        controller: _emailcontroller1,
                        decoration: InputDecoration(
                            hintText: "Enter E-mail",
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.orange[900]))),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        style: TextStyle(
                            fontWeight: FontWeight.bold, letterSpacing: 2),
                        obscureText: true,
                        controller: _passcontroller1,
                        decoration: InputDecoration(
                            hintText: "Enter Password",
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.orange[900]))),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Container(
                          width: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.orange[900]),
                          child: TextButton(
                              onPressed: () async {
                                if (_key.currentState.validate()) {
                                  login();
                                }
                              },
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                    letterSpacing: 1,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ))),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?"),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUP()));
                              },
                              child: Text(
                                "Sign Up",
                                style: TextStyle(color: Colors.deepOrange[900]),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login() async {
    try {
      final User user = (await auth.signInWithEmailAndPassword(
        email: _emailcontroller1.text,
        password: _passcontroller1.text,
      ))
          .user;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', _emailcontroller1.text);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ChatRoom()));
      print('Login Successful');
    } catch (e) {
      print(e);
    }
  }
}
