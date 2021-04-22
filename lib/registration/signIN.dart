import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController mail = new TextEditingController();
  TextEditingController pass = new TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat App"),
        backgroundColor: Colors.teal[700],
      ),
      body: Container(
        child: Center(
          child: Form(
            key: _key,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: mail,
                    decoration: InputDecoration(
                      hintText: "Enter E-mail",
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: pass,
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
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ))),
                  Divider(
                    height: 60,
                    color: Colors.black,
                  ),
                  TextField(
                    controller: mail,
                    decoration: InputDecoration(
                      hintText: "Enter E-mail",
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: pass,
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
                          onPressed: () {},
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void regAccount() async {
    Future signUpWithEmailAndPassword(String email, String password) async {
      try {
        final User user = (await auth.createUserWithEmailAndPassword(
                email: mail.text, password: pass.text))
            .user;
        print('Sign Up Successful');
      } catch (e) {
        print(e.toString());
        return null;
      }
    }
  }
}
