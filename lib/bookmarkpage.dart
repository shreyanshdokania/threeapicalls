import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'trackdet.dart';
import 'homepage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

List<String> fetchdata;
String bname;
List<String> bnamelist = [];
List<int> ids = [];
bool loader = false;

class Bookmarks extends StatefulWidget {
  @override
  _BookmarksState createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  @override
  void initState() {
    super.initState();
    getbookmarkdata();
  }

  getbookmarkdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fetchdata = prefs.getStringList('bookmarklist');
    });
    fetchdata = fetchdata.toSet().toList();
    // print(fetchdata);
    getdata4();
  }

  Future<String> getdata4() async {
    if (fetchdata.length != 0) {
      for (int i = 0; i < fetchdata.length; i++) {
        int id = int.parse(fetchdata[i]);
        var response = await http.get(Uri.parse(
            'https://api.musixmatch.com/ws/1.1/track.get?track_id=$id&apikey=2d782bc7a52a41ba2fc1ef05b9cf40d7'));
        // print(response.body);
        setState(() {
          var convertdatatoJson2 = json.decode(response.body);
          bname = convertdatatoJson2['message']['body']['track']['track_name'];
          int iden = convertdatatoJson2['message']['body']['track']['track_id'];
          bnamelist.add(bname);
          ids.add(iden);
        });
      }
      setState(() {
        bnamelist = bnamelist.toSet().toList();
        ids = ids.toSet().toList();
      });
      print(bnamelist);
      print(ids);
    }
    loader = true;
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    if (loader == false) {
      return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'BookMarks',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
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
          title: Text(
            'BookMarks',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () async {
                // SharedPreferences prefs = await SharedPreferences.getInstance();
                // prefs.clear();
              },
              icon: Icon(
                Icons.clear_all_rounded,
              ),
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(5, 20, 5, 10),
          child: ListView.builder(
            itemCount: bnamelist.length,
            itemBuilder: (BuildContext context, int index) {
              return FlatButton(
                onPressed: () {
                  setState(() {
                    trackingid = ids[index];
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
                      bnamelist[index],
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
  }
}
