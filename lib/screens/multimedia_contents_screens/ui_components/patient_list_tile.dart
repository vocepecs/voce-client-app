import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PatientListTile extends StatefulWidget {
  const PatientListTile({
    Key? key,
    required this.patientName,
    required this.onTap,
  }) : super(key: key);

  final String patientName;
  final Function(bool isSelected) onTap;

  @override
  State<PatientListTile> createState() => _PatientListTileState();
}

class _PatientListTileState extends State<PatientListTile> {
  late bool _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });
        widget.onTap(_isSelected);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              width: 1,
              color: Colors.grey[200]!,
            )),
        child: ListTile(
          title: Text(
            widget.patientName,
            style: GoogleFonts.poppins(),
          ),
          trailing: _isSelected
              ? Icon(
                  Icons.check_box_rounded,
                  color: Theme.of(context).primaryColor,
                )
              : Icon(Icons.check_box_outline_blank_rounded),
        ),
      ),
    );
  }
}
