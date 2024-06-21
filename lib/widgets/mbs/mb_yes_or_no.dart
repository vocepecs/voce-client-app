import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/widgets/vocecaa_button.dart';

class MbYesOrNo extends StatelessWidget {
  const MbYesOrNo({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: media.width * .25),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white),
        padding: EdgeInsets.all(media.width * .03),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Confermi di voler elimnare il pittogramma dalla tabella ?',
                style: GoogleFonts.poppins(
                  fontSize: isLandscape ? media.width * .013 : media.height * .014,
                )),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Spacer(),
                Expanded(
                  flex: isLandscape ? 1 : 3,
                  child: VocecaaButton(
                      color: ConstantGraphics.colorYellow,
                      text: Text(
                        'Si',
                        style: GoogleFonts.poppins(
                          fontSize: isLandscape ? media.width * .013 : media.height * .013,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () => Navigator.pop(context, true)),
                ),
                Spacer(),
                Expanded(
                  flex: isLandscape ? 1 : 3,
                  child: VocecaaButton(
                      color: ConstantGraphics.colorYellow,
                      text: Text(
                        'No',
                        style: GoogleFonts.poppins(
                          fontSize: isLandscape ? media.width * .013 : media.height * .013,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () => Navigator.pop(context, false)),
                ),
                Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
