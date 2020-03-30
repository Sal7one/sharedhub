import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sharedhub/ui/mainscreen/header.dart';
import 'ui/auth/splashscreen.dart';
import 'ui//mainscreen/lists.dart';

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
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Splash())),
                child: header(),
              ),
              Expanded(child: listhandler())
            ],
          ),
        ),
      ),
    );
  }
}
