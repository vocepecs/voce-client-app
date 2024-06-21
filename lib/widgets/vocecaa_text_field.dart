import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VocecaaTextField extends StatefulWidget {
  const VocecaaTextField({
    Key? key,
    required this.onChanged,
    required this.label,
    required this.initialValue,
    this.maxLines = 1,
    this.enable = true,
    this.suffixIcon,
    this.enableClearTextIcon = false,
    this.floatingLabelBehavior = FloatingLabelBehavior.always,
    this.controller,
  }) : super(key: key);

  final Function(String value) onChanged;
  final String label;
  final String initialValue;
  final int maxLines;
  final bool enable;
  final Icon? suffixIcon;
  final bool enableClearTextIcon;
  final FloatingLabelBehavior floatingLabelBehavior;
  final TextEditingController? controller;

  @override
  State<VocecaaTextField> createState() => _VocecaaTextFieldState();
}

class _VocecaaTextFieldState extends State<VocecaaTextField> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    print(widget.initialValue);
    controller = TextEditingController(text: widget.initialValue);
    controller.addListener(() {
      widget.onChanged(controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enable) {
      controller.text = widget.initialValue;
    }
    return TextField(
      enabled: widget.enable,
      maxLines: widget.maxLines,
      controller: widget.controller ?? controller,
      style: GoogleFonts.poppins(),
      onChanged: (value) => widget.onChanged(value),
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          alignLabelWithHint: true,
          floatingLabelBehavior: widget.floatingLabelBehavior,
          label: Text(
            widget.label,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                style: BorderStyle.solid,
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                style: BorderStyle.solid,
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.circular(10)),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                style: BorderStyle.solid,
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.circular(10)),
          suffixIcon: widget.enableClearTextIcon
              ? controller.text.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          controller.clear();
                        });
                      },
                      child: Icon(Icons.close_rounded))
                  : Icon(Icons.search_rounded)
              : widget.suffixIcon),
      // onChanged: (value) => widget.onChanged(value),
    );
  }
}
