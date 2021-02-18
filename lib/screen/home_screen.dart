import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:swiftnote/common/collapsing_navigation_drawer.dart';
import 'package:swiftnote/models/category.dart';
import 'package:swiftnote/util/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Category> categories;

  @override
  Widget build(BuildContext context) {
    if (categories == null) {
      categories = List<Category>.filled(3, Category('Test'));
    }

    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
            CollapsingNavigationDrawer(categories: categories),
            CircularMenu(
              toggleButtonMargin: 20.0,
              startingAngleInRadian: 3.4,
              endingAngleInRadian: 4.4,
              radius: 100.0,
              toggleButtonBoxShadow: [BoxShadow(blurRadius: 0.0)],
              alignment: Alignment.bottomRight,
              toggleButtonAnimatedIconData: AnimatedIcons.add_event,
              toggleButtonColor: kActiveColor,
              items: [
                CircularMenuItem(
                  boxShadow: [BoxShadow(blurRadius: 0.0)],
                  iconColor: kActiveColor,
                  icon: Icons.playlist_add,
                  color: Colors.white,
                  onTap: () {
                    setState(() {});
                  },
                ),
                CircularMenuItem(
                  boxShadow: [BoxShadow(blurRadius: 0.0)],
                  iconColor: kActiveColor,
                  icon: Icons.note_add,
                  color: Colors.white,
                  onTap: () {
                    setState(() {});
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
