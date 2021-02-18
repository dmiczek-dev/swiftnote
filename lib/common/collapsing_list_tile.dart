import 'package:flutter/material.dart';
import 'package:swiftnote/util/constants.dart';

class CollapsingListTile extends StatefulWidget {
  final String name;
  final AnimationController animationController;
  final bool isSelected;
  final Function onTap;
  final Function onDeleteTap;

  CollapsingListTile(
      {@required this.name,
      @required this.animationController,
      this.isSelected,
      this.onTap,
      this.onDeleteTap});

  @override
  _CollapsingListTileState createState() => _CollapsingListTileState();
}

class _CollapsingListTileState extends State<CollapsingListTile> {
  Animation<double> widthAnimation, sizedBoxAnimation;

  @override
  void initState() {
    super.initState();
    widthAnimation =
        Tween<double>(begin: 70, end: 250).animate(widget.animationController);
    sizedBoxAnimation =
        Tween<double>(begin: 0, end: 10).animate((widget.animationController));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
          color: widget.isSelected ? kActiveColor : Colors.transparent,
        ),
        width: widthAnimation.value,
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              child: Text(
                widget.name[0],
                style: TextStyle(
                    color: widget.isSelected ? Colors.white : Colors.white30),
              ),
            ),
            // Icon(
            //   widget.icon,
            //   color: widget.isSelected ? Colors.white : Colors.white30,
            //   size: 38.0,
            // ),
            SizedBox(
              width: sizedBoxAnimation.value,
            ),
            widthAnimation.value >= 220
                ? InkWell(
                    onTap: widget.onDeleteTap,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius:
                              BorderRadius.all(Radius.circular(16.0))),
                      child: Text(
                        'Delete',
                        style: kListTileSelectedTextStyle,
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
