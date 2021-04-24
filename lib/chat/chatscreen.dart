import 'package:flutter/material.dart';

class ChatFinal extends StatefulWidget {
  final String barName;
  ChatFinal(this.barName);
  @override
  _ChatFinalState createState() => _ChatFinalState();
}

class _ChatFinalState extends State<ChatFinal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.barName), backgroundColor: Colors.teal[700]),
    );
  }
}
