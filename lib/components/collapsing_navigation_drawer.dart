import 'package:flutter/material.dart';
import 'package:swiftnote/components/collapsing_list_tile.dart';
import 'package:swiftnote/models/category.dart';
import 'package:swiftnote/utils/constants.dart';

class CollapsingNavigationDrawer extends StatefulWidget {
  final List<Category> categories;
  final Function callback;
  final Function callId;
  CollapsingNavigationDrawer(
      {Key key,
      @required this.categories,
      @required this.callback,
      @required this.callId})
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
    Function callback = widget.callback;
    Function callId = widget.callId;
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, widget) =>
            getWidget(context, widget, categories, callback, callId));
  }

  getWidget(context, widget, categories, callback, callId) {
    return Material(
      elevation: 2.0,
      child: Container(
        width: widthAnimation.value,
        color: kPrimaryColor,
        child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            categories != null
                ? Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, counter) {
                        return CollapsingListTile(
                          category: categories[counter],
                          animationController: _animationController,
                          isSelected: currentSelectedIndex == counter,
                          onTap: () {
                            setState(() {
                              currentSelectedIndex = counter;
                            });
                            callId(categories[counter].id);
                          },
                          onDeleteTap: () {
                            callback(context, categories[counter]);
                            currentSelectedIndex = 0;
                          },
                        );
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
