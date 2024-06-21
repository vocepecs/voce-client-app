import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/widgets/vocecaa_audio_card_small.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecca_image_card_small.dart';

class PageImageContent extends StatefulWidget {
  const PageImageContent({Key? key}) : super(key: key);

  @override
  _PageImageContentState createState() => _PageImageContentState();
}

class _PageImageContentState extends State<PageImageContent> {
  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: MediaQuery.of(context).viewInsets.bottom > 0
          ? null
          : NeverScrollableScrollPhysics(),
      child: Container(
        padding: EdgeInsets.all(30),
        height: media.height * .75,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 300,
                  child: TextField(
                    style: GoogleFonts.poppins(),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      alignLabelWithHint: true,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
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
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: media.width * .3,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        'Scegli l\'immagine',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    subtitle: Container(
                      margin: EdgeInsets.only(top: 5.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Colors.white,
                          border: Border.all(width: 1, color: Colors.black45)),
                      padding: EdgeInsets.all(13),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Cerca file',
                            style: GoogleFonts.poppins(),
                          ),
                          Icon(Icons.add_photo_alternate_rounded)
                        ],
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.photo_camera_outlined),
                      SizedBox(width: 8.0),
                      Text(
                        'Scatta foto',
                        style:
                            GoogleFonts.poppins(fontSize: media.width * .011),
                      )
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  width: media.width * .45,
                  child: ListTile(
                    title: Text(
                      'Immagine scelta',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: VocecaaImageCardSmall(
                        imageName: 'Nome del file immagine',
                        actions: [
                          Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: VocecaaButton(
                                color: Colors.red[200]!,
                                text: Row(
                                  children: [
                                    Icon(Icons.delete),
                                    SizedBox(width: 8.0),
                                    Text(
                                      'Elimina',
                                      style: GoogleFonts.poppins(),
                                    )
                                  ],
                                ),
                                onTap: () => null),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: media.width * .3,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        'Assegna traccia audio',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    subtitle: TextField(
                      style: GoogleFonts.poppins(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        alignLabelWithHint: true,
                        // floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: Icon(Icons.search),
                        label: Text(
                          'Cerca traccia',
                          style: GoogleFonts.poppins(),
                        ),
                        border: OutlineInputBorder(
                            // borderSide: BorderSide(width: 2, style: BorderStyle.solid,color: Colors.amber),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: media.width * .45,
                  child: ListTile(
                    title: Text(
                      'Traccia audio scelta',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: VocecaaAudioCardSmall(),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: media.width,
              height: media.height * .15,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  direction: Axis.vertical,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    VocecaaAudioCardSmall(),
                    VocecaaAudioCardSmall(),
                    VocecaaAudioCardSmall(),
                    VocecaaAudioCardSmall(),
                    VocecaaAudioCardSmall(),
                    VocecaaAudioCardSmall(),
                    VocecaaAudioCardSmall(),
                    VocecaaAudioCardSmall(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
