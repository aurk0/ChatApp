import 'package:cloud_firestore/cloud_firestore.dart';

class Datastore {
  getUser(String email) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: email)
        .get();
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
