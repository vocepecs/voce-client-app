import 'package:flutter/material.dart';

class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.all(Radius.circular(5))),
      width: 75,
      height: 75,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          color: Colors.white,
          size: 75,
        ),
      ),
    );
  }
}
