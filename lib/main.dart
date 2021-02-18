import 'package:flutter/material.dart';
import 'package:swiftnote/screen/home_screen.dart';
import 'package:swiftnote/util/constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swiftnote',
      theme: ThemeData.dark().copyWith(primaryColor: kPrimaryColor,scaffoldBackgroundColor: kPrimaryColor),
      home: HomeScreen(),
    );
  }
}
