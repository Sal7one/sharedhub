import 'package:flutter/cupertino.dart';
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
  //Declration
  Future post;
  List<String> username,
      posttext,
      userid,
      platform,
      sponseredusername,
      sponseredposttext,
      sponsereduserid,
      sponseredplatform = [];
  List<int> postid, votes, sponseredpostid, sponseredvotes = [];
  bool isloading;
  List<bool> sponsered, hidden = [];
  ScrollController usersscrollcontroller, sponseredcontroller;
  int postSize, sponseredSize;
  //  String url = 'http://www.json-generator.com/api/json/get/cexPIzgQte?indent=2';

  String url = 'http://www.json-generator.com/api/json/get/bVyccrYzPC?indent=2';

  //Every itration fetch a new post data post id only needed :P
  //If the post should be hidden the api handler should not included it
  // We know that if the user is banned

  @override
  void initState() {
    super.initState();

    //You have to init all everything here;

    username = [];
    posttext = [];
    userid = [];
    platform = [];
    postid = [];
    votes = [];
    sponsered = [];
    hidden = [];
    sponseredusername = [];
    sponsereduserid = [];
    sponseredplatform = [];
    sponseredpostid = [];
    sponseredvotes = [];
    sponseredposttext = [];
    isloading = false;
    postSize = 0;
    sponseredSize = 0;
    usersscrollcontroller = new ScrollController();
    sponseredcontroller = new ScrollController();

    //Call the latest list elemnts from DB and it should only return 15
    // TODO FETCH SPONSERS ALONE <---- Important for Ui to work with all indexes not 15 only
    post = fetchPost(url);

    usersscrollcontroller.addListener(() {
      if (usersscrollcontroller.position.pixels ==
          usersscrollcontroller.position.maxScrollExtent) getmoreposts();
    });

    sponseredcontroller.addListener(() {
      if (sponseredcontroller.position.pixels ==
          sponseredcontroller.position.maxScrollExtent) getmoresponseredposts();
    });
  }

  //Get more data if scrolled to the max point
  void getmoreposts() {
    Timer(Duration(milliseconds: 800), () {
      print("requested");

      setState(() {
        post = fetchPost(
            'http://www.json-generator.com/api/json/get/cexPIzgQte?indent=2');
      });
    });
  }

  //Get more data if scrolled to the max point
  void getmoresponseredposts() {
    Timer(Duration(milliseconds: 800), () {
      print("requested sponsered");

      setState(() {
        post = fetchPost(
            'http://www.json-generator.com/api/json/get/celsEkkIlK?indent=2');
      });
    });
  }

  // Controller clean up
  @override
  void dispose() {
    usersscrollcontroller.dispose();
    sponseredcontroller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: FutureBuilder(
        future: post,
        builder: (context, response) {
          //If we get data render the objects, otherwise progress indicatior TODO LODAING ANIMATION
          if (!response.hasData || (response.data == null)) {
            return Center(
              child: Container(child: CupertinoActivityIndicator()),
            );
          }

          //Gets length of json children that are inside 'posts'
          postSize = response.data.myposts.length;
          sponseredSize = response.data.mysponseredposts.length;

          for (int i = 0; i < postSize; i++) {
            // TODO -- Logic if post is hidden Item count doesnn't count it and you ignore putting it in the loop above in the same If statment below? hmmm
            //If we already have that post in the array. Don't add it, nor it's elemnts

            //If post not hidden / and not already in the list and not sponsered
            if (response.data.myposts[i]['hidden'] != true) if (!postid
                    .contains(response.data.myposts[i]['postid']) &&
                response.data.myposts[i]['sponsored'] == false) {
              username.add(response.data.myposts[i]['username'].toString());
              posttext.add(response.data.myposts[i]['posttext'].toString());
              userid.add(response.data.myposts[i]['userid'].toString());
              platform.add(response.data.myposts[i]['platform'].toString());
              postid.add(response.data.myposts[i]['postid']);
              votes.add(response.data.myposts[i]['votes']);
            }
          }

          for (int i = 0; i < sponseredSize; i++) {
            // TODO -- Logic if post is hidden Item count doesnn't count it and you ignore putting it in the loop above in the same If statment below? hmmm
            //If we already have that post in the array. Don't add it, nor it's elemnts
            if (response.data.mysponseredposts[i]['hidden'] !=
                true) if (response.data.mysponseredposts[i]['sponsored'] ==
                    true &&
                !sponseredpostid
                    .contains(response.data.mysponseredposts[i]['postid'])) {
              sponseredusername.add(
                  response.data.mysponseredposts[i]['username'].toString());
              sponseredposttext.add(
                  response.data.mysponseredposts[i]['posttext'].toString());
              sponsereduserid
                  .add(response.data.mysponseredposts[i]['userid'].toString());
              sponseredplatform.add(
                  response.data.mysponseredposts[i]['platform'].toString());
              sponseredpostid.add(response.data.mysponseredposts[i]['postid']);
              sponseredvotes.add(response.data.mysponseredposts[i]['votes']);

              print("we added some stuff");
            }
          }

          // TODO Get all item list for sponsered and non sponsered spertialy and check if max == to both list indivuily and show a snack bar and time out the request controller :D
          // postid.length == max? ,,,, sponseredpostid.length
          String img =
              "https://cdn0.iconfinder.com/data/icons/cat-avatar-flat/64/Cat_avatar_kitten-30-128.png";
          //Snackbar notifcation if maxed reachd DATABSE OR FLUTTER?

          //Horziantal list
          // if (sponseredpostid.length < 2) {
          //  getmoresponseredposts();
          //  }
          Sponserdlist() {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: sponseredcontroller,
              itemCount: sponseredpostid.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 80,
                  child: Card(
                    color: Colors.red,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.network(
                              img,
                              height: 50,
                              width: 50,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              children: <Widget>[
                                Text("  " +
                                    sponseredplatform[index] +
                                    " Username:"),
                                Text(
                                  " " + sponseredusername[index],
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 60,
                            ),
                            RaisedButton(
                              onPressed: () {},
                              color: Colors.red,
                              child: Text("Copy"),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("About me: "),
                            Container(
                              decoration: BoxDecoration(color: Colors.white),
                              padding: EdgeInsets.all(15),
                              child: Text(sponseredposttext[index]),
                            ),
                          ],
                        ),
                        Text("userid is " + sponsereduserid[index]),
                        Text("platform is " + sponseredplatform[index]),
                        Text("postid is " + sponseredpostid[index].toString()),
                        Text("votes is " + sponseredvotes[index].toString()),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          if (postid.length < 3) {
            getmoreposts();
          }
          return ListView.builder(
            controller: usersscrollcontroller,
            itemCount: postid.length,
            itemBuilder: (context, index) {
              //Don't show sopnsered if the length of it's posts is less that 1
              if (isloading && index == postid.length - 1)
                return CupertinoActivityIndicator();
              else
                return (index == 0 && sponseredpostid.length == 69)
                    ? SizedBox(height: 250, child: Sponserdlist())
                    : Container(
                        height: 250,
                        child: Card(
                          color: Colors.blue,
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.network(
                                    img,
                                    height: 50,
                                    width: 50,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text("  " +
                                          platform[index] +
                                          " Username:"),
                                      Text(
                                        " " + username[index],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 60,
                                  ),
                                  RaisedButton(
                                    onPressed: () {},
                                    color: Colors.red,
                                    child: Text("Copy"),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("About me: "),
                                  Container(
                                    decoration:
                                        BoxDecoration(color: Colors.white),
                                    padding: EdgeInsets.all(15),
                                    child: Text(posttext[index]),
                                  ),
                                ],
                              ),
                              Text("userid is " + userid[index]),
                              Text("platform is " + platform[index]),
                              Text("postid is " + postid[index].toString()),
                              Text("votes is " + votes[index].toString()),
                            ],
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
