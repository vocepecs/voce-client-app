import 'package:flutter/material.dart';

class VocecaaRadioIconButton extends StatefulWidget {
  const VocecaaRadioIconButton({
    Key? key,
    required this.icon,
    required this.onTap
  }) : super(key: key);

  final Icon icon;
  final Function(bool value) onTap;

  @override
  _VocecaaRadioIconButtonState createState() => _VocecaaRadioIconButtonState();
}

class _VocecaaRadioIconButtonState extends State<VocecaaRadioIconButton> {

  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = false;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 1,
          color: Colors.grey[200]!,
        ),
        color: isChecked ? Color(0xFFFFE45E) : Colors.white,
      ),
      child: Center(
        child: IconButton(
          onPressed: () {
            setState(() {
              isChecked = !isChecked;
            });
            widget.onTap(isChecked);
          },
          icon: widget.icon,
        ),
      ),
    );
  }
}
