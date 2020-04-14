import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project1/models/user.dart';
import 'package:project1/services/database.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: 1200,
                height: 100,
                child: FlatButton(
                  color: Colors.white,
                  child: Text('Create a New Group',
                  style: TextStyle(
                    fontSize: 25.0,
                  ),
                  ),
                  onPressed: () {
                    Alert(
                        context: context,
                        title: "New Group",
                        content: Column(
                          children: <Widget>[
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Group Name',
                              ),
                            ),
                          ],
                        ),
                        buttons: [
                          DialogButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "Create",
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          )
                        ]).show();
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: 1200,
                height: 100,
                child: FlatButton(
                  color: Colors.white,
                  child: Text('Join an existing Group',
                    style: TextStyle(
                      fontSize: 25.0,
                    ),
                  ),
                  onPressed: () {
                    Alert(
                        context: context,
                        title: "Join Group",
                        content: Column(
                          children: <Widget>[
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Verification Code',
                              ),
                            ),
                          ],
                        ),
                        buttons: [
                          DialogButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "Join",
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          )
                        ]).show();
                  },
                ),
              ),
            ),
          ],
        ),
        );
  }
}