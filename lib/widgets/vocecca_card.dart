import 'package:flutter/material.dart';

class VocecaaCard extends StatelessWidget {
  const VocecaaCard({
    Key? key,
    this.hasShadow = false,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  final bool hasShadow;
  final Widget child;
  final EdgeInsets padding;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: backgroundColor,
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 6.0,
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}
