import 'package:cloud_firestore/cloud_firestore.dart';

class TaskDataModel {
  final DocumentReference ref;
  final String title;
  final String description;
  final DocumentReference group;
  final DocumentReference assigner;
  final List<DocumentReference> users;
  final DateTime deadline;
  final bool completedStatus;

  TaskDataModel({this.ref, this.title, this.description, this.group, this.assigner, this.users, this.deadline, this.completedStatus});
  
  Map toJson() {
    return {
      "uid": this.ref.documentID,
      "title": this.title,
      "description": this.description,
      "group": this.group.documentID,
      "assigner": this.assigner.documentID,
      "users": this.users.map((user) => user.documentID).toList(),
      "deadline": this.deadline.millisecondsSinceEpoch,
      "completedStatus": this.completedStatus,
    };
  }
}