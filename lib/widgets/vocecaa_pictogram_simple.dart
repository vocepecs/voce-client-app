import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:voce/models/image.dart';

class VocecaaPictogramSimple extends StatelessWidget {
  const VocecaaPictogramSimple({
    Key? key,
    required this.caaImageStringCoding,
    this.onTap,
    this.widthFactor = .07,
    this.eightFactor = .1,
  }) : super(key: key);

  final String caaImageStringCoding;
  final Function()? onTap;
  final double widthFactor;
  final double eightFactor;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => onTap!(),
      child: Container(
        width: media.width * widthFactor,
        height: media.height * eightFactor,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          color: Colors.white,
        ),
        child: _imageFromBase64String(caaImageStringCoding),
      ),
    );
  }

  Image _imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String.substring(2, base64String.length - 1)),
    );
  }
}
