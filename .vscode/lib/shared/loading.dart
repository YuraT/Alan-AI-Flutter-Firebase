import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 229, 235, 239),
      child: Center(
        child: SpinKitRing(
          color: Color.fromARGB(255, 58, 83, 115),
          size: 50.0,
        ),
      ),
    );
  }
}