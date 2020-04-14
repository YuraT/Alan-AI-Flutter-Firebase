import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project1/models/user.dart';
import 'package:project1/services/database.dart';

class JoinGroupForm extends StatefulWidget {
  @override
  _JoinGroupFormState createState() => _JoinGroupFormState();
}

class _JoinGroupFormState extends State<JoinGroupForm> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
      DatabaseService(userUid: user.uid).joinGroup("1JBTkaAer0nshu9A48z2");
      // (Avnish) change the sample container into a form with a text field and a button
      // store the value of the text field and call the function above with its value on button press
      // also would be good to handle the exception thrown if invite code doesnt exist
      return Container(
        child: Text("something"),
        );
  }
}