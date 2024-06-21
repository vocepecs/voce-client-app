import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/widgets/close_line_top_modal.dart';
import 'package:voce/widgets/vocecaa_audio_card.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecca_image_card_small.dart';

class MbAudioDetails extends StatelessWidget {
  const MbAudioDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.fromLTRB(
          24, 24, 24, 24 + MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
          color: Color(0xFFF9F9F9),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(16, 10, 16, 6),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(child: CloseLineTopModal()),
                  SizedBox(height: media.height * .05),
                  Container(
                    child: Text(
                      'Nome della traccia audio',
                      style: GoogleFonts.poppins(
                        fontSize: media.width * .02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      // color: Colors.red,
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'La traccia audio è associata ai seguenti simboli',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: media.width * .013,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) =>
                                VocecaaImageCardSmall(
                              imageName: 'Nome simbolo',
                              actions: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: VocecaaButton(
                                      color: Colors.red[200]!,
                                      text: Row(
                                        children: [
                                          Icon(Icons.link_off),
                                          SizedBox(width: 8.0),
                                          Text(
                                            'Disassocia',
                                            style: GoogleFonts.poppins(),
                                          )
                                        ],
                                      ),
                                      onTap: () => null),
                                )
                              ],
                            ),
                            separatorBuilder: (context, _) =>
                                SizedBox(height: 10),
                            itemCount: 4,
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      // color: Colors.blue,
                      padding: EdgeInsets.fromLTRB(media.width * .05, 25, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 300,
                            child: TextField(
                              style: GoogleFonts.poppins(),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                alignLabelWithHint: true,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                label: Text(
                                  'Nome del simbolo',
                                  style: GoogleFonts.poppins(),
                                ),
                                border: OutlineInputBorder(
                                    // borderSide: BorderSide(width: 2, style: BorderStyle.solid,color: Colors.amber),
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                width: media.width * .3,
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Padding(
                                    padding: const EdgeInsets.only(bottom: 5.0),
                                    child: Text(
                                      'Cambia traccia audio',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  subtitle: Container(
                                    margin: EdgeInsets.only(top: 5.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        color: Colors.white,
                                        border: Border.all(
                                            width: 1, color: Colors.black45)),
                                    padding: EdgeInsets.all(13),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Cerca file',
                                          style: GoogleFonts.poppins(),
                                        ),
                                        Icon(Icons.upcoming_outlined)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 0, 5),
                                padding: EdgeInsets.all(13),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                  color: Theme.of(context).primaryColor,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.mic),
                                    SizedBox(width: 8.0),
                                    Text(
                                      'Registra',
                                      style: GoogleFonts.poppins(
                                          fontSize: media.width * .011),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 150,
                      padding: EdgeInsets.all(16),
                      child: VocecaaButton(
                        color: Theme.of(context).primaryColor,
                        text: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.play_circle_outline_rounded),
                            SizedBox(width: 8.0),
                            Text(
                              'Ascolta',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                    Container(
                      width: 150,
                      padding: EdgeInsets.all(16),
                      child: VocecaaButton(
                        color: Color(0xFFFFE45E),
                        text: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save),
                            SizedBox(width: 8.0),
                            Text(
                              'Salva',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
