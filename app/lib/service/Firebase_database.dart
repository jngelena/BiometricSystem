import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseMethods {
  CollectionReference users = FirebaseFirestore.instance.collection("users");

  Future<void> addUsers(Map<String, String> userInfo) {
    return users.add(userInfo);
  }
}
