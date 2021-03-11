import 'package:flutter/cupertino.dart';
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
          canvasColor: kActiveColor,
          cupertinoOverrideTheme: CupertinoThemeData(
              textTheme: CupertinoTextThemeData(
                  pickerTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          )))),
      home: NoteList(),
    );
  }
}
