import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/models/patient.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class PatientCardComponent extends StatelessWidget {
  const PatientCardComponent({
    Key? key,
    required this.patient,
    this.topRightActions = const <Widget>[],
    this.bottomRightActions = const <Widget>[],
  }) : super(key: key);

  final Patient patient;
  final List<Widget> topRightActions;
  final List<Widget> bottomRightActions;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    initializeDateFormatting('it_IT', null);
    print(topRightActions.length);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                  SizedBox(width: 10),
                  Text(
                    patient.nickname,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: media.width * .015,
                    ),
                  ),
                  Spacer(
                    flex: 10,
                  ),
                ] +
                topRightActions,
          ),
          // Text(
          //   'Data di nascita: ${DateFormat('dd/MM/yyyy').format(patient.dateOfBirth)}',
          //   style: GoogleFonts.poppins(fontSize: media.width * .014),
          // ),
          Row(
            children: <Widget>[
                  Text(
                    'Livello di comunicazione: ${patient.communicationLevel}',
                    style: GoogleFonts.poppins(fontSize: media.width * .014),
                  ),
                  Spacer(
                    flex: 10,
                  ),
                ] +
                bottomRightActions,
          ),
          SizedBox(height: media.height * .01),
        ],
      ),
    );
  }
}
