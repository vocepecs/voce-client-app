import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/screens/multimedia_contents_screens/mbs/pages/page_image_content.dart';
import 'package:voce/screens/multimedia_contents_screens/mbs/pages/page_image_info.dart';
import 'package:voce/widgets/close_line_top_modal.dart';
import 'package:voce/widgets/vocecaa_button.dart';

class MbImageDetails extends StatelessWidget {
  const MbImageDetails({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.fromLTRB(24,24,24,24+MediaQuery.of(context).viewInsets.bottom),
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
                children: [
                  Center(child: CloseLineTopModal()),
                  SizedBox(height: media.height * .05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          'Nome del simbolo',
                          style: GoogleFonts.poppins(
                            fontSize: media.width * .02,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        width: media.width * .5,
                        child: TabBar(
                          indicator: BoxDecoration(
                            color: Color(0xFFFFE45E),
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          labelStyle: GoogleFonts.poppins(),
                          tabs: [
                            Tab(
                              text: 'Informazioni',
                            ),
                            Tab(
                              text: 'Contenuto',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  PageImageInfo(),
                  PageImageContent(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 200,
                padding: EdgeInsets.all(16),
                child: VocecaaButton(
                  color: Color(0xFFFFE45E),
                  text: Text(
                    'Salva',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}