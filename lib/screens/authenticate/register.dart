import "package:flutter/material.dart";
import 'package:project1/services/auth.dart';
import 'package:project1/shared/constants.dart';
import 'package:project1/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String firstName = '';
  String lastName = '';
  String username = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              //title: Text("Sign up to App"),
              actions: <Widget>[
                //FlatButton.icon(
                    //onPressed: () {
                      //widget.toggleView();
                    //},
                    //icon: Icon(Icons.person),
                    //label: Text("Login"))
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 50.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Text("Sign Up", style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                        ),),
                        SizedBox(height: 15.0),
                        Text("Create an account, it's free!", style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[800]
                        ),),
                        SizedBox(height: 10.0),
                        // first name text box
                        TextFormField(
                            decoration: InputDecoration(
                              labelText: "First Name",
                              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey[400])
                                ),
                            ),
                            validator: (val) =>
                                val.isEmpty ? "Enter your first name" : null,
                            onChanged: (val) {
                              setState(() => firstName = val);
                            }),
                        SizedBox(height: 10.0),
                        // last name text box
                        TextFormField(
                            decoration: InputDecoration(
                              labelText: "Last Name",
                              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey[400])
                              ),
                            ),
                            validator: (val) =>
                                val.isEmpty ? "Enter your last name" : null,
                            onChanged: (val) {
                              setState(() => lastName = val);
                            }),
                        SizedBox(height: 10.0),
                        // email text box
                        TextFormField(
                            decoration: InputDecoration(
                              labelText: "Email",
                              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey[400])
                              ),
                            ),
                            validator: (val) =>
                                val.isEmpty ? "Enter an email" : null,
                            onChanged: (val) {
                              setState(() => email = val);
                            }),
                        SizedBox(height: 10.0),
                        // username text box
                        TextFormField(
                            decoration: InputDecoration(
                              labelText: "Username",
                              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey[400])
                              ),
                            ),
                            validator: (val) =>
                                val.isEmpty ? "Enter a username" : null,
                            onChanged: (val) {
                              setState(() => username = val);
                            }),
                        SizedBox(height: 10.0),
                        // password text box
                        TextFormField(
                            decoration: InputDecoration(
                              labelText: "Password",
                              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey[400])
                              ),
                            ),
                            validator: (val) => val.length < 6
                                ? "Enter a password 6+ symbols long"
                                : ((val != confirmPassword)
                                    ? "Passwords don't match"
                                    : null),
                            obscureText: true,
                            onChanged: (val) {
                              setState(() => password = val);
                            }),
                        SizedBox(height: 10.0),
                        // confirm password text box
                        TextFormField(
                            decoration: InputDecoration(
                              labelText: "Confirm Password",
                              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey[400])
                              ),
                            ),
                            validator: (val) => ((val != confirmPassword)
                                ? "Passwords don't match"
                                : null),
                            obscureText: true,
                            onChanged: (val) {
                              setState(() => confirmPassword = val);
                            }),
                        SizedBox(height: 10.0),
                        // register button
                        MaterialButton(
                          minWidth: double.infinity,
                          height: 40,
                          color: Colors.blue[600],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)
                          ),
                          child: Text("Register",
                              style: TextStyle(color: Colors.white)),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => loading = true);
                              dynamic result =
                                  await _auth.registerWithEmailAndPassword(
                                      email,
                                      password,
                                      firstName,
                                      lastName,
                                      username);
                              if (result == null) {
                                setState(() {
                                  error = 'error has occured';
                                  loading = false;
                                });
                                print(error);
                              } else {}
                            }
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Already have an account? "),
                            FlatButton(
                              color: Colors.transparent,
                              textColor: Colors.black,
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 1.0, 0.0),
                              onPressed: (){
                                widget.toggleView();
                              },
                              child: Text(
                                  "Sign In",
                                  style: TextStyle(fontSize: 18)
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 3,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/signup_image.png"),
                                fit: BoxFit.cover
                            ),
                          ),
                        ),
                        SizedBox(height: 12.0),
                        Text(error,
                            style:
                                TextStyle(color: Colors.red, fontSize: 14.0)),
                      ],
                    ),
                  )),
            ),
          );
  }
}
