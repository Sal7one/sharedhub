import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sharedhub/api/apihandler.dart';
import 'dart:async';

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
      sponseredplatform;
  List<int> postid, votes, sponseredpostid, sponseredvotes;
  List<bool> sponsered, hidden;
  ScrollController usersscrollcontroller,
      sponseredcontroller,
      _scrollController;
  int postSize, sponseredSize;
  bool loading, uppressed, downpressed;
  Color upwardcolor, downwardcolor = Colors.grey;
  int _selectedIndex;
  List<bool> _isLiked;

  String thingy = "";
  String url = 'http://www.json-generator.com/api/json/get/cqgOiUXCSq?indent=2';

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
    _selectedIndex = 6969691345;

    votes = [];
    sponsered = [];
    hidden = [];
    sponseredusername = [];
    sponsereduserid = [];
    sponseredplatform = [];
    sponseredpostid = [];
    sponseredvotes = [];
    sponseredposttext = [];
    postSize = 0;
    uppressed = false;
    downpressed = false;
    sponseredSize = 0;
    loading = false;
    usersscrollcontroller = new ScrollController();
    sponseredcontroller = new ScrollController();
    upwardcolor = Colors.grey;
    downwardcolor = Colors.grey;
    _isLiked = [true, true];

    _scrollController = new ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: true,
    );

    //Call the latest list elemnts from DB and it should only return 15
    // TODO FETCH SPONSERS ALONE <---- Important for Ui to work with all indexes not 15 only

    //Store user device id.... send
    post = fetchPost(url);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) getmoreposts();
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
        loading = false;
        post = fetchPost(
            'http://www.json-generator.com/api/json/get/bOCobltOHm?indent=2');
      });
    });
  }

  //Get more data if scrolled to the max point
  void getmoresponseredposts() {
    Timer(Duration(milliseconds: 800), () {
      print("requested sponsered");

      setState(() {
        loading = false;

        post = fetchPost(
            'http://www.json-generator.com/api/json/get/celsEkkIlK?indent=2');
      });
    });
  }

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  // Controller clean up
  @override
  void dispose() {
    _scrollController.dispose();
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
            if (response.data.myposts[i]['hidden'] != true) {
              if (response.data.myposts[i]['sponsored'] == false) {
                if (!postid.contains(response.data.myposts[i]['postid'])) {
                  username.add(response.data.myposts[i]['username'].toString());
                  posttext.add(response.data.myposts[i]['posttext'].toString());
                  userid.add(response.data.myposts[i]['userid'].toString());
                  platform.add(response.data.myposts[i]['platform'].toString());
                  postid.add(response.data.myposts[i]['postid']);
                  votes.add(response.data.myposts[i]['votes']);
                }
              } else if (!sponseredpostid
                  .contains(response.data.myposts[i]['postid'])) {
                sponseredusername.add(
                    response.data.mysponseredposts[i]['username'].toString());
                sponseredposttext.add(
                    response.data.mysponseredposts[i]['posttext'].toString());
                sponsereduserid.add(
                    response.data.mysponseredposts[i]['userid'].toString());
                sponseredplatform.add(
                    response.data.mysponseredposts[i]['platform'].toString());
                sponseredpostid
                    .add(response.data.mysponseredposts[i]['postid']);
                sponseredvotes.add(response.data.mysponseredposts[i]['votes']);
              }
            }
          }

          print(thingy);

          // TODO Get all item list for sponsered and non sponsered spertialy and check if max == to both list indivuily and show a snack bar and time out the request controller :D
          // postid.length == max? ,,,, sponseredpostid.length
          String img =
              "https://cdn0.iconfinder.com/data/icons/cat-avatar-flat/64/Cat_avatar_kitten-30-128.png";
          //Snackbar notifcation if maxed reachd DATABSE OR FLUTTER?

          Sponserdlist() {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: sponseredcontroller,
              itemCount: sponseredpostid.length,
              itemBuilder: (context, index) {
                return (index == sponseredpostid.length - 1 && loading)
                    ? CupertinoActivityIndicator()
                    : Container(
                        height: 80,
                        width: 400,
                        child: Card(
                          shape:
                              Border.all(width: 1, color: Colors.yellow[600]),
                          color: Colors.blue[700],
                          child: Column(
                            children: <Widget>[
                              Row(
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
                                    width: 90,
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
                                    child: Text(sponseredposttext[index]),
                                  ),
                                ],
                              ),
                              Text("userid is " + sponsereduserid[index]),
                              Text("platform is " + sponseredplatform[index]),
                              Text("postid is " +
                                  sponseredpostid[index].toString()),
                              Text("votes is " +
                                  sponseredvotes[index].toString()),
                            ],
                          ),
                        ),
                      );
              },
            );
          }

          PostsList() {
            return ListView.builder(
              controller: usersscrollcontroller,
              itemCount: postid.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return (index == postid.length - 1 && loading)
                    ? CupertinoActivityIndicator()
                    : Container(
                        height: 180,
                        child: Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape:
                              Border.all(width: 0.6, color: Colors.deepPurple),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.network(
                                      img,
                                      height: 30,
                                      width: 30,
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
                                      width: 40,
                                    ),
                                    ButtonTheme(
                                      minWidth: 30.0,
                                      height: 40.0,
                                      child: RaisedButton(
                                        onPressed: () {
                                          print("ayyy");
                                        },
                                        color: Colors.red,
                                        child: Text("Copy"),
                                      ),
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
                                Text("Votes: " + votes[index].toString()),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.arrow_upward),
                                      color: _isLiked[index]
                                          ? Colors.red
                                          : Colors.black,
                                      onPressed: () {
                                        if (uppressed &&
                                            _selectedIndex == index)
                                          setState(() {
                                            thingy = "Remove same vote " +
                                                index.toString();
                                            _selectedIndex = index;
                                            _isLiked[index] = !_isLiked[index];

                                            uppressed = false;
                                          });
                                        else if (_selectedIndex != index)
                                          setState(() {
                                            _isLiked[index] = !_isLiked[index];

                                            _selectedIndex = index;
                                            thingy =
                                                "new vote " + index.toString();
                                            uppressed = true;
                                            downpressed = false;
                                          });
                                        else
                                          setState(() {
                                            thingy = "changing votes  " +
                                                index.toString();
                                            _isLiked[index] = !_isLiked[index];

                                            uppressed = true;
                                            downpressed = false;
                                          });
                                      },
                                    ),
                                    SizedBox(
                                      width: 80,
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.arrow_downward),
                                      color: _isLiked[index]
                                          ? Colors.red
                                          : Colors.black,
                                      onPressed: () {
                                        if (downpressed &&
                                            _selectedIndex == index)
                                          setState(() {
                                            thingy = "Remove same vote " +
                                                index.toString();
                                            _selectedIndex = index;
                                            _isLiked[index] = !_isLiked[index];

                                            downpressed = false;
                                          });
                                        else if (_selectedIndex != index)
                                          setState(() {
                                            _isLiked[index] = !_isLiked[index];

                                            _selectedIndex = index;
                                            thingy =
                                                "new vote " + index.toString();
                                            downpressed = true;
                                            uppressed = false;
                                          });
                                        else
                                          setState(() {
                                            thingy = "changing votes  " +
                                                index.toString();
                                            _isLiked[index] = !_isLiked[index];

                                            downpressed = true;
                                            uppressed = false;
                                          });
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
              },
            );
          }

          return SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                //
                //sponseredpostid.length > 0
                //   ? SizedBox(height: 250.0, child: Sponserdlist())
                //    : null,
                SizedBox(child: PostsList()),
              ],
            ),
          );
        },
      ),
    );
  }
}

/*
if (downpressed &&
                                            _selectedIndex == index)
                                          setState(() {
                                            thingy = "Remove same vote " +
                                                index.toString();
                                            _selectedIndex = index;
                                            downpressed = false;
                                          });
                                        else if (_selectedIndex != index)
                                          setState(() {
                                            thingy =
                                                "new vote " + index.toString();

                                            _selectedIndex = index;
                                            downpressed = true;
                                            uppressed = false;
                                          });
                                        else
                                          setState(() {
                                            thingy = "changing votes  " +
                                                index.toString();
                                            downpressed = true;
                                            uppressed = false;
                                          });
                                      },

                                       */