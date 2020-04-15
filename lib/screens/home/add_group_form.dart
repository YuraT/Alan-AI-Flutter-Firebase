import 'package:flutter/material.dart';
import 'package:project1/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:project1/models/user.dart';
import 'package:project1/services/database.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AddGroupForm extends StatefulWidget {
  @override
  _AddGroupFormState createState() => _AddGroupFormState();
}

class _AddGroupFormState extends State<AddGroupForm> {
  final _joinFormkey = GlobalKey<FormState>();
  final _createFormkey = GlobalKey<FormState>();

  // form values
  String _currentJoinCode;
  String _currentCreateName;

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    // (Avnish) change the sample container into a form with a text field and a button
    // store the value of the text field and call the function above with its value on button press
    // also would be good to handle the exception thrown if invite code doesnt exist
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Ill definitely do the create group thing later
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: 1200,
              height: 100,
              child: FlatButton(
                color: Colors.white,
                child: Text(
                  'Create a New Group',
                  style: TextStyle(
                    fontSize: 25.0,
                  ),
                ),
                onPressed: () {
                  String error = '';
                  Alert(
                      context: context,
                      title: "New Group",
                      content: Form(
                        key: _createFormkey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              validator: (val) => val.isEmpty ? "please enter group name" : null,
                              onChanged: (val) => setState(() => _currentCreateName = val),
                              decoration: textInputDecoration.copyWith(labelText: 'Group Name',),
                            ),
                          ],
                        ),
                      ),
                      buttons: [
                        DialogButton(
                          onPressed: () async {
                          if (_createFormkey.currentState.validate()) {
                            try {
                              await DatabaseService().createGroup(_currentCreateName, [user.uid], [user.uid]);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            } catch (e) {
                              // need to do better error handling here
                              setState(() {
                              error = e.toString();
                              });
                              print(error);
                            }
                          }
                        },
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
                child: Text(
                  'Join an existing Group',
                  style: TextStyle(
                    fontSize: 25.0,
                  ),
                ),
                onPressed: () {
                  String error = '';
                  Alert(
                    context: context,
                    title: "Join Group",
                    content: Form(
                      key: _joinFormkey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            validator: (val) => val.isEmpty ? "please enter code" : null,
                            onChanged: (val) => setState(() => _currentJoinCode = val),
                            decoration: textInputDecoration.copyWith(labelText: "Verification Code")
                          ),
                        ],
                      ),
                    ),
                    buttons: [
                      DialogButton(
                        onPressed: () async {
                          if (_joinFormkey.currentState.validate()) {
                            try {
                              await DatabaseService().joinGroup(user.uid, _currentJoinCode);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            } catch (e) {
                              // need to do better error handling here
                              setState(() {
                              error = e.toString();
                              });
                              print(error);
                            }
                          }
                        },
                        child: Text(
                          "Join",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      )
                    ]
                  ).show();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
