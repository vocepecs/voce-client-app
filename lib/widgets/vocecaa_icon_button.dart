import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VocecaaIconButton extends StatelessWidget {
  const VocecaaIconButton({
    Key? key,
    required this.color,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  final Color color;
  final Widget icon;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        height: media.height * 0.1,
        width: media.width * 0.1,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: Center(
          child: icon,
        ),
      ),
    );
  }
}
