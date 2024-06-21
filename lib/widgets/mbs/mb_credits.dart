import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/widgets/vocecaa_button.dart';

class VoceModalCredits extends StatefulWidget {
  const VoceModalCredits({Key? key}) : super(key: key);

  @override
  State<VoceModalCredits> createState() => _VoceModalCreditsState();
}

class _VoceModalCreditsState extends State<VoceModalCredits> {
  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.fromLTRB(
        isLandscape ? media.width * .2 : 8,
        8,
        isLandscape ? media.width * .2 : 8,
        8,
      ),
      height: isLandscape ? media.height * .9 : media.height * .75,
      // width: isLandscape ? media.width * .4 : media.width * .8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        color: Color(0xffF9F9F9),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/voce-logo.png', height: media.height * .08),
          Text(
            "Il progetto è stato realizzato grazie al contributo di Fondazione TIM che è espressione dell'impegno sociale di TIM e la cui missione è promuovere la cultura del cambiamento e dell'innovazione digitale, favorendo l’inclusione, la comunicazione, la crescita economica e sociale.",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: isLandscape ? media.width * .02 : media.height * .018,
            ),
          ),
          Text(
            'I simboli pittografici utilizzati sono di proprietà del governo di Aragona e sono stati creati da Sergio Palao per ARASAAC, che li distribuisce sotto Licenza Creative Commons BY-NC-SA.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: isLandscape ? media.width * .02 : media.height * .018,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                'assets/tim_logo.png',
                height: media.height * .08,
              ),
              Image.asset(
                'assets/arasaac_logo.png',
                height: media.height * .05,
              ),
            ],
          ),
          VocecaaButton(
            color: ConstantGraphics.colorYellow,
            text: AutoSizeText(
              'Ho Capito',
              style: GoogleFonts.poppins(
                fontSize: isLandscape ? media.width * .02 : media.height * .02,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }
}
