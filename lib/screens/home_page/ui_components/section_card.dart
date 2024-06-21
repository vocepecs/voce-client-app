import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecca_card.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({
    Key? key,
    required this.onTap,
    required this.title,
    required this.subtitle,
    this.scaleBase = 1,
    this.icon,
  }) : super(key: key);

  final Function() onTap;
  final String title;
  final String subtitle;
  final double scaleBase;
  final Image? icon;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation currentOrientation = MediaQuery.of(context).orientation;
    return VocecaaCard(
      child: Container(
        width: currentOrientation == Orientation.landscape
            ? media.width * .5
            : null,
        height: currentOrientation == Orientation.landscape
            ? media.width * .12
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              dense: true,
              minVerticalPadding: 0,
              contentPadding: EdgeInsets.zero,
              title: AutoSizeText(
                title,
                maxLines: 1,
                style: GoogleFonts.poppins(
                  fontSize: currentOrientation == Orientation.landscape
                      ? scaleBase * .015
                      : scaleBase * .02,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: currentOrientation == Orientation.landscape
                      ? scaleBase * .012
                      : scaleBase * .016,
                  height: 1.2,
                ),
              ),
              leading: SizedBox(width: scaleBase * .07, child: icon),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                VocecaaButton(
                  color: Color(0xffFFE45E),
                  text: Text(
                    'Visualizza',
                    style: GoogleFonts.poppins(
                      fontSize: currentOrientation == Orientation.landscape
                          ? scaleBase * .012
                          : scaleBase * .017,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () => onTap(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
