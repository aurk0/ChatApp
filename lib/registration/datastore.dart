import 'package:cloud_firestore/cloud_firestore.dart';

class Datastore {
  getUser(String email) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: email)
        .get();
  }

  Future<bool> addChatRoom(chatRoom, chatRoomId) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  Future<void> addUserInfo(userData) async {
    FirebaseFirestore.instance
        .collection("users")
        .add(userData)
        .catchError((e) {
      print(e.toString());
    });
  }
}
