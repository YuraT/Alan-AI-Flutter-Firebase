import 'package:flutter/material.dart';
import 'package:project1/screens/home/group_data_screen.dart';
import 'package:project1/screens/home/task_data_screen.dart';
import 'package:project1/screens/wrapper.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      // root page
      case '/':
        return MaterialPageRoute(builder: (_) => Wrapper());
        break;
      case '/groupData':
        // Validation of correct data type
        print(args.toString());
        if (args is Map<String, dynamic>) {
          // need more data type checking here
          return MaterialPageRoute(
            builder: (_) => GroupDataScreen(
              groupDataScreenKey: args["groupDataScreenKey"],
              groupData: args["groupData"],
              tasksDataKey: args["tasksDataKey"],
            ),
          );
        }
        // If args is not of the correct type, return an error page.
        // You can also throw an exception while in development.
        return _errorRoute();
        break;
      case '/taskData':
        // Validation of correct data type
        print(args.toString());
        if (args is Map<String, dynamic>) {
          // need more data type checking here
          return MaterialPageRoute(
            builder: (_) => TaskDataScreen(
              taskDataScreenKey: args["taskDataScreenKey"],
              taskData: args["taskData"],
            ),
          );
        }
        // If args is not of the correct type, return an error page.
        // You can also throw an exception while in development.
        return _errorRoute();
        break;
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
