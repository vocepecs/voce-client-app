import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/models/constants/constant_graphics.dart';

class VocecaaSearchBar extends StatefulWidget {
  const VocecaaSearchBar({
    Key? key,
    required this.hintText,
    this.paddingRatio = .01,
    this.marginRatio = .04,
    this.inputContainerWidthRatio = .5,
    this.onIconButtonPressed,
    this.onTextChange,
    this.suffixIcon = Icons.search,
    this.showSuffixIcon = true,
    this.hasShadow = true,
    this.controller,
  }) : super(key: key);

  final String hintText;
  final double paddingRatio;
  final double marginRatio;
  final double inputContainerWidthRatio;
  final Function()? onIconButtonPressed;
  final Function(String value)? onTextChange;
  final IconData suffixIcon;
  final bool showSuffixIcon;
  final bool hasShadow;
  final TextEditingController? controller;

  @override
  State<VocecaaSearchBar> createState() => _VocecaaSearchBarState();
}

class _VocecaaSearchBarState extends State<VocecaaSearchBar> {
  // final TextEditingController _typeAheadController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.orientationOf(context);
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: media.width * widget.paddingRatio),
      margin:
          EdgeInsets.symmetric(horizontal: media.width * widget.marginRatio),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
        border: widget.hasShadow
            ? null
            : Border.all(
                width: 1,
                style: BorderStyle.solid,
                color: Colors.black54,
              ),
        boxShadow: widget.hasShadow
            ? [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 6.0,
                ),
              ]
            : null,
      ),
      child: Container(
        width: media.width * widget.inputContainerWidthRatio,
        margin: widget.inputContainerWidthRatio < .5
            ? const EdgeInsets.all(0)
            : const EdgeInsets.all(5),
        child: TextField(
          controller: widget.controller,
          onChanged: (value) => widget.onTextChange!(value),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
            labelText: widget.hintText,
            suffixIcon: widget.showSuffixIcon
                ? IconButton(
                    onPressed: () => widget.onIconButtonPressed!(),
                    icon: Icon(
                      widget.suffixIcon,
                      size: orientation == Orientation.landscape ? media.width * 0.02 : media.height * .02,
                    ),
                  )
                : null,
            labelStyle: GoogleFonts.poppins(
                color: Colors.black54,
                fontSize: orientation == Orientation.landscape ? widget.inputContainerWidthRatio < .5
                    ? media.width * .012
                    : media.width * .014 : media.height * .016),
          ),
        ),
      ),
    );
  }
}
