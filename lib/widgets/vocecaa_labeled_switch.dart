import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VocecaaLabeledSwitch extends StatefulWidget {
  const VocecaaLabeledSwitch({
    Key? key,
    this.widthFactor = .13,
    required this.onChange,
    this.switchInitialValue = false,
    required this.label,
  }) : super(key: key);

  final String label;
  final double widthFactor;
  final Function(bool value) onChange;
  final bool switchInitialValue;

  @override
  State<VocecaaLabeledSwitch> createState() => _VocecaaLabeledSwitchState();
}

class _VocecaaLabeledSwitchState extends State<VocecaaLabeledSwitch> {
  late bool isSwitchedOn;

  @override
  initState() {
    super.initState();
    isSwitchedOn = widget.switchInitialValue;
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      width: media.width * widget.widthFactor,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        color: Colors.grey[200],
      ),
      child: ListTile(
        dense: true,
        title: AutoSizeText(
          widget.label,
          maxLines: 1,
          style: GoogleFonts.poppins(
            fontSize: orientation == Orientation.landscape
                ? media.width * .012
                : media.height * .018,
          ),
        ),
        trailing: SizedBox(
          child: CupertinoSwitch(
            value: isSwitchedOn,
            onChanged: (value) {
              setState(() {
                isSwitchedOn = value;
              });
              widget.onChange(value);
            },
          ),
        ),
      ),
    );
  }
}
