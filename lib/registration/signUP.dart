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
      body: Form(
        key: _key,
        child: WillPopScope(
          onWillPop: () {
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignIn()));
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
                        "Registration",
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
                                  regAccount();
                                }
                              },
                              child: Text(
                                "Sign Up",
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
                          Text('Have an account?'),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignIn()));
                              },
                              child: Text(
                                "Sign In",
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
