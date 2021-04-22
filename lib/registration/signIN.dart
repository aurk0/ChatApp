import 'package:chat_app/chatroom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _emailcontroller1 = new TextEditingController();
  TextEditingController _passcontroller1 = new TextEditingController();
  TextEditingController _emailcontroller2 = new TextEditingController();
  TextEditingController _passcontroller2 = new TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat App"),
        backgroundColor: Colors.teal[700],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
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
                            regAccount();
                          }
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ))),
                Divider(
                  height: 60,
                  color: Colors.black,
                ),
                TextField(
                  controller: _emailcontroller2,
                  decoration: InputDecoration(
                    hintText: "Enter E-mail",
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  obscureText: true,
                  controller: _passcontroller2,
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
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void regAccount() async {
    try {
      final User user = (await auth.createUserWithEmailAndPassword(
              email: _emailcontroller1.text, password: _passcontroller1.text))
          .user;
      print('Sign Up Successful');
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  void login() async {
    try {
      final User user = (await auth.signInWithEmailAndPassword(
        email: _emailcontroller2.text,
        password: _passcontroller2.text,
      ))
          .user;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ChatRoom()));
      print('Login Successful');
    } catch (e) {
      print(e);
    }
  }
}
