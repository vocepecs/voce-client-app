import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecaa_text_field.dart';

class MbImageCreationFault extends StatefulWidget {
  const MbImageCreationFault({Key? key}) : super(key: key);

  @override
  State<MbImageCreationFault> createState() => _MbImageCreationFaultState();
}

class _MbImageCreationFaultState extends State<MbImageCreationFault> {
  late String keyWord;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      height: media.height * .6,
      margin: EdgeInsets.fromLTRB(
        orientation == Orientation.landscape ? media.width * .25 : 16,
        0,
        orientation == Orientation.landscape ? media.width * .25 : 16,
        orientation == Orientation.landscape
            ? 24 + MediaQuery.of(context).viewInsets.bottom
            : 32 + MediaQuery.of(context).viewInsets.bottom,
      ),
      padding: EdgeInsets.fromLTRB(
        15,
        15,
        15,
        0,
      ),
      decoration: BoxDecoration(
          color: Color(0xFFF9F9F9),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Ricerca immagine',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: orientation == Orientation.landscape
                    ? media.width * .025
                    : media.height * .025,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 15),
          Text(
            'Utilizza una parola chiave per ricercare un immagine inerente al contesto del pittogramma che vuoi creare.\nPer esempio se stai inserendo il pittogramma del tuo cane "Fufi", prova ad usare la parola chiave "cane" per cercare un immagine adatta.',
            style: GoogleFonts.poppins(
              fontSize: orientation == Orientation.landscape
                  ? media.width * .015
                  : media.height * .018,
            ),
          ),
          SizedBox(height: media.height * .05),
          Center(
              child: VocecaaTextField(
                  onChanged: (value) {
                    setState(() {
                      keyWord = value;
                    });
                  },
                  label: 'Parola chiave',
                  initialValue: '')),
          Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: VocecaaButton(
                color: Color(0xFFFFE45E),
                text: Text(
                  'Invia',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  if (keyWord.length != 0) {
                    Navigator.pop(context, keyWord);
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
