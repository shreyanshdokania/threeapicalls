import 'package:flutter/material.dart';
import 'homepage.dart';

//this project is contributed by Shreyansh Dokania (shreyanshdokania@gmail.com)

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Homepage(),
      ),
    );
  }
}
