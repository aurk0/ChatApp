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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Chat App"),
        backgroundColor: Colors.teal[700],
      ),
      body: WillPopScope(
        onWillPop: () {
          SystemNavigator.pop();
        },
        child: Form(
          key: _key,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                ),
                TextField(
                  controller: _emailcontroller1,
                  decoration: InputDecoration(
                    hintText: "Enter E-mail",
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  obscureText: true,
                  controller: _passcontroller1,
                  decoration: InputDecoration(
                    hintText: "Enter Password",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    width: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blueGrey[700]),
                    child: TextButton(
                        onPressed: () async {
                          if (_key.currentState.validate()) {
                            login();
                          }
                        },
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ))),
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
                          style: TextStyle(color: Colors.teal[700]),
                        ))
                  ],
                )
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
