import 'package:flutter/material.dart';
import 'package:voce/models/constants/constant_graphics.dart';

class TablePlaceholder1 extends StatelessWidget {
  const TablePlaceholder1({
    Key? key,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  final bool isSelected;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color:
                isSelected ? ConstantGraphics.colorYellow : Colors.grey[400],
            borderRadius: BorderRadius.all(Radius.circular(5))),
        width: 75,
        height: 75,
      ),
    );
  }
}

class TablePlaceholder1Icon extends StatelessWidget {
  const TablePlaceholder1Icon({
    Key? key,
    this.isHighlighted = false,
  }) : super(key: key);

  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color:
              isHighlighted ? ConstantGraphics.colorYellow : Colors.grey[400],
          borderRadius: BorderRadius.all(Radius.circular(5))),
      width: 25,
      height: 25,
    );
  }
}
