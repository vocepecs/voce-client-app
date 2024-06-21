import 'dart:ui';

import 'package:voce/models/image.dart';

class CaaImageImageBar {
  CaaImageImageBar(CaaImage image, int color) {
    this._image = image;
    this._color = color;
  }

  late final CaaImage _image;
  late final int _color;

  int get color => this._color;
  CaaImage get image => this._image;
}
