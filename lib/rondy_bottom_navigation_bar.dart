library rondy_bottom_navigation_bar;

import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:rondy_bottom_navigation_bar/model/rondy_bar_item.dart';

class RondyBottomNavigationBar extends StatefulWidget {
  final TextStyle activeTextStyle;
  final TextStyle textStyle;
  final Color iconColor;
  final Color activeIconColor;
  final List<RondyBarItem> items;
  final Function(int index) onItemClick;

  const RondyBottomNavigationBar(
      {Key key,
      @required this.activeTextStyle,
      @required this.textStyle,
      @required this.iconColor,
      @required this.activeIconColor,
      @required this.items,
      @required this.onItemClick})
      : super(key: key);

  @override
  _RondyBottomNavigationBarState createState() =>
      _RondyBottomNavigationBarState();
}

class _RondyBottomNavigationBarState extends State<RondyBottomNavigationBar> {
  int selectedIndex = 0;
  Widget _createContainer(List<Widget> tiles) {
    return DefaultTextStyle.merge(
      overflow: TextOverflow.ellipsis,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: tiles,
      ),
    );
  }

  _onInternalItemClick(int index) {
    setState(() {
      selectedIndex = index;
    });
    widget.onItemClick(index);
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));
    assert(debugCheckHasMaterialLocalizations(context));
    assert(debugCheckHasMediaQuery(context));

    // Labels apply up to _bottomMargin padding. Remainder is media padding.
    final double additionalBottomPadding =
        math.max(MediaQuery.of(context).padding.bottom / 2.0, 0.0);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(32),
        ),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: 90 + additionalBottomPadding,
            minHeight: 90 + additionalBottomPadding),
        child: Padding(
          padding: EdgeInsets.only(bottom: additionalBottomPadding),
          child: _createContainer(
            List.generate(
              widget.items.length,
              (index) {
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => _onInternalItemClick(index),
                  child: _RondyBottomNavigationBarItem(
                    active: index == selectedIndex,
                    activeTextStyle: widget.activeTextStyle,
                    activeIconColor: widget.activeIconColor,
                    textStyle: widget.textStyle,
                    iconColor: widget.iconColor,
                    rondyBarItem: widget.items[index],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _RondyBottomNavigationBarItem extends StatelessWidget {
  final bool active;
  final TextStyle activeTextStyle;
  final TextStyle textStyle;
  final Color iconColor;
  final Color activeIconColor;
  final RondyBarItem rondyBarItem;

  const _RondyBottomNavigationBarItem(
      {Key key,
      @required this.active,
      @required this.activeTextStyle,
      @required this.textStyle,
      @required this.iconColor,
      @required this.activeIconColor,
      @required this.rondyBarItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            rondyBarItem.icon,
            size: 38.0,
            color: active ? activeIconColor : iconColor,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Text(
              rondyBarItem.label,
              style: active ? activeTextStyle : textStyle,
            ),
          ),
        ],
      ),
    );
  }
}
