import 'package:flutter/material.dart';

class AudioPlaceholder extends StatelessWidget {
  const AudioPlaceholder({Key? key}) : super(key: key);

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
          Icons.mic,
          color: Colors.white,
          size: 75,
        ),
      ),
    );
  }
}
