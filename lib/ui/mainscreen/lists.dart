import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sharedhub/api/apihandler.dart';
import 'dart:async';
import 'package:clipboard_manager/clipboard_manager.dart';

class Listhandler extends StatefulWidget {
  Listhandler({Key key}) : super(key: key);

  @override
  _ListhandlerState createState() => _ListhandlerState();
}

class _ListhandlerState extends State<Listhandler> {
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
  ScrollController sponseredcontroller, usersscrollcontroller;
  int postSize, sponseredSize;
  bool loading, uppressed, downpressed;
  Color upwardcolor, downwardcolor = Colors.grey;
  var platformcolor = new HashMap();
  var platformlogo = new HashMap();
  int _selectedIndex;
  List<bool> _isLiked, _isDisLiked, _isLikedsponsered, _isDisLikedsponsered;
  double width;
  String thingy = "";
  String url = 'http://www.json-generator.com/api/json/get/bQheuzEjZu?indent=2';

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
    platformcolor['Nintendo'] = Colors.red[900];
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

    usersscrollcontroller = new ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: true,
    );

    //Store user device id.... send
    post = fetchPost(url);

    usersscrollcontroller.addListener(() {
      if (usersscrollcontroller.position.pixels ==
          usersscrollcontroller.position.maxScrollExtent) getmoreposts();
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
          if (!response.hasData || (response.data == null)) {
            return Center(
              child: Container(child: CupertinoActivityIndicator()),
            );
          }

          //Gets length of json children that are inside 'posts'
          postSize = response.data.myposts.length;

          for (int i = 0; i < postSize; i++) {
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
                sponseredusername
                    .add(response.data.myposts[i]['username'].toString());
                sponseredposttext
                    .add(response.data.myposts[i]['posttext'].toString());
                sponsereduserid
                    .add(response.data.myposts[i]['userid'].toString());
                sponseredplatform
                    .add(response.data.myposts[i]['platform'].toString());
                sponseredpostid.add(response.data.myposts[i]['postid']);
                sponseredvotes.add(response.data.myposts[i]['votes']);
                _isLikedsponsered.add(false);
                _isDisLikedsponsered.add(false);
              }
            }
          }

          print(thingy);

          // postid.length == max? ,,,, sponseredpostid.length

          //Snackbar notifcation if maxed reachd DATABSE OR FLUTTER?

          sponseredList(double width) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: sponseredcontroller,
              itemCount: sponseredpostid.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return (index == sponseredpostid.length)
                    ? CupertinoActivityIndicator()
                    : FittedBox(
                        child: Container(
                          child: Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: Border.all(
                                width: 4.8,
                                color: platformcolor[sponseredplatform[index]]),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(9, 9, 9, 9),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Wrap(
                                        children: <Widget>[
                                          Text(
                                            "Username: " +
                                                sponseredusername[index],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      ButtonTheme(
                                        minWidth: 30.0,
                                        child: RaisedButton(
                                          onPressed: () {
                                            ClipboardManager.copyToClipBoard(
                                                    sponseredusername[index])
                                                .then((result) {
                                              final snackBar = SnackBar(
                                                content:
                                                    Text('Copied to Clipboard'),
                                                action: SnackBarAction(
                                                  label: 'Undo',
                                                  onPressed: () {},
                                                ),
                                              );
                                              Scaffold.of(context)
                                                  .showSnackBar(snackBar);
                                            });
                                          },
                                          color: Colors.cyanAccent[350],
                                          child: Text(
                                            "Copy",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Wrap(
                                    children: <Widget>[
                                      Container(
                                        child: Text("About me:" +
                                            sponseredposttext[index]),
                                        constraints:
                                            BoxConstraints(maxWidth: width),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      SizedBox(width: 230),
                                      Text("\nVotes: " +
                                          votes[index].toString()),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(2, 0, 0, 3),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Image(
                                          image: platform[index] != null
                                              ? AssetImage(platformlogo[
                                                  sponseredplatform[index]])
                                              : null,
                                          width: 35,
                                        ),
                                        SizedBox(
                                          width: 150,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            IconButton(
                                              icon: Icon(Icons.arrow_upward),
                                              color: _isLikedsponsered[index]
                                                  ? platformcolor[
                                                      sponseredplatform[index]]
                                                  : Colors.black,
                                              onPressed: () {
                                                if (_isDisLikedsponsered[
                                                        index] ==
                                                    true) {
                                                  _isDisLikedsponsered[index] =
                                                      !_isDisLikedsponsered[
                                                          index];
                                                }

                                                if (_selectedIndex == index)
                                                  setState(() {
                                                    thingy =
                                                        "Remove same vote " +
                                                            index.toString();
                                                    _selectedIndex = index;

                                                    _isLikedsponsered[index] =
                                                        !_isLikedsponsered[
                                                            index];
                                                  });
                                                else if (_selectedIndex !=
                                                    index) {
                                                  setState(() {
                                                    _isLikedsponsered[index] =
                                                        !_isLikedsponsered[
                                                            index];

                                                    _selectedIndex = index;
                                                    thingy = "new vote " +
                                                        index.toString();
                                                  });
                                                }
                                              },
                                            ),
                                            SizedBox(
                                              width: 25,
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.arrow_downward),
                                              color: _isDisLikedsponsered[index]
                                                  ? Colors.orange[600]
                                                  : Colors.black,
                                              onPressed: () {
                                                if (_isLikedsponsered[index] ==
                                                    true) {
                                                  _isLikedsponsered[index] =
                                                      !_isLikedsponsered[index];
                                                }

                                                if (_selectedIndex == index)
                                                  setState(() {
                                                    thingy =
                                                        "Remove same vote " +
                                                            index.toString();
                                                    _selectedIndex = index;

                                                    _isDisLikedsponsered[
                                                            index] =
                                                        !_isDisLikedsponsered[
                                                            index];
                                                  });
                                                else if (_selectedIndex !=
                                                    index) {
                                                  setState(() {
                                                    _isDisLikedsponsered[
                                                            index] =
                                                        !_isDisLikedsponsered[
                                                            index];

                                                    _selectedIndex = index;
                                                    thingy = "new vote " +
                                                        index.toString();
                                                  });
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
              },
            );
          }

          if (postid.length < 3) getmoreposts();

          pponseredList() {
            return ListView.builder(
              controller: usersscrollcontroller,
              itemCount: postid.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return (index == postid.length)
                    ? CupertinoActivityIndicator()
                    : Container(
                        child: Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: Border.all(
                              width: 2.8,
                              color: platformcolor[platform[index]]),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(7, 5, 7, 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Wrap(
                                      children: <Widget>[
                                        Text(
                                          "Username: " + username[index],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    ButtonTheme(
                                      minWidth: 30.0,
                                      child: RaisedButton(
                                        onPressed: () {
                                          ClipboardManager.copyToClipBoard(
                                                  username[index])
                                              .then((result) {
                                            final snackBar = SnackBar(
                                              content:
                                                  Text('Copied to Clipboard'),
                                              action: SnackBarAction(
                                                label: 'Undo',
                                                onPressed: () {},
                                              ),
                                            );
                                            Scaffold.of(context)
                                                .showSnackBar(snackBar);
                                          });
                                        },
                                        color: Colors.cyanAccent[350],
                                        child: Text(
                                          "Copy",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Wrap(
                                  children: <Widget>[
                                    Container(
                                      child:
                                          Text("About me: " + posttext[index]),
                                      constraints:
                                          BoxConstraints(maxWidth: 370),
                                    ),
                                  ],
                                ),
                                Text("Votes: " + votes[index].toString()),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(2, 0, 0, 3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Image(
                                        image: platform[index] != null
                                            ? AssetImage(
                                                platformlogo[platform[index]])
                                            : null,
                                        width: 35,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(Icons.arrow_upward),
                                            color: _isLiked[index]
                                                ? platformcolor[platform[index]]
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

                                                  _isLiked[index] =
                                                      !_isLiked[index];
                                                });
                                              else if (_selectedIndex !=
                                                  index) {
                                                setState(() {
                                                  _isLiked[index] =
                                                      !_isLiked[index];

                                                  _selectedIndex = index;
                                                  thingy = "new vote " +
                                                      index.toString();
                                                });
                                              }
                                            },
                                          ),
                                          SizedBox(
                                            width: 25,
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.arrow_downward),
                                            color: _isDisLiked[index]
                                                ? Colors.orange[600]
                                                : Colors.black,
                                            onPressed: () {
                                              if (_isLiked[index] == true) {
                                                _isLiked[index] =
                                                    !_isLiked[index];
                                              }

                                              if (_selectedIndex == index)
                                                setState(() {
                                                  thingy = "Remove same vote " +
                                                      index.toString();
                                                  _selectedIndex = index;

                                                  _isDisLiked[index] =
                                                      !_isDisLiked[index];
                                                });
                                              else if (_selectedIndex !=
                                                  index) {
                                                setState(() {
                                                  _isDisLiked[index] =
                                                      !_isDisLiked[index];

                                                  _selectedIndex = index;
                                                  thingy = "new vote " +
                                                      index.toString();
                                                });
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
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
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                sponseredpostid.length > 0
                    ? Container(
                        height: MediaQuery.of(context).size.width * 0.54,
                        child: sponseredList(MediaQuery.of(context).size.width),
                      )
                    : null,
                pponseredList()
              ],
            ),
          );
        },
      ),
    );
  }
}
