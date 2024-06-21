import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:voce/models/social_story.dart';
import 'package:voce/widgets/vocecca_card.dart';

class StoryListLinkItem extends StatefulWidget {
  const StoryListLinkItem({
    Key? key,
    required this.socialStory,
    required this.onTap,
  }) : super(key: key);

  final SocialStory socialStory;
  final Function(bool value) onTap;

  @override
  State<StoryListLinkItem> createState() => _StoryListLinkItemState();
}

class _StoryListLinkItemState extends State<StoryListLinkItem> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    initializeDateFormatting('it_IT', null);
    return GestureDetector(
      onTap: () {
        widget.onTap(!isSelected);
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: Container(
        width: media.width * .3,
        height: media.height * .2,
        child: VocecaaCard(
          hasShadow: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      visualDensity: VisualDensity.compact,
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      minVerticalPadding: 0,
                      title: Text(
                        widget.socialStory.title,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: media.width * .013),
                      ),
                      subtitle: Text(
                        'Creazione: ${DateFormat('dd/MM/yyyy').format(widget.socialStory.creationDate)}',
                        style: GoogleFonts.poppins(
                          fontSize: media.width * .012,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: media.width * .08,
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: Colors.grey[200],
                    ),
                    child: Text(
                      (() {
                        if (widget.socialStory.isPrivate) {
                          return 'Privata';
                        } else if (widget.socialStory.isCentrePrivate) {
                          return 'Centro';
                        } else {
                          return 'Pubblica';
                        }
                      }()),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: media.width * .011,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  isSelected
                      ? Container(
                          width: media.width * .03,
                          height: media.width * .03,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green[300],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.check_circle_outline_rounded,
                              size: media.width * .025,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Container(),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${widget.socialStory.getSessionListSize}',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: media.width * .022,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: ' Frasi',
                          style: GoogleFonts.poppins(
                            fontSize: media.width * .012,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
