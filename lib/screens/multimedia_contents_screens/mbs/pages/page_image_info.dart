import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/widgets/table_placeholder_3.dart';
import 'package:voce/widgets/vocecaa_audio_card_small.dart';
import 'package:voce/widgets/vocecaa_button.dart';

class PageImageInfo extends StatelessWidget {
  const PageImageInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                height: media.height * .3,
                padding: EdgeInsets.all(13.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Center(
                    child: Icon(
                      Icons.image_outlined,
                      size: media.width * .17,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                  padding: EdgeInsets.all(13.0),
                  height: media.height * .5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Il simbolo è usato nelle seguenti tabelle',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: media.width * .015,
                        ),
                      ),
                      SizedBox(height: 13),
                      Center(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) => Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              border: Border.all(
                                width: 2,
                                color: Colors.black54,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TablePlaceholder3Icon(highlightSectionList: [
                                  false,
                                  false,
                                  false
                                ]),
                                Text('Nome della tabella',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold)),
                                Text('32 simboli',
                                    style: GoogleFonts.poppins()),
                                VocecaaButton(
                                  color: Colors.yellow,
                                  text: Text('Visualizza dettagli'),
                                  onTap: () => null,
                                )
                              ],
                            ),
                          ),
                          separatorBuilder: (context, _) =>
                              SizedBox(height: 10),
                          itemCount: 5,
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ],
    );
  }
}
