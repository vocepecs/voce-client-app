import 'package:flutter/material.dart';

class VocecaaButton extends StatelessWidget {
  const VocecaaButton({
    Key? key,
    required this.color,
    required this.text,
    required this.onTap,
    this.padding = const EdgeInsets.symmetric(
      vertical: 8.0,
      horizontal: 13.0,
    ),
    this.borderRadius = 10.0,
  }) : super(key: key);

  final Color color;
  final Widget text;
  final Function() onTap;
  final EdgeInsets padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          color: color,
        ),
        child: Center(
          child: text,
        ),
      ),
    );
  }
}
