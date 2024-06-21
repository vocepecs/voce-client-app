import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/models/enums/social_story_view_type.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecca_card.dart';

class SocialStoryPatientSelectionCard extends StatelessWidget {
  const SocialStoryPatientSelectionCard({
    Key? key,
    required this.patient,
    required this.isSelected,
    required this.onSelection,
  }) : super(key: key);

  final Patient patient;
  final bool isSelected;
  final Function() onSelection;

  String _getSocialStoryTypyString() {
    switch (patient.socialStoryViewType) {
      case SocialStoryViewType.SINGLE:
        return 'Singola frase';
      case SocialStoryViewType.MULTIPLE:
        return 'Frasi multiple';
      default:
        return 'Singola frase';
    }
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Container(
      height: media.height * .1,
      padding: EdgeInsets.fromLTRB(12.5, 12.5, 12.5, 0),
      child: VocecaaCard(
        padding: EdgeInsets.all(0),
        child: ListTile(
          title: AutoSizeText(
            '${patient.nickname}',
            maxLines: 1,
            style: GoogleFonts.poppins(
              fontSize: media.width * .015,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: AutoSizeText(
            _getSocialStoryTypyString(),
            maxLines: 1,
            style: GoogleFonts.poppins(
              fontSize: media.width * .015,
            ),
          ),
          minLeadingWidth: 20,
          horizontalTitleGap: 10,
          dense: true,
          leading: isSelected
              ? Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Icon(
                    Icons.check_circle_outline_rounded,
                    color: Colors.green[700],
                  ),
                )
              : null,
          trailing: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: ConstantGraphics.colorPink,
            ),
            onPressed: () => onSelection(),
            child: Text(
              'Seleziona',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
