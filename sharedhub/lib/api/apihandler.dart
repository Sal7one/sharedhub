import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

//Yes you need all these improts if you have no idea what an async concept is. It's very simple.
//How does this work? in Flutter??????? WHAT IS FUTURE?? Checkout this article out https://medium.com/flutter-community/working-with-apis-in-flutter-8745968103e9 I RECCOMEND READING THIS

Future<Post> fetchPost(url) async {
//load more + custom url here url + index we got from init last item from database to future to contriller scroll ----- > database
  final response = await http.get(url);
  //This link should be api?all sponsered = true; from seeeeqoool :D
  final responseSponsered = await http
      .get("http://www.json-generator.com/api/json/get/celsEkkIlK?indent=2");

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return Post.fromJson(
        json.decode(response.body), json.decode(responseSponsered.body));
  } else if (responseSponsered.statusCode == 200) {
    return Post.fromJson(
        json.decode(response.body), json.decode(responseSponsered.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class Post {
  final myposts;
  final mysponseredposts;

  Post({this.myposts, this.mysponseredposts});

  factory Post.fromJson(
      Map<String, dynamic> json, Map<String, dynamic> sponseredpostsjson) {
    return Post(
      myposts: json["posts"],
      mysponseredposts: json["posts"],
    );
  }
}
