import 'dart:convert';

import 'package:flutter/material.dart';

mixin ImageCoverMixin {
  Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String.substring(2, base64String.length - 1)),
    );
  }
}
