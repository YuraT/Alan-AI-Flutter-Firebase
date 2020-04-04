class User {
  final String uid;
  User({this.uid});
}

class CurrentUserData {

  final String uid;
  final List<Task> tasks;
  final String firstName;
  final String lastName;
  final String username;

  CurrentUserData({this.uid, this.tasks, this.firstName, this.lastName, this.username});
}

class Task {
  final String name;
  final String description;
  final int time;

  Task({this.name, this.description, this.time});
}