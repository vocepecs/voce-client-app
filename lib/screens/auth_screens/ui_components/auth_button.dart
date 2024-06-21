import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    Key? key,
    required this.onTap,
    required this.label,
    this.color = const Color(0xffffe45e),
  }) : super(key: key);

  final Function() onTap;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final double scaleBase = MediaQuery.of(context).size.width < 600
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width;

    bool smallScreen = MediaQuery.of(context).size.width < 600;

    return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.all(12)),
        backgroundColor: MaterialStateProperty.all(color),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => Container(
          width: smallScreen ? scaleBase * .36 : scaleBase * .42,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.black87,
              fontSize: scaleBase * .016,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
