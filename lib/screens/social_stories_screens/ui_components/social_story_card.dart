import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/models/social_story.dart';
import 'package:voce/widgets/vocecaa_pictogram_simple.dart';
import 'package:voce/widgets/vocecca_card.dart';

class SocialStoryCard extends StatelessWidget {
  const SocialStoryCard({
    Key? key,
    required this.socialStory,
    required this.onButtonTap,
    this.widthFactor = .3,
    this.eightFactor = .3,
    this.currentUserId,
    this.buttonLabel = 'Maggiori dettagli',
    this.topRightActions = const [],
  }) : super(key: key);

  final SocialStory socialStory;
  final Function() onButtonTap;
  final double widthFactor;
  final double eightFactor;
  final int? currentUserId;
  final String buttonLabel;
  final List<Widget>? topRightActions;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    initializeDateFormatting('it_IT', null);
    Orientation orientation = MediaQuery.of(context).orientation;
    double textBaseSize =
        orientation == Orientation.landscape ? media.width : media.height;
    bool isLandscape = orientation == Orientation.landscape;
    return SizedBox(
      width: media.width * widthFactor,
      height: media.height * eightFactor,
      child: VocecaaCard(
        hasShadow: true,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  socialStory.imageStringCoding == null
                      ? Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.grey[200],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: textBaseSize * .05,
                            ),
                          ),
                        )
                      : VocecaaPictogramSimple(
                          caaImageStringCoding: socialStory.imageStringCoding!,
                          widthFactor: .1,
                          eightFactor: isLandscape ? .13 : .07,
                        ),
                  Container(
                    // width: orientation == Orientation.landscape
                    //     ? media.width * .08
                    //     : media.width * .18,
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.grey[200],
                    ),
                    child: AutoSizeText(
                      (() {
                        if (socialStory.isCentrePrivate) {
                          return 'Centro';
                        } else if (socialStory.isPrivate) {
                          return 'Privata';
                        } else {
                          return 'Pubblica';
                        }
                      }()),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: textBaseSize * .011,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 9,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  10.0,
                  0,
                  0,
                  0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                            Expanded(
                              child: AutoSizeText(
                                socialStory.title,
                                maxLines: 1,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: textBaseSize * .016,
                                ),
                              ),
                            ),
                            // if (currentUserId != null)
                            //   if (currentUserId != socialStory.userId)
                            //     Container(
                            //       padding: EdgeInsets.all(8.0),
                            //       decoration: BoxDecoration(
                            //           shape: BoxShape.circle,
                            //           color: Colors.grey[300]),
                            //       child: Center(
                            //         child: Icon(Icons.lock_outline_rounded),
                            //       ),
                            //     )
                          ] +
                          topRightActions!,
                    ),
                    AutoSizeText(
                      'Creata il  ${DateFormat('dd/MM/yyyy').format(socialStory.creationDate)}',
                      maxLines: 1,
                      style: GoogleFonts.poppins(
                        fontSize: textBaseSize * .012,
                      ),
                    ),
                    AutoSizeText(
                      '${socialStory.getNumberOfPictograms} pittogrammi',
                      maxLines: 1,
                      style: GoogleFonts.poppins(
                        fontSize: textBaseSize * .012,
                      ),
                    ),
                    AutoSizeText(
                      '${socialStory.getSessionListSize} frasi',
                      maxLines: 1,
                      style: GoogleFonts.poppins(
                        fontSize: textBaseSize * .012,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () => onButtonTap(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            buttonLabel,
                            style: GoogleFonts.poppins(
                                fontSize: textBaseSize * .015,
                                fontWeight: FontWeight.bold,
                                color: ConstantGraphics.colorPink),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: textBaseSize * .028,
                            color: ConstantGraphics.colorPink,
                          ),
                        ],
                      ),
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
