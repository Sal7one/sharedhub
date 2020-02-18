import 'package:flutter/material.dart';
import 'package:sharedhub/apihandler.dart';
import 'splashscreen.dart';
import 'dart:async';

void main() => runApp(
      MaterialApp(
        home: MainScreen(),
      ),
    );

class MainScreen extends StatelessWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color _primarycolor = Colors.black;
    Color _secondarycolor = Colors.green;

    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Splash())),
                child: Container(
                  height: 65,
                  decoration: BoxDecoration(color: _primarycolor),
                  padding: EdgeInsets.all(2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.supervised_user_circle,
                        color: _secondarycolor,
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
              Expanded(child: listhandler())
            ],
          ),
        ),
      ),
    );
  }
}

class listhandler extends StatefulWidget {
  listhandler({Key key}) : super(key: key);

  @override
  _listhandlerState createState() => _listhandlerState();
}

class _listhandlerState extends State<listhandler> {
  Future post;
  List<String> username, posttext, userid, platform = [];
  List<int> postid, votes = [];
  List<bool> sponsered = [];
  ScrollController myscrollcontroller = new ScrollController();
  int listsize = 0;
  String url = 'http://www.json-generator.com/api/json/get/cqokSxYNGq?indent=2';

  //Every itration fetch a new post data post id only needed :P
  //If the post should be hidden the api handler should not included it
  // We know that if the user is banned

  @override
  void initState() {
    super.initState();

    username = [];
    posttext = [];
    userid = [];
    platform = [];
    sponsered = [];
    postid = [];
    votes = [];

    post = fetchPost(url);

    myscrollcontroller.addListener(() {
      if (myscrollcontroller.position.pixels ==
          myscrollcontroller.position.maxScrollExtent) scrollmore();
    });
  }

  void scrollmore() {
    Timer(Duration(milliseconds: 800), () {
      print("requested");

      setState(() {
        post = fetchPost(
            'http://www.json-generator.com/api/json/get/bZxBUZKYMO?indent=2');
      });
    });
  }

  @override
  void dispose() {
    myscrollcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: post,
        builder: (context, response) {
          if (!response.hasData || (response.data == null)) {
            //print('project snapshot data is: ${projectSnap.data}');
            return Center(
              child: Container(child: CircularProgressIndicator()),
            );
          }

          //get length of json children
          listsize = response.data.mydata.length;

//my data ----> post id
//make a new map :D in pi handler
          for (int i = 0; i < listsize; i++) {
            if (!postid.contains(response.data.mydata[i]['postid'])) {
              username.add(response.data.mydata[i]['username'].toString());
              posttext.add(response.data.mydata[i]['posttext'].toString());
              userid.add(response.data.mydata[i]['userid'].toString());
              platform.add(response.data.mydata[i]['platform'].toString());
              sponsered.add(response.data.mydata[i]['sponsored']);
              postid.add(response.data.mydata[i]['postid']);
              votes.add(response.data.mydata[i]['votes']);
            }
          }

// TO DO                    Logic if post is hidden Item count doesnn't count it and you ignore putting it in the loop above
//Snackbar notifcation if maxed reachd DATABSE OR FLUTTER?
          return ListView.builder(
            controller: myscrollcontroller,
            itemCount: postid.length,
            itemBuilder: (context, index) {
              return Center(
                child: Container(
                  width: 320,
                  height: 250,
                  child: Card(
                    color: Colors.blue,
                    child: Column(
                      children: <Widget>[
                        Text("Username is " + username[index]),
                        Text("posttext is " + posttext[index]),
                        Text("userid is " + userid[index]),
                        Text("platform is " + platform[index]),
                        Text("sponsered is " + sponsered[index].toString()),
                        Text("postid is " + postid[index].toString()),
                        Text("votes is " + votes[index].toString()),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
