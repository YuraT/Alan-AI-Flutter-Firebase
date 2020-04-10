class User {
  final String uid;
  User({this.uid});
}

class CurrentUserData {

  final String uid;
  final List<String> tasks;
  final String firstName;
  final String lastName;
  final String username;

  CurrentUserData({this.uid, this.tasks, this.firstName, this.lastName, this.username});
}

class TaskDataModel {
  final String title;
  final String description;
  final String group;
  final String assigner;
  final List<String> users;
  final DateTime deadline;
  final bool completedStatus;

  TaskDataModel({this.title, this.description, this.group, this.assigner, this.users, this.deadline, this.completedStatus});
}