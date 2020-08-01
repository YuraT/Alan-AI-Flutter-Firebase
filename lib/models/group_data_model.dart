import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class GroupDataModel {
  final DocumentReference ref;
  final String name;
  final List<DocumentReference> users;
  final List<DocumentReference> admins;

  GroupDataModel({this.ref, this.name, this.users, this.admins});

  String toJson() {
    return jsonEncode({
      "uid": this.ref.documentID,
      "name": this.name,
      "users": this.users.map((userRef) => userRef.documentID).toList(),
      "admins": this.admins.map((adminRef) => adminRef.documentID).toList(),
    });
  }
}