import 'package:flutter/material.dart';
import 'package:swiftnote/screens/note_list.dart';
import 'package:swiftnote/utils/constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swiftnote',
      theme: ThemeData.dark().copyWith(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: kPrimaryColor,
      ),
      home: NoteList(),
    );
  }
}
