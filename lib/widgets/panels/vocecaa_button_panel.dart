import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecca_card.dart';

class VocecaaButtonPanel extends StatelessWidget {
  const VocecaaButtonPanel(
      {Key? key,
      required this.title,
      required this.buttonLabel,
      required this.onButtonTap,
      this.subtitle})
      : super(key: key);

  final String title;
  final String? subtitle;
  final String buttonLabel;
  final Function() onButtonTap;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return VocecaaCard(
      hasShadow: false,
      child: SizedBox(
        width: orientation == Orientation.landscape
            ? media.width * .25
            : media.width * .85,
        child: Column(
          children: [
            ListTile(
              visualDensity: VisualDensity.compact,
              contentPadding: EdgeInsets.zero,
              dense: true,
              minVerticalPadding: 0,
              title: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: orientation == Orientation.landscape
                      ? media.width * .014
                      : media.height * .016,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: subtitle != null && orientation == Orientation.landscape
                  ? Text(
                      subtitle!,
                      style: GoogleFonts.poppins(
                        fontSize: orientation == Orientation.landscape
                            ? media.width * .013
                            : media.height * .015,
                      ),
                    )
                  : null,
              trailing: orientation == Orientation.portrait
                  ? SizedBox(
                      width: media.width * .3,
                      child: VocecaaButton(
                        color: ConstantGraphics.colorYellow,
                        text: Text(
                          buttonLabel,
                          style: GoogleFonts.poppins(
                            fontSize: media.height * .015,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () => onButtonTap(),
                      ),
                    )
                  : null,
            ),
            if (orientation == Orientation.landscape) SizedBox(height: 10),
            if (orientation == Orientation.landscape)
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: media.width * .1,
                  child: VocecaaButton(
                    color: ConstantGraphics.colorYellow,
                    text: Text(
                      buttonLabel,
                      style: GoogleFonts.poppins(
                        fontSize: media.width * .015,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () => onButtonTap(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
