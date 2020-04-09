import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project1/models/group_data_model.dart';
import 'package:project1/models/user.dart';
import 'package:project1/models/user_data_model.dart';

class DatabaseService {
  final String uid;
  final String group;
  DatabaseService({this.uid, this.group});

  // collection references
  final CollectionReference usersCollection = Firestore.instance.collection("users");
  final CollectionReference groupsCollection = Firestore.instance.collection("groups");
  final CollectionReference tasksCollection = Firestore.instance.collection("tasks");
  //final CollectionReference usernamesCollection = Firestore.instance.collection("usernames");
  // the usernames collection above was going to be used to have login with username, but I didn't get around to it

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

  // group data model list from snsapshots
  List<GroupDataModel> _groupsDataListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return GroupDataModel(
        uid: doc.documentID,
        name: doc.data["name"],
        users: List.from(doc.data["users"]),
        admins: List.from(doc.data["admins"]),
      );
    }).toList();
  }
  // get collection stream for group collection
  Stream<List<GroupDataModel>> get groups {
    // its good to know that if uid == null, the where method just wont do anything
    return groupsCollection.where("users", arrayContains: uid).snapshots().map(_groupsDataListFromSnapshot);
  }

  // All of this tasks junk doesn't work yet, probably because I'm dumb
  // alright now all I should have to do is copy the stuff for groups above and change it for tasks
  List<TaskDataModel> _tasksListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return TaskDataModel(
        title: doc.data["title"],
        description: doc.data["description"],
        assigner: doc.data["assigner"],
        users: List.from(doc.data["users"]),
        deadline: DateTime.utc(2020, 4, 26, 14, 0),//doc.data["deadline"],
        completedStatus: doc.data["completedStatus"],
      );
    }).toList();
  }
  Stream<List<TaskDataModel>> get tasks {
    return tasksCollection.where("group", isEqualTo: group).snapshots().map(_tasksListFromSnapshot);
  }

  // currentUserData from snapshot
  CurrentUserData _currentUserDataFromSnapshot(DocumentSnapshot snapshot) {
    //print("tasks reference:   " + snapshot.data["tasks"]); // doesn't work yet
    return CurrentUserData(
      uid: uid,
      //tasks: _tasksListFromSnapshot(snapshot), // doesn't work yet either
      tasks: [TaskDataModel(title: "task1", description: "desc1", deadline: DateTime.utc(2020, 4, 26, 14, 0)), TaskDataModel(title: "task2", description: "desc2", deadline: DateTime.utc(2020, 4, 19, 14, 0))],
      firstName: snapshot.data["firstName"],
      lastName: snapshot.data["lastName"],
      username: snapshot.data["username"]
    );
  }
  Stream<CurrentUserData> get currentUserData {
    return usersCollection.document(uid).snapshots().map(_currentUserDataFromSnapshot);
  }

}