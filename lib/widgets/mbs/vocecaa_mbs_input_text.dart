import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/widgets/close_line_top_modal.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecaa_text_field.dart';

class VocecaaMbInputText extends StatefulWidget {
  const VocecaaMbInputText({
    Key? key,
    required this.initialValue,
  }) : super(key: key);
  final String initialValue;

  @override
  State<VocecaaMbInputText> createState() => _VocecaaMbInputTextState();
}

class _VocecaaMbInputTextState extends State<VocecaaMbInputText> {
  late String text = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    text = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Container(
      height: media.height * .3,
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
      margin: EdgeInsets.fromLTRB(
        isLandscape ? media.width * .25 : media.width * .1,
        0,
        isLandscape ? media.width * .25 : media.width * .1,
        MediaQuery.of(context).viewInsets.bottom * .4 + media.height * .3,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: 10),
          VocecaaTextField(
            onChanged: (value) {
              text = value;
            },
            label: 'Inserisci frase',
            initialValue: text,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              VocecaaButton(
                  color: Colors.white,
                  text: AutoSizeText(
                    'Annulla',
                    maxLines: 1,
                    style: GoogleFonts.poppins(
                      fontSize: isLandscape
                          ? media.width * .014
                          : media.height * .016,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  }),
              VocecaaButton(
                  color: ConstantGraphics.colorYellow,
                  text: AutoSizeText(
                    'Conferma',
                    maxLines: 1,
                    style: GoogleFonts.poppins(
                      fontSize: isLandscape
                          ? media.width * .014
                          : media.height * .016,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context, text);
                  }),
            ],
          )
        ],
      ),
    );
  }
}
