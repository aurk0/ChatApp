import 'dart:io';

import 'package:chat_app/chat/chatroom.dart';
import 'package:chat_app/registration/datastore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class ChatFinal extends StatefulWidget {
  final String barMail;
  ChatFinal(this.barMail);
  @override
  _ChatFinalState createState() => _ChatFinalState();
}

class _ChatFinalState extends State<ChatFinal> {
  final user = FirebaseAuth.instance.currentUser;
  TextEditingController textController = new TextEditingController();

  String chatroomID, textID;
  Stream textStream;
  String textType = "";

  //for emoji methods
  bool emojiPicker = false;
  bool isSelected = false;
  keyboardVisible() {}

  keyboardHide() {
    final textFocus = FocusScope.of(context);
    if (!textFocus.hasPrimaryFocus) textFocus.unfocus();
  }

  hideEmoji() {
    setState(() {
      emojiPicker = false;
    });
  }

  viewEmoji() {
    setState(() {
      emojiPicker = true;
    });
  }

  getInfo() async {
    chatroomID = getchatroomID(widget.barMail, user.email);
  }

  getchatroomID(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  addText(bool sendClicked) {
    if (textController.text != "") {
      String texts = textController.text;
      var lastTexttime = DateTime.now();

      Map<String, dynamic> textInfo = {
        "texts": texts,
        "sender": user.email,
        "timeStand": lastTexttime
      };
      if (textID == "") {
        textID = randomAlphaNumeric(12);
      }
      Datastore().addTextsFirebase(chatroomID, textID, textInfo).then((value) {
        Map<String, dynamic> lastTextInfo = {
          "lastText": texts,
          "lastTextTime": lastTexttime,
          "lastTextSender": user.email
        };
        Datastore().updateLastSendText(chatroomID, lastTextInfo);
        if (sendClicked) {
          textController.text = "";
          textID = "";
        }
      });
    }
  }

  getsetTexts() async {
    textStream = await Datastore().getTexts(chatroomID);
    setState(() {});
  }

  appStarts() async {
    await getInfo();
    getsetTexts();
  }

  @override
  void initState() {
    appStarts();
    super.initState();
  }

  Widget textTile(String texts, bool sendByMe) {
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          decoration: BoxDecoration(
              color: sendByMe ? Colors.teal[700] : Colors.grey[700],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                  bottomLeft:
                      sendByMe ? Radius.circular(25) : Radius.circular(0),
                  bottomRight:
                      sendByMe ? Radius.circular(0) : Radius.circular(25))),
          padding: EdgeInsets.all(10),
          child: Text(
            texts,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget showTexts() {
    return StreamBuilder(
        stream: textStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.only(bottom: 70, top: 15),
                  reverse: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return textTile(ds["texts"], user.email == ds["sender"]);
                  })
              : Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.teal[700],
                  ),
                );
        });
  }

  Widget typeChat() {
    return Container(
      color: Colors.teal[700],
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Row(
          children: [
            IconButton(icon: Icon(Icons.photo), onPressed: () {}),
            IconButton(
                icon: Icon(Icons.emoji_emotions),
                onPressed: () {
                  setState(() {
                    viewEmoji();
                    keyboardHide();
                    print("workinggggggggggggggggggggggggggggg");
                  });
                }),
            Expanded(
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: textController,
                decoration: InputDecoration(
                  hintText: "type your text",
                ),
              ),
            ),
            IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  addText(true);
                })
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChatRoom()));
              }),
          title: Text(widget.barMail),
          backgroundColor: Colors.teal[700]),
      body: WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        },
        child: Stack(
          children: [
            showTexts(),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(child: typeChat()),
                emojiPicker
                    ? EmojiPicker(
                        bgColor: Colors.teal[700],
                        indicatorColor: Colors.teal[900],
                        rows: 3,
                        columns: 7,
                        onEmojiSelected: (emoji, category) {
                          setState(() {
                            isSelected = true;
                          });
                          textController.text =
                              textController.text + emoji.emoji;
                        },
                      )
                    : Container()
              ],
            )
          ],
        ),
      ),
    );
  }

  // Future<void> imagetoFirebase(cropPhoto) async {
  //   String takeImage = '';
  // }
}
