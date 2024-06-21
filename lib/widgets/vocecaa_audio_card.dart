import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/screens/multimedia_contents_screens/mbs/mb_audio_details.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecca_card.dart';

class VocecaaAudioCard extends StatelessWidget {
  const VocecaaAudioCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return VocecaaCard(
      padding: EdgeInsets.zero,
      hasShadow: true,
      child: Container(
        width: media.width * .4,
        child: Row(
          children: [
            Container(
              height: media.height * .2,
              width: media.width * .1,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(15),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.mic,
                  size: media.width * .08,
                  color: Colors.black87,
                ),
              ),
            ),
            Container(
              height: media.height * .2,
              width: media.width * .3,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nome del contenuto multimediale',
                      style: GoogleFonts.poppins(),
                    ),
                    Text(
                      'Creata il 12/10/2021',
                      style: GoogleFonts.poppins(),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        VocecaaButton(
                            color: Color(0xFFFFE45E),
                            text: Row(
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                ),
                                SizedBox(width: 8.0),
                                Text('Dettagli', style: GoogleFonts.poppins(),)
                              ],
                            ),
                            onTap: () => showModalBottomSheet(
                            context: context,
                            builder: (context) => MbAudioDetails(),
                            backgroundColor: Colors.black.withOpacity(0),
                            isScrollControlled: true,
                          ),),
                        SizedBox(width: 8.0),
                        VocecaaButton(
                            color: Colors.red[200]!,
                            text: Row(
                              children: [
                                Icon(
                                  Icons.delete,
                                ),
                                SizedBox(width: 8.0),
                                Text('Elimina', style: GoogleFonts.poppins(),)
                              ],
                            ),
                            onTap: () => null),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
