import 'package:flutter/material.dart';
import 'package:voce/models/constants/constant_graphics.dart';

class TablePlaceholder2 extends StatelessWidget {
  const TablePlaceholder2({
    Key? key,
    this.isSelected = false,
  }) : super(key: key);

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: isSelected ? ConstantGraphics.colorYellow: Colors.grey[400],
          borderRadius: BorderRadius.all(Radius.circular(5))),
      width: 75,
      height: 75,
      child: VerticalDivider(
        color: Colors.white,
        thickness: 3,
      ),
    );
  }
}

class TablePlaceholder2Icon extends StatelessWidget {
  const TablePlaceholder2Icon({
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
        children: [
          Center(
            child: VerticalDivider(
              color: Colors.white,
              thickness: 3,
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 25 / 2 - 1,
              height: 25 ,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.horizontal(left: Radius.circular(5)),
                color: highlightSectionList[0]
                    ? ConstantGraphics.colorYellow
                    : null,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 25 / 2 - 1,
              height: 25 ,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.horizontal(right: Radius.circular(5)),
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
