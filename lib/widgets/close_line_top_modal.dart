import 'package:flutter/material.dart';

class CloseLineTopModal extends StatelessWidget {
  const CloseLineTopModal({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      width: 150,
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.all(Radius.circular(50))
      ),
    );
  }
}