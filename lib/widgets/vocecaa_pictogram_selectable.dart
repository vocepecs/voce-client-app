import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/models/image.dart';

class VocecaaPictogramSelectable extends StatefulWidget {
  const VocecaaPictogramSelectable({
    Key? key,
    required this.caaImage,
    required this.onTap,
    this.color = const Color(0xff7fc8f8),
    this.widthFactor = .11,
    this.heightFactor = .08,
    this.fontSizeFactor = .014,
    required this.isSelected,
  }) : super(key: key);

  final CaaImage caaImage;
  final Color color;
  final Function(bool isSelected) onTap;
  final double widthFactor, heightFactor;
  final double fontSizeFactor;
  final bool isSelected;

  @override
  State<VocecaaPictogramSelectable> createState() =>
      _VocecaaPictogramSelectableState();
}

class _VocecaaPictogramSelectableState
    extends State<VocecaaPictogramSelectable> {
  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return GestureDetector(
      onTap: () {
        widget.onTap(!widget.isSelected);
      },
      child: Container(
        height: media.width * widget.heightFactor,
        width: media.width * widget.widthFactor,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: media.width * widget.heightFactor,
              width: media.width * widget.widthFactor,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                border: Border.all(
                  color: Colors.black87,
                  width: 1,
                ),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Container(
                      // height: media.width * .05,
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(15))),
                      child:
                          imageFromBase64String(widget.caaImage.stringCoding),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        color: widget.color,
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(15))),
                    child: Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          widget.caaImage.label,
                          style: GoogleFonts.poppins(
                            fontSize: media.width * widget.fontSizeFactor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            widget.isSelected
                ? Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: EdgeInsets.only(
                        left: 5,
                        top: 5,
                      ),
                      width:
                          isLandscape ? media.width * .025 : media.height * .03,
                      height:
                          isLandscape ? media.width * .025 : media.height * .03,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green[300],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.check_circle_outline_rounded,
                          size: isLandscape
                              ? media.width * .025
                              : media.height * .03,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String.substring(2, base64String.length - 1)),
    );
  }
}
