import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:int2/bookmarkpage.dart';
import 'dart:async';
import 'homepage.dart';
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:int2/homepage.dart';

bool connectionn = true;
StreamSubscription subb;

class Trackdet extends StatefulWidget {
  @override
  _TrackdetState createState() => _TrackdetState();
}

List<String> setbookmark = [];
bool load = false;

List<String> trackdata = [];
String name = "", artist = "", album = "";
bool explicit = false;
int rating = 0;
String lyrics = "";
List bookmark = [];

class _TrackdetState extends State<Trackdet> {
  @override
  void initState() {
    super.initState();
    // if (fetchdata.length != 0) fetchdata.clear();
    // if (bnamelist.length != 0) bnamelist.clear();
    loader = false;
    getData();
    this.getdata2();
    this.getdata3();
    // sub = Connectivity().onConnectivityChanged.listen((resultt) {
    //   setState(() {
    //     print("dsdsd");
    //     connectionn = (resultt != ConnectivityResult.none);
    //   });
    // });
  }

  // @override
  // void dispose() {
  //   subb.cancel();
  //   super.dispose();
  // }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      trackdata = prefs.getStringList('bookmarklist');
    });
    setState(() {
      trackdata = trackdata.toSet().toList();
    });
    print(trackdata);
  }

  Future<String> getdata2() async {
    var response = await http.get(Uri.parse(
        'https://api.musixmatch.com/ws/1.1/track.get?track_id=$trackingid&apikey=2d782bc7a52a41ba2fc1ef05b9cf40d7'));
    // print(response.body);
    setState(() {
      var convertdatatoJson2 = json.decode(response.body);

      name = convertdatatoJson2['message']['body']['track']['track_name'];
      artist = convertdatatoJson2['message']['body']['track']['artist_name'];
      album = convertdatatoJson2['message']['body']['track']['album_name'];
      explicit =
          (convertdatatoJson2['message']['body']['track']['explicit'] == 0)
              ? false
              : true;
      rating = convertdatatoJson2['message']['body']['track']['track_rating'];
    });
    return "Success";
  }

  Future<String> getdata3() async {
    var response = await http.get(Uri.parse(
        'https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=$trackingid&apikey=2d782bc7a52a41ba2fc1ef05b9cf40d7'));
    // print(response.body);
    setState(() {
      var convertdatatoJson3 = json.decode(response.body);
      // print(convertdatatoJson3);
      lyrics = convertdatatoJson3['message']['body']['lyrics']['lyrics_body'];
    });
    setState(() {
      load = true;
    });
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    // if (connectionn == false) {
    //   return Scaffold(
    //     backgroundColor: Colors.grey[900],
    //     appBar: AppBar(
    //       centerTitle: true,
    //       title: Text("Trending"),
    //     ),
    //     body: Center(
    //       child: Text(
    //         "No Internet Connection",
    //         style: TextStyle(
    //           color: Colors.white,
    //         ),
    //       ),
    //     ),
    //   );
    // } else {
    if (load == false) {
      return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          centerTitle: true,
          title: Text("Tracking Details"),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          centerTitle: true,
          title: Text("Tracking Details"),
          actions: <Widget>[
            IconButton(
              onPressed: () async {
                setbookmark.add(trackingid.toString());
                // print(setbookmark);
                setState(() {
                  setbookmark = setbookmark.toSet().toList();
                });

                var mergelist = fetchdata + setbookmark;
                print(mergelist);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setStringList('bookmarklist', mergelist);
              },
              icon: Icon(
                Icons.bookmark_border_outlined,
              ),
            ),
          ],
        ),
        body: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Name",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      // fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Artist",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    artist,
                    style: TextStyle(
                      color: Colors.white,
                      // fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Album Name",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    album,
                    style: TextStyle(
                      color: Colors.white,
                      // fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Explicit",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    explicit.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      // fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Rating",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    rating.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      // fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Lyrics",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    lyrics,
                    style: TextStyle(
                      color: Colors.white,
                      // fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    // }
  }
}
