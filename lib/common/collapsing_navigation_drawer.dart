import 'package:flutter/material.dart';
import 'package:swiftnote/common/collapsing_list_tile.dart';
import 'package:swiftnote/models/category.dart';
import 'package:swiftnote/util/constants.dart';

class CollapsingNavigationDrawer extends StatefulWidget {
  final List<Category> categories;
  CollapsingNavigationDrawer({Key key, @required this.categories})
      : super(key: key);
  @override
  _CollapsingNavigationDrawerState createState() =>
      _CollapsingNavigationDrawerState();
}

class _CollapsingNavigationDrawerState extends State<CollapsingNavigationDrawer>
    with SingleTickerProviderStateMixin {
  double maxWidth = 250;
  double minWidth = 70;
  bool isCollapsed = false;
  AnimationController _animationController;
  Animation<double> widthAnimation;
  int currentSelectedIndex = 0;
  Icon _icon;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 350));
    widthAnimation =
        Tween(begin: minWidth, end: maxWidth).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    List<Category> categories = widget.categories;
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, widget) => getWidget(context, widget, categories));
  }

  getWidget(context, widget, categories) {
    return Material(
      elevation: 2.0,
      child: Container(
        width: widthAnimation.value,
        color: kSecondaryColor,
        child: Column(
          children: [
            SizedBox(
              height: 60.0,
            ),
            categories != null
                ? Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, counter) {
                        return CollapsingListTile(
                            name: categories[counter].name,
                            animationController: _animationController,
                            isSelected: currentSelectedIndex == counter,
                            onTap: () {
                              setState(() {
                                currentSelectedIndex = counter;
                              });
                            });
                      },
                      separatorBuilder: (context, counter) {
                        return Divider(
                          height: 20.0,
                        );
                      },
                      itemCount: categories.length,
                    ),
                  )
                : SizedBox(),
            SizedBox(
              height: 60.0,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  isCollapsed = !isCollapsed;
                  isCollapsed
                      ? _animationController.forward()
                      : _animationController.reverse();
                });
              },
              child: AnimatedIcon(
                icon: AnimatedIcons.menu_close,
                progress: _animationController,
                color: Colors.white,
                size: 40.0,
              ),
            ),
            SizedBox(
              height: 20.0,
            )
          ],
        ),
      ),
    );
  }
}
