import 'package:flutter/material.dart';
import 'package:voce/models/constants/constant_graphics.dart';

class TablePlaceholder3 extends StatelessWidget {
  const TablePlaceholder3({
    Key? key,
    this.isSelected = false,
  }) : super(key: key);

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color:isSelected ? ConstantGraphics.colorYellow : Colors.grey[400],
          borderRadius: BorderRadius.all(Radius.circular(5))),
      width: 75,
      height: 75,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Divider(
            color: Colors.white,
            thickness: 3,
            endIndent: 37.5,
          ),
          Align(
            alignment: Alignment.center,
            child: VerticalDivider(
              color: Colors.white,
              thickness: 3,
            ),
          ),
        ],
      ),
    );
  }
}

class TablePlaceholder3Icon extends StatelessWidget {
  const TablePlaceholder3Icon({
    Key? key,
    required this.highlightSectionList,
  }) : super(key: key);

  final List<bool> highlightSectionList;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.all(Radius.circular(5))),
      width: 25,
      height: 25,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Divider(
            color: Colors.white,
            thickness: 3,
            endIndent: 37.5 / 3,
          ),
          Align(
            alignment: Alignment.center,
            child: VerticalDivider(
              color: Colors.white,
              thickness: 3,
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 25 / 2 - 1,
              height: 25 / 2 - 1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(5)),
                color: highlightSectionList[0]
                    ? ConstantGraphics.colorYellow
                    : null,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              width: 25 / 2 - 1,
              height: 25 / 2 - 1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5)),
                color: highlightSectionList[2]
                    ? ConstantGraphics.colorYellow
                    : null,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 25 / 2 - 1,
              height: 25,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.horizontal(right: Radius.circular(5)),
                color: highlightSectionList[1]
                    ? ConstantGraphics.colorYellow
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
