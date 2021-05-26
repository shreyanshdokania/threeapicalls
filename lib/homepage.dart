import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'trackdet.dart';
import 'package:int2/trackdet.dart';
import 'bookmarkpage.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

bool connection = false;
StreamSubscription sub;

List data = [];
int trackingid;

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    this.getdata();
    sub = Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        connection = (result != ConnectivityResult.none);
      });
    });
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  Future<String> getdata() async {
    var response = await http.get(Uri.parse(
        'https://api.musixmatch.com/ws/1.1/chart.tracks.get?apikey=2d782bc7a52a41ba2fc1ef05b9cf40d7'));
    setState(() {
      var convertdatatoJson = json.decode(response.body);
      data = convertdatatoJson['message']['body']['track_list'];
      // print(data.length);
    });
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    if (connection == false) {
      return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          centerTitle: true,
          title: Text("Trending"),
        ),
        body: Center(
          child: Text(
            "No Internet Connection",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    } else if (data.length == 0) {
      return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          centerTitle: true,
          title: Text("Trending"),
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
          title: Text("Trending"),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                // setState(() {
                //   fetchdata.clear();
                //   bnamelist.clear();
                //   loader = false;
                // });
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Bookmarks()));
              },
              icon: Icon(
                Icons.bookmark,
              ),
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(5, 20, 5, 10),
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return FlatButton(
                onPressed: () {
                  setState(() {
                    trackingid = data[index]['track']['track_id'];
                    load = false;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Trackdet()),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  color: Colors.grey[800],
                  elevation: 7.0,
                  margin: new EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 5.0,
                      ),
                      leading: Icon(
                        Icons.library_music,
                        color: Colors.white,
                      ),
                      title: Text(
                        data[index]['track']['track_name'].toString(),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 100, 0),
                        child: Text(
                          data[index]['track']['album_name'],
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      trailing: Icon(
                        Icons.navigate_next,
                        color: Colors.white,
                      )),
                ),
              );
            },
          ),
        ),
      );
    }
  }
}
