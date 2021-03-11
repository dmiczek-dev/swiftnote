import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:swiftnote/components/collapsing_navigation_drawer.dart';
import 'package:swiftnote/models/category.dart';
import 'package:swiftnote/models/note.dart';
import 'package:swiftnote/screens/note_detail.dart';
import 'package:swiftnote/utils/constants.dart';
import 'package:swiftnote/utils/database_helper.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteList createState() => _NoteList();
}

class _NoteList extends State<NoteList> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  List<Category> categories;
  Category category = Category('');
  int currentCatId;

  TextEditingController nameController = TextEditingController();
  GlobalKey<CircularMenuState> key = GlobalKey<CircularMenuState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    if (categories == null) {
      categories = List<Category>.empty();
      updateDrawerView();
    }

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: kSecondaryColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: kSecondaryColor,
        title: Text('SwiftNote'),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            Container(),
            CollapsingNavigationDrawer(
                categories: categories,
                callback: _showDeleteDialog,
                callId: _setCurrentCategory),
            CircularMenu(
              key: key,
              toggleButtonMargin: 20.0,
              startingAngleInRadian: 3.4,
              endingAngleInRadian: 4.4,
              radius: 100.0,
              toggleButtonBoxShadow: [BoxShadow(blurRadius: 0.0)],
              alignment: Alignment.bottomRight,
              toggleButtonAnimatedIconData: AnimatedIcons.add_event,
              toggleButtonColor: kActiveColor,
              curve: Curves.ease,
              items: [
                CircularMenuItem(
                  boxShadow: [BoxShadow(blurRadius: 0.0)],
                  iconColor: kActiveColor,
                  icon: Icons.playlist_add,
                  color: Colors.white,
                  onTap: () {
                    key.currentState.reverseAnimation();

                    _showCreateDialog(context);
                  },
                ),
                CircularMenuItem(
                  boxShadow: [BoxShadow(blurRadius: 0.0)],
                  iconColor: kActiveColor,
                  icon: Icons.note_add,
                  color: Colors.white,
                  onTap: () {
                    print(currentCatId);
                    navigateToDetail(
                        Note('', '', '', currentCatId), 'Add Note');
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Container(
          height: 20.0,
          child: Text(
            message,
            style: TextStyle(color: Colors.white, fontSize: 14.0),
          )),
      backgroundColor: kActiveColor,
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void updateDrawerView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Category>> categoriesFuture =
          databaseHelper.getCategoryList();
      categoriesFuture.then((categories) {
        setState(() {
          this.categories = categories;
          this.currentCatId = categories[0].id;
        });
      });
    });
  }

  void updateListView() {}

  void navigateToDetail(Note note, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(title, note);
    }));

    if (result) {
      updateListView();
    }
  }

  Future<void> _setCurrentCategory(currentId) async {
    this.currentCatId = currentId;
  }

  Future<void> _showCreateDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Create new category'),
            content: TextField(
              controller: nameController,
              onChanged: (value) {
                updateName();
              },
              decoration: InputDecoration(
                  hintText: 'Type category name',
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kActiveColor))),
            ),
            actions: [
              FlatButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  child: Text('Cancel')),
              FlatButton(
                  onPressed: () {
                    _save();
                    updateDrawerView();
                    Navigator.pop(context);
                  },
                  child: Text('Save')),
            ],
          );
        });
  }

  Future<void> _showDeleteDialog(
      BuildContext context, Category category) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Warning'),
            content: Text('The category and notes will be deleted'),
            actions: [
              FlatButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  child: Text('Cancel')),
              FlatButton(
                  onPressed: () {
                    _delete(category);
                    updateDrawerView();
                    Navigator.pop(context);
                  },
                  child: Text('Confirm')),
            ],
          );
        });
  }

  void updateName() {
    category.name = nameController.text;
  }

  void _save() async {
    int result;
    result = await databaseHelper.insertCategory(category);
    if (result != 0) {
      _showSnackBar('Category saved successfully');
      nameController.clear();
    } else {
      _showSnackBar('Something went wrong');
    }
  }

  void _delete(Category category) async {
    int result = await databaseHelper.deleteCategory(category.id);
    if (result != 0) {
      _showSnackBar('Category deleted successfully');
      updateDrawerView();
    }
  }
}
