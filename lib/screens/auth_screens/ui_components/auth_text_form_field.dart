import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthTextFormField extends StatefulWidget {
  const AuthTextFormField({
    Key? key,
    required this.onChanged,
    required this.label,
    this.initialValue,
    this.hintText,
    this.obscurable = false,
  }) : super(key: key);

  final String? initialValue;
  final Function(String value) onChanged;
  final String label;
  final String? hintText;
  final bool obscurable;

  @override
  State<AuthTextFormField> createState() => _AuthTextFormFieldState();
}

class _AuthTextFormFieldState extends State<AuthTextFormField> {

  bool _obscureText = true;


  @override
  Widget build(BuildContext context) {
    final double scaleBase = MediaQuery.of(context).size.width < 600
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: GoogleFonts.poppins(
              color: Colors.black87,
              fontSize: scaleBase * .016,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.0),
          TextFormField(
            key: Key(widget.label),
            style: TextStyle(color: Colors.black87),
            cursorColor: Colors.black87,
            obscureText: widget.obscurable ? _obscureText : false,
            initialValue: widget.initialValue,
            decoration: InputDecoration(
              fillColor: Colors.grey[200],
              filled: true,
              hintText: widget.hintText,
              labelStyle: GoogleFonts.poppins(
                color: Colors.black87,
                fontSize: scaleBase * .018,
                fontWeight: FontWeight.w500,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.grey[200]!, width: 0), // changed this
                borderRadius: BorderRadius.circular(10.0), // added this
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.grey[200]!, width: 0), // changed this
                borderRadius: BorderRadius.circular(10.0), // added this
              ),
              suffixIcon: widget.obscurable ? IconButton(
                // added this
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black87,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ) : null,
            ),
            onChanged: (value) => widget.onChanged(value),
          ),
        ],
      ),
    );
  }
}
