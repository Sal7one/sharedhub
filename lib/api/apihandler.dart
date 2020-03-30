import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

//Yes you need all these improts if you have no idea what an async concept is. It's very simple.
//How does this work? in Flutter??????? WHAT IS FUTURE?? Checkout this article out https://medium.com/flutter-community/working-with-apis-in-flutter-8745968103e9 I RECCOMEND READING THIS

Future<Post> fetchPost(url) async {
//load more + custom url here url + index we got from init last item from database to future to contriller scroll ----- > database
  final response = await http.get(url);

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return Post.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class Post {
  final myposts;

  Post({this.myposts});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      myposts: json["posts"],
    );
  }
}
