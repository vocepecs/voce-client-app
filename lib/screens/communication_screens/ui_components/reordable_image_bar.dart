import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';

class ReordableImageBar extends StatelessWidget {
  const ReordableImageBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ReorderableListView(children: <Widget>[
        Container(
          // key: ValueKey(Random().nextInt(10)),
          width: 50,
          height: 50,
          color: Colors.black,
        ),
        Container(
          key: ValueKey(Random().nextInt(10)),
          width: 50,
          height: 50,
          color: Colors.black,
        )
      ], onReorder: (oldPosition, newPosition) {}),
    );
  }
}
