import 'dart:collection';

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
  var platformcolor = new HashMap();
  var platformlogo = new HashMap();
  int _selectedIndex;
  List<bool> _isLiked, _isDisLiked, _isLikedsponsered, _isDisLikedsponsered;

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
    platformcolor['Twitter'] = Colors.cyan;
    platformcolor['Snapchat'] = Colors.yellow;
    platformcolor['Instagram'] = Colors.pink;
    platformcolor['Nintendo'] = Colors.red;
    platformcolor['Steam'] = Colors.black;
    platformcolor['Playstation'] = Colors.blue;
    platformcolor['Xbox'] = Colors.green;

    platformlogo['Twitter'] = 'assets/social/twitter.png';
    platformlogo['Snapchat'] = 'assets/social/snap.png';
    platformlogo['Instagram'] = 'assets/social/insta.png';
    platformlogo['Nintendo'] = 'assets/social/nintendo.png';
    platformlogo['Steam'] = 'assets/social/steam.png';
    platformlogo['Playstation'] = 'assets/social/ps.png';
    platformlogo['Xbox'] = 'assets/social/xbox.png';

    _isLiked = [];
    _isLikedsponsered = [];
    _isDisLiked = [];
    _isDisLikedsponsered = [];

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
      thingy = "req thing";
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
      thingy = "reqs thing";

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
                  _isLiked.add(false);
                  _isDisLiked.add(false);
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
                _isLikedsponsered.add(false);
                _isDisLikedsponsered.add(false);
              }
            }
          }

          print(thingy);

          // TODO Get all item list for sponsered and non sponsered spertialy and check if max == to both list indivuily and show a snack bar and time out the request controller :D
          // postid.length == max? ,,,, sponseredpostid.length

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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.arrow_upward),
                                    color: _isLikedsponsered[index]
                                        ? Colors.red
                                        : Colors.black,
                                    onPressed: () {
                                      if (_isDisLikedsponsered[index] == true) {
                                        _isDisLikedsponsered[index] =
                                            !_isDisLikedsponsered[index];
                                      }

                                      if (_selectedIndex == index)
                                        setState(() {
                                          thingy = "Remove same vote " +
                                              index.toString();
                                          _selectedIndex = index;

                                          _isLikedsponsered[index] =
                                              !_isLikedsponsered[index];
                                        });
                                      else if (_selectedIndex != index) {
                                        setState(() {
                                          _isLikedsponsered[index] =
                                              !_isLikedsponsered[index];

                                          _selectedIndex = index;
                                          thingy =
                                              "new vote " + index.toString();
                                        });
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    width: 80,
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.arrow_downward),
                                    color: _isDisLikedsponsered[index]
                                        ? Colors.red
                                        : Colors.black,
                                    onPressed: () {
                                      if (_isLikedsponsered[index] == true) {
                                        _isLikedsponsered[index] =
                                            !_isLikedsponsered[index];
                                      }

                                      if (_selectedIndex == index)
                                        setState(() {
                                          thingy = "Remove same vote " +
                                              index.toString();
                                          _selectedIndex = index;

                                          _isDisLikedsponsered[index] =
                                              !_isDisLikedsponsered[index];
                                        });
                                      else if (_selectedIndex != index) {
                                        setState(() {
                                          _isDisLikedsponsered[index] =
                                              !_isDisLikedsponsered[index];

                                          _selectedIndex = index;
                                          thingy =
                                              "new vote " + index.toString();
                                        });
                                      }
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
              },
            );
          }

          if (postid.length < 3) getmoreposts();

          PostsList() {
            return ListView.builder(
              controller: usersscrollcontroller,
              itemCount: postid.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return (index == postid.length - 1 && loading)
                    ? CupertinoActivityIndicator()
                    : Container(
                        height: 250,
                        child: Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: Border.all(
                              width: 2.6,
                              color: platformcolor[platform[index]]),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Image(
                                      image: platform[index] != null
                                          ? AssetImage(
                                              platformlogo[platform[index]])
                                          : null,
                                      width: 50,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 15,
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
                                          ? Colors.green[600]
                                          : Colors.black,
                                      onPressed: () {
                                        if (_isDisLiked[index] == true) {
                                          _isDisLiked[index] =
                                              !_isDisLiked[index];
                                        }

                                        if (_selectedIndex == index)
                                          setState(() {
                                            thingy = "Remove same vote " +
                                                index.toString();
                                            _selectedIndex = index;

                                            _isLiked[index] = !_isLiked[index];
                                          });
                                        else if (_selectedIndex != index) {
                                          setState(() {
                                            _isLiked[index] = !_isLiked[index];

                                            _selectedIndex = index;
                                            thingy =
                                                "new vote " + index.toString();
                                          });
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      width: 80,
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.arrow_downward),
                                      color: _isDisLiked[index]
                                          ? Colors.orange[900]
                                          : Colors.black,
                                      onPressed: () {
                                        if (_isLiked[index] == true) {
                                          _isLiked[index] = !_isLiked[index];
                                        }

                                        if (_selectedIndex == index)
                                          setState(() {
                                            thingy = "Remove same vote " +
                                                index.toString();
                                            _selectedIndex = index;

                                            _isDisLiked[index] =
                                                !_isDisLiked[index];
                                          });
                                        else if (_selectedIndex != index) {
                                          setState(() {
                                            _isDisLiked[index] =
                                                !_isDisLiked[index];

                                            _selectedIndex = index;
                                            thingy =
                                                "new vote " + index.toString();
                                          });
                                        }
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
                // sponseredpostid.length > 0
                //  ? SizedBox(height: 250.0, child: Sponserdlist())
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
