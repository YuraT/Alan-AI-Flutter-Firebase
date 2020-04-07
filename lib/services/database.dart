import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project1/models/group_data_model.dart';
import 'package:project1/models/user.dart';
import 'package:project1/models/user_data_model.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection references
  final CollectionReference usersCollection = Firestore.instance.collection("users");
  final CollectionReference groupsCollection = Firestore.instance.collection("groups");
  //final CollectionReference usernamesCollection = Firestore.instance.collection("usernames");
  // the usernames collection was going to be used to have login with username, but I didn't get around to it

  Future updateUserData(String firstName, String lastName, String username) async {
    return await usersCollection.document(uid).setData( {
      "firstName" : firstName,
      "lastName" : lastName,
      "username" : username,
    });
  }

  // user data model list from snapshot
  List<UserDataModel> _usersDataListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return UserDataModel(
        uid: doc.documentID ?? '',
        firstName: doc.data["firstName"] ?? '',
        lastName: doc.data["lastName"] ?? '',
        username: doc.data["username"] ?? '',
        );
    }).toList();
  }

  // get collection stream
  Stream<List<UserDataModel>> get users {
    return usersCollection.snapshots().map(_usersDataListFromSnapshot);
  }

  // group data model list from snsapshots (all groups)
  List<GroupDataModel> _groupsDataListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return GroupDataModel(
        name: doc.data["name"],
        users: List.from(doc.data["users"]),
        admins: List.from(doc.data["admins"]),
      );
    }).toList();
  }
  
  // get collection stream for group collection
  Stream<List<GroupDataModel>> get groups {
    return groupsCollection.where("users", arrayContains: uid).snapshots().map(_groupsDataListFromSnapshot);
  }

  // currentUserData from snapshot
  CurrentUserData _currentUserDataFromSnapshot(DocumentSnapshot snapshot) {
    //print("tasks reference:   " + snapshot.data["tasks"]); // doesn't work yet
    return CurrentUserData(
      uid: uid,
      //tasks: _tasksListFromSnapshot(snapshot), // doesn't work yet either
      tasks: [Task(name: "task1", description: "desc1", time: 100), Task(name: "task2", description: "desc2", time: 143)].toList(),
      firstName: snapshot.data["firstName"],
      lastName: snapshot.data["lastName"],
      username: snapshot.data["username"]
    );
  }

  // All of this tasks junk doesn't work yet, probably because I'm dumb
  List<Task> _tasksListFromSnapshot(DocumentSnapshot snapshot) {
    return snapshot.data["tasks"].forEach((task) {
      return Task(
        name: task.name,
        description: task.description,
        time: task.time
        );
    }).toList();
  }

  Stream<CurrentUserData> get currentUserData {
    return usersCollection.document(uid).snapshots().map(_currentUserDataFromSnapshot);
  }
}