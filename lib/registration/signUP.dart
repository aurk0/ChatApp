import 'package:chat_app/registration/datastore.dart';
import 'package:chat_app/registration/signIN.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUP extends StatefulWidget {
  @override
  _SignUPState createState() => _SignUPState();
}

class _SignUPState extends State<SignUP> {
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
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignIn()));
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
                            regAccount();
                          }
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Have an account?'),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignIn()));
                        },
                        child: Text("Sign In"))
                  ],
                )
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

      Map<String, String> userDataMap = {"userEmail": _emailcontroller1.text};
      datastore.addUserInfo(userDataMap);
      print('Sign Up Successful');
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignIn()));
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
