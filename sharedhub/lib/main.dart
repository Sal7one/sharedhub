import 'package:flutter/material.dart';
import 'splashscreen.dart';

void main() => runApp(
      MaterialApp(
        home: Splash(),
      ),
    );

class MainScreen extends StatelessWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: SafeArea(
          child: Container(
        decoration: BoxDecoration(color: Colors.red),
        padding: EdgeInsets.all(2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.supervised_user_circle,
              color: Colors.blue,
            ),
            Text("Screen name!")
          ],
        ),
      )),
    ));
  }
}
