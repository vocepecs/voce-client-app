import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VocecaaRadioButton extends StatefulWidget {
  const VocecaaRadioButton({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  final String text;
  final Function(bool isSelected) onTap;

  @override
  _VocecaaRadioButtonState createState() => _VocecaaRadioButtonState();
}

class _VocecaaRadioButtonState extends State<VocecaaRadioButton> {
  late bool isSelcted;

  @override
  void initState() {
    super.initState();
    isSelcted = false;
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () {
          setState(() {
            isSelcted = !isSelcted;
          });
          widget.onTap(isSelcted);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 17.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            border: Border.all(width: 1, color: Colors.grey[200]!),
            color: isSelcted ? Color(0xFFFFE45E) : Colors.white,
          ),
          child: Center(
            child: Text(
              widget.text,
              style: GoogleFonts.poppins(
                fontSize: media.width * .013,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ));
  }
}
