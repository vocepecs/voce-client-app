import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/link_story_to_patient_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecca_card.dart';

class DownloadCentreStoriesPanel extends StatelessWidget {
  const DownloadCentreStoriesPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    var cubit = BlocProvider.of<LinkStoryToPatientCubit>(context);
    return VocecaaCard(
      hasShadow: false,
      child: SizedBox(
        height: media.height * .15,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: media.width * .28,
              child: ListTile(
                visualDensity: VisualDensity.compact,
                contentPadding: EdgeInsets.zero,
                dense: true,
                minVerticalPadding: 0,
                title: AutoSizeText(
                  'Scarica le storie sociali del tuo centro',
                  maxLines: 1,
                  style: GoogleFonts.poppins(
                    fontSize: media.width * .014,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: AutoSizeText(
                  'Clicca sul pulsante per scaricare le storie sociali appartenenti al tuo centro',
                  maxLines: 2,
                  style: GoogleFonts.poppins(
                    fontSize: media.width * .013,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                height: media.height * .06,
                child: VocecaaButton(
                    color: ConstantGraphics.colorYellow,
                    text: Text(
                      'Scarica',
                      style: GoogleFonts.poppins(
                        fontSize: media.width * .015,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      cubit.getCentreSocialStory();
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
