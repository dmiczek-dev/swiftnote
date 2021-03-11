import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:swiftnote/models/category.dart';
import 'package:swiftnote/models/note.dart';
import 'package:swiftnote/utils/constants.dart';
import 'package:swiftnote/utils/database_helper.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetail(this.appBarTitle, this.note);

  @override
  _NoteDetailState createState() =>
      _NoteDetailState(this.appBarTitle, this.note);
}

class _NoteDetailState extends State<NoteDetail> {
  String appBarTitle;
  Note note;
  DatabaseHelper databaseHelper = new DatabaseHelper();
  List<Category> categories;
  String selectedCategory;
  TextStyle textStyle;

  _NoteDetailState(this.appBarTitle, this.note);

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    this.textStyle = textStyle;
    if (categories == null) {
      categories = List<Category>.empty();
      getCategories();
    }

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              moveToLastScreen();
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: [
              getPicker(),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: titleController,
                  style: textStyle,
                  onChanged: (value) {
                    updateTitle();
                  },
                  decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  maxLines: 8,
                  controller: descriptionController,
                  style: textStyle,
                  onChanged: (value) {
                    updateDescription();
                  },
                  decoration: InputDecoration(
                      hintText: 'Enter your note here',
                      labelText: 'Description',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: RaisedButton(
                        color: kActiveColor,
                        textColor: Colors.white,
                        child: Text(
                          'Save',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            debugPrint('Save button clicked');
                            // _save();
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Expanded(
                        child: RaisedButton(
                      color: kActiveColor,
                      textColor: Colors.white,
                      child: Text(
                        'Delete',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          debugPrint('Delete button clicked');
                          // _delete();
                        });
                      },
                    ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onWillPop: () {
        moveToLastScreen();
      },
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void getCategories() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Category>> categoriesFuture =
          databaseHelper.getCategoryList();
      categoriesFuture.then((categories) {
        setState(() {
          this.categories = categories;
        });
      });
    });
  }

  void updateTitle() {
    note.title = titleController.text;
  }

  void updateDescription() {
    note.description = descriptionController.text;
  }

  String getCategoryById(int value) {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<Category> categoryFuture = databaseHelper.getCategoryById(value);
      categoryFuture.then((category) {
        return category.name;
      });
    });
  }

  String getCategoryAsString(int value) {
    String category;
    //todo implementacja pobrania kategorii po id z bazy
    return category;
  }

  DropdownButton<String> androidDropdown() {
    return DropdownButton(
      hint: Text('Select category...'),
      focusColor: Colors.white,
      style: textStyle,
      items: categories.map((Category category) {
        return DropdownMenuItem<String>(
          value: category.id.toString(),
          child: Text(category.name),
        );
      }).toList(),
      value: selectedCategory,
      onChanged: (valueSelectedByUser) {
        print(valueSelectedByUser);
        setState(() {
          selectedCategory = valueSelectedByUser;
        });
        note.categoryId = int.parse(valueSelectedByUser);
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (Category object in categories) {
      pickerItems.add(Text(object.name));
    }

    return CupertinoPicker(
      looping: false,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          debugPrint('User selected: ${selectedIndex}');
          note.categoryId = selectedIndex + 1;
        });
      },
      children: pickerItems,
    );
  }

  Widget getPicker() {
    if (Platform.isIOS) {
      return androidDropdown();
    } else if (Platform.isAndroid) {
      return androidDropdown();
    }
  }
}
