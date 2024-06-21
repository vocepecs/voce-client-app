import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/widgets/vocecaa_button.dart';

class MbsVoceInfo extends StatelessWidget {
  const MbsVoceInfo({
    Key? key,
    required this.contents,
    required this.title,
  }) : super(key: key);

  final List<Widget> contents;
  final String title;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Container(
      margin: EdgeInsets.fromLTRB(
        isLandscape ? media.width * .02 : media.width * .05,
        10,
        isLandscape ? media.width * .02 : media.width * .05,
        10,
      ),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      // height: media.height * .8,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: isLandscape
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: <Widget>[
                  Center(
                      child: Image.asset("assets/icons/icon_info.png",
                          height: 50)),
                  Center(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: isLandscape
                            ? media.width * .02
                            : media.height * .03,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 15)
                ] +
                contents +
                [
                  SizedBox(height: 15),
                  VocecaaButton(
                      color: ConstantGraphics.colorYellow,
                      text: AutoSizeText(
                        'Ho capito',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: isLandscape
                              ? media.width * .015
                              : media.height * .02,
                        ),
                      ),
                      onTap: () => Navigator.pop(context))
                ],
          ),
        ),
      ),
    );
  }
}
