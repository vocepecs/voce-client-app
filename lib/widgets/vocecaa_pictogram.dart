import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/models/image.dart';

class VocecaaPictogram extends StatefulWidget {
  const VocecaaPictogram({
    Key? key,
    required this.caaImage,
    this.color = const Color(0xff7fc8f8),
    this.onTap,
    this.onDeletePress,
    this.widthFactor = .11,
    this.heightFactor = .08,
    this.fontSizeFactor = .014,
    this.isErasable = false,
  }) : super(key: key);

  final CaaImage caaImage;
  final Color color;
  final Function()? onTap;
  final Function()? onDeletePress;
  final bool isErasable;
  final double widthFactor, heightFactor;
  final double fontSizeFactor;

  @override
  State<VocecaaPictogram> createState() => _VocecaaPictogramState();
}

class _VocecaaPictogramState extends State<VocecaaPictogram> {
  bool showDeleteOption = false;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return GestureDetector(
      onDoubleTap: widget.isErasable
          ? () {
              setState(() {
                showDeleteOption = !showDeleteOption;
              });
            }
          : null,
      onTap: () => widget.onTap!(),
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
                children: [
                  Expanded(
                    child: Container(
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
            widget.isErasable && showDeleteOption
                ? Container(
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
                      color: Colors.black.withOpacity(0.7),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            widget.onDeletePress!();
                            setState(() {
                              showDeleteOption = false;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                )),
                            child: Icon(
                              Icons.delete_forever_rounded,
                              color: Colors.white,
                              size: orientation == Orientation.landscape
                                  ? media.width * .03
                                  : media.height * .03,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showDeleteOption = !showDeleteOption;
                            });
                          },
                          child: Text(
                            'Annulla',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: orientation == Orientation.landscape
                                  ? media.width * .015
                                  : media.height * .015,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ))
                : Container(),
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
