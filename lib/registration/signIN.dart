import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat App"),
        backgroundColor: Colors.teal[700],
      ),
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: "Enter E-mail",
                  ),
                ),
                SizedBox(height: 10),
                TextField(
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
                          "Sign Up",
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
}
