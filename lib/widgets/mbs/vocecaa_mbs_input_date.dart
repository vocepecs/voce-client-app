import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/widgets/vocecaa_button.dart';

class VocecaaMbsInputDate extends StatefulWidget {
  const VocecaaMbsInputDate({
    Key? key,
    required this.onSetDate,
    this.dateFormat = 'dd-MMM-yyyy',
    this.colorTheme = const Color(0xff7fc8f8),
    this.limitUpToday = false,
    this.initialDate,
    this.titleLabel,
  }) : super(key: key);

  final Function(DateTime date) onSetDate;
  final DateTime? initialDate;
  final String? titleLabel;
  final String dateFormat;
  final Color colorTheme;
  final bool limitUpToday;

  @override
  _VocecaaMbsInputDateState createState() => _VocecaaMbsInputDateState();
}

class _VocecaaMbsInputDateState extends State<VocecaaMbsInputDate> {
  late DateTime _dateSelected;
  final DateTime _dateUpLimit = DateTime(DateTime.now().year + 10);
  final DateTime _dateDownLimit = DateTime(DateTime.now().year - 90);

  @override
  void initState() {
    super.initState();
    _dateSelected = widget.initialDate ??
        (widget.limitUpToday ? DateTime(1991, 10, 12) : DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
      margin: EdgeInsets.fromLTRB(
        media.width * .25,
        0,
        media.width * .25,
        20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 3,
            width: media.width * 0.25,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          SizedBox(
            height: media.height * 0.02,
          ),
          DatePickerWidget(
            looping: false, // default is not looping
            firstDate: widget.limitUpToday ? _dateDownLimit : DateTime.now(),
            lastDate: widget.limitUpToday ? DateTime.now() : _dateUpLimit,
            initialDate: widget.initialDate ??
                (widget.limitUpToday ? DateTime(1991, 10, 12) : DateTime.now()),
            dateFormat: widget.dateFormat,
            locale: DatePicker.localeFromString('it'),
            onChange: (DateTime newDate, _) => _dateSelected = newDate,
            pickerTheme: DateTimePickerTheme(
              itemTextStyle: const TextStyle(
                color: Colors.black,
                fontSize: 23,
              ),
              dividerColor: widget.colorTheme,
            ),
          ),
          GestureDetector(
              onTap: () {
                widget.onSetDate(_dateSelected);
                Navigator.pop(context);
              },
              child: SizedBox(
                width: media.width * .25,
                child: VocecaaButton(
                  color: Color(0xFFFFE45E),
                  text: Text(
                    'Conferma',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: media.width * .013,
                    ),
                  ),
                  onTap: () {
                    widget.onSetDate(_dateSelected);
                    Navigator.pop(context);
                  },
                ),
              ))
        ],
      ),
    );
  }
}
