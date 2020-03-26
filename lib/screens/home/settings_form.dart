import 'package:flutter/material.dart';
import 'package:project1/models/user.dart';
import 'package:project1/services/database.dart';
import 'package:project1/shared/constants.dart';
import 'package:project1/shared/loading.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formkey = GlobalKey<FormState>();
  final List<String> sugars = ['0','1','2','3','4'];

  // form values
  String _currentName;
  String _currentSugars;
  int _currentStrength;
  
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<CurrentUserData>(
      stream: DatabaseService(uid: user.uid).currentUserData,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          CurrentUserData currentUser = snapshot.data;
          return Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                Text(
                  "Update your settings",
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 20.0,),
                TextFormField(
                  initialValue: currentUser.name,
                  decoration: textInputDecoration,
                  validator: (val) => val.isEmpty ? "Please enter a name" : null,
                  onChanged: (val) => setState(() => _currentName = val),
                ),
                SizedBox(height: 20.0,),
                // dropdown menu
                DropdownButtonFormField(
                  decoration: textInputDecoration,
                  value: _currentSugars ?? currentUser.sugars,
                  items: sugars.map((sugar) {
                    return DropdownMenuItem(
                      value: sugar,
                      child: Text("$sugar sugars"),
                    );
                  }).toList(), 
                  onChanged: (val) => setState(() => _currentSugars = val),
                  ),
                // slider to be added
                Slider(
                  value: (_currentStrength ?? currentUser.strength).toDouble(),
                  activeColor: Colors.brown[_currentStrength ?? currentUser.strength],
                  inactiveColor: Colors.brown[_currentStrength ?? currentUser.strength],
                  min: 100,
                  max: 900,
                  divisions: 8,
                  onChanged: (val) => setState(() => _currentStrength = val.round()),
                ),
                RaisedButton(
                  color: Colors.pink[400],
                  child: Text(
                    "Update",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if(_formkey.currentState.validate()) {
                      await DatabaseService(uid: currentUser.uid).updateUserData(
                        _currentSugars?? currentUser.sugars, 
                        _currentName?? currentUser.name, 
                        _currentStrength?? currentUser.strength
                        );
                      Navigator.pop(context);
                    }
                  },
                )
              ],
            ),
          );
        } else {
          return Loading();
        }
        
      }
    );
  }
}