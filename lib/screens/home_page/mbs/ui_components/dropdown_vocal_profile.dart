import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/add_new_patient_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';

class DropDownVocalProfile extends StatefulWidget {
  const DropDownVocalProfile({
    Key? key,
    required this.initialValue,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  final String initialValue;
  final List<String> items;
  final Function(String?) onChanged;

  @override
  State<DropDownVocalProfile> createState() => _DropDownVocalProfileState();
}

class _DropDownVocalProfileState extends State<DropDownVocalProfile> {
  String? vocalProfileValue;

  @override
  void initState() {
    super.initState();
    vocalProfileValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return DropdownButton<String>(
    value: vocalProfileValue,
    icon: Icon(Icons.arrow_downward, size: media.width < 600 ? 18: 22,),
    elevation: 16,
    underline: Container(
      height: 2,
      color: ConstantGraphics.colorBlue,
    ),
    onChanged: (String? newValue) {
      setState(() {
        vocalProfileValue = newValue;
      });
      widget.onChanged(newValue);
    },
    items: widget.items.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: media.width < 600 ? 12 : 16,
          ),
        ),
      );
    }).toList(),
      );
  }
}
