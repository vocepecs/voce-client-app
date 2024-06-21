import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VocecaaSelectablePill extends StatelessWidget {
  const VocecaaSelectablePill({
    Key? key,
    required this.label,
    this.nonSelectedColor = const Color(0xFFE0E0E0),
    this.selectedColor = const Color(0xFFFFE45E),
    required this.onTap,
    required this.isSelected,
  }) : super(key: key);

  final String label;
  final Color nonSelectedColor;
  final Color selectedColor;
  final Function(bool isSelected) onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        onTap(isSelected);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        decoration: BoxDecoration(
            color: isSelected ? selectedColor : nonSelectedColor,
            borderRadius: BorderRadius.all(Radius.circular(25))),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: media.width * .013,
          ),
        ),
      ),
    );
  }
}
