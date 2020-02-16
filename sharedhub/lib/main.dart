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
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Splash())),
              child: Container(
                height: 65,
                decoration: BoxDecoration(color: Colors.black),
                padding: EdgeInsets.all(2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.supervised_user_circle,
                      color: Colors.blue,
                      size: 40,
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Text(
                      "The Cat in the hat!",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )
                  ],
                ),
              ),
            ),
            Column(
              children: <Widget>[Text("data"), Text("data2")],
            )
          ],
        ),
      ),
    ));
  }
}
