import 'package:flutter/material.dart';
import 'package:alan_voice/alan_voice.dart';

class AlanButton extends StatefulWidget {
  @override
  AlanButtonState createState() {
    return AlanButtonState();
  }
}

class AlanButtonState extends State<AlanButton> {
  bool _enabled = false; //start button state

  void _initAlanButton() async {
    //init Alan with sample project id
    AlanVoice.addButton("8e0b083e795c924d64635bba9c3571f42e956eca572e1d8b807a3e2338fdd0dc/stage");

    setState(() {
      _enabled = true;
    });
    
  /*int counter = 0;
  List<String> strings = ['Flutter', 'is', 'cool', "and","awesome!"];
  String displayedString = "Hello World!";

  void onPressOfButton() {
    setState(() {
      displayedString = strings[counter];
      counter = counter < 4 ? counter + 1 : 0;
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Alan voice example", style: TextStyle(fontSize: 40.0)),
            Padding(padding: EdgeInsets.all(10.0)),
            RaisedButton(
              child: Text(
                "Press me",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.red,
              onPressed: _initAlanButton,
            )
          ],
        ),
      ),
    );
  }
}