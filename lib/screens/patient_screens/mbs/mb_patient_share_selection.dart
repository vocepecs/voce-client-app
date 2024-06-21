import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/widgets/vocecaa_button.dart';

class MbPatientShareSelection extends StatefulWidget {
  const MbPatientShareSelection({
    Key? key,
    required this.patientList,
  }) : super(key: key);

  final List<Patient> patientList;

  @override
  State<MbPatientShareSelection> createState() =>
      _MbPatientShareSelectionState();
}

class _MbPatientShareSelectionState extends State<MbPatientShareSelection> {
  List<int> selectedPatients = [];

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
      height: media.height * .7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Color(0xffF9F9F9),
      ),
      child: Column(
        children: [
          AutoSizeText(
            'Associa tabella',
            style: GoogleFonts.poppins(
              fontSize: media.height * .03,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(
            height: media.height * .01,
          ),
          AutoSizeText(
            'Seleziona i pazienti a cui vuoi associare la tabella',
            maxLines: 2,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: media.height * .02,
              color: Colors.black87,
            ),
          ),
          SizedBox(
            height: media.height * .03,
          ),
          Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selectedPatients.contains(index)) {
                            selectedPatients.remove(index);
                          } else {
                            selectedPatients.add(index);
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: selectedPatients.contains(index)
                              ? Colors.blue[100]
                              : Colors.grey[200],
                        ),
                        child: Center(
                          child: Text(
                            '${widget.patientList[index].nickname}',
                            style: GoogleFonts.poppins(
                              fontSize: media.height * .02,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                separatorBuilder: (_, __) => SizedBox(
                      height: 10,
                    ),
                itemCount: widget.patientList.length),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              VocecaaButton(
                  color: Colors.transparent,
                  text: AutoSizeText(
                    'Annulla',
                    style: GoogleFonts.poppins(
                      fontSize: media.height * .02,
                      color: ConstantGraphics.colorPink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () => Navigator.pop(context)),
              VocecaaButton(
                color: ConstantGraphics.colorYellow,
                text: AutoSizeText(
                  'Conferma',
                  style: GoogleFonts.poppins(
                    fontSize: media.height * .02,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context, selectedPatients);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
