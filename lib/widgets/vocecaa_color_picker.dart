import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

class VocecaaColorPicker extends StatefulWidget {
  const VocecaaColorPicker({
    Key? key,
    required this.onColorChange,
  }) : super(key: key);

  final Function(Color colorSelected) onColorChange;

  @override
  _VocecaaColorPickerState createState() => _VocecaaColorPickerState();
}

class _VocecaaColorPickerState extends State<VocecaaColorPicker> with AutomaticKeepAliveClientMixin{
  // Color for the picker shown in Card on the screen.
  late Color screenPickerColor;
  // Color for the picker in a dialog using onChanged.
  late Color dialogPickerColor;
  // Color for picker using the color select dialog.
  late Color dialogSelectColor;

  @override
  void initState() {
    super.initState();
    screenPickerColor = Colors.blue; // Material blue.
    dialogPickerColor = Colors.red; // Material red.
    dialogSelectColor = const Color(0xFFA239CA); // A purple color.
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    super.build(context); 
    return ColorPicker(
      // Use the screenPickerColor as start color.
      color: screenPickerColor,
      // Update the screenPickerColor using the callback.
      onColorChanged: (Color color) =>
          setState(() {
            screenPickerColor = color;
            widget.onColorChange(color);
          }),
      width: media.width < 600 ? 30 : 40,
      height: media.width < 600 ? 30 : 40,
      borderRadius: 22,
      enableShadesSelection: false,
      elevation: 2,
      pickersEnabled: {
        ColorPickerType.primary: true,
        ColorPickerType.accent: false,
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
