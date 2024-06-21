import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/social_story_cubit/social_story_editor_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/models/enums/table_operation.dart';
import 'package:voce/models/social_story.dart';
import 'package:voce/screens/social_stories_screens/social_story_edit_pages/social_story_edit_content.dart';
import 'package:voce/screens/social_stories_screens/social_story_edit_pages/social_story_edit_data.dart';
import 'package:voce/widgets/mbs/mb_info.dart';
import 'package:voce/widgets/vocecaa_button.dart';

class SocialStoryDetailPortrait extends StatefulWidget {
  const SocialStoryDetailPortrait({
    Key? key,
    required this.socialStory,
  }) : super(key: key);

  final SocialStory socialStory;

  @override
  State<SocialStoryDetailPortrait> createState() =>
      _SocialStoryDetailPortraitState();
}

class _SocialStoryDetailPortraitState extends State<SocialStoryDetailPortrait> {
  PageController controller = PageController(initialPage: 0);
  int currentIndex = 0;

  void _showInfoModal() {
    Size media = MediaQuery.of(context).size;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    showModalBottomSheet(
      context: context,
      builder: (context) => MbsVoceInfo(
        title: "Storia sociale",
        contents: [
          Text(
            "Attualmente la creazione delle storie sociali è ottimizzata solamente per tablet.\n",
            textAlign: isLandscape ? TextAlign.center : TextAlign.start,
            style: GoogleFonts.poppins(
              fontSize: isLandscape ? media.width * .015 : media.height * .02,
            ),
          ),
          Text(
            "In questa pagina è possibile visualizzare le informazioni della storia sociale navigando con i pulsanti a basso (Dati, Contenuto).\n",
            textAlign: isLandscape ? TextAlign.center : TextAlign.start,
            style: GoogleFonts.poppins(
              fontSize: isLandscape ? media.width * .015 : media.height * .02,
            ),
          ),
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              style: GoogleFonts.poppins(
                color: Colors.black87,
              ),
              children: [
                TextSpan(
                  text:
                      "Una volta apportate le dovute modifiche, clicca sul pulsante ",
                  style: GoogleFonts.poppins(
                    fontSize:
                        isLandscape ? media.width * .015 : media.height * .02,
                  ),
                ),
                TextSpan(
                  text: "Salva le modifiche ",
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize:
                        isLandscape ? media.width * .015 : media.height * .02,
                  ),
                ),
                TextSpan(
                  text: "per creare o aggiornare la storia sociale ",
                  style: GoogleFonts.poppins(
                    fontSize:
                        isLandscape ? media.width * .015 : media.height * .02,
                  ),
                ),
                TextSpan(
                  text: "Oppure clicca sul pulsante ",
                  style: GoogleFonts.poppins(
                    fontSize:
                        isLandscape ? media.width * .015 : media.height * .02,
                  ),
                ),
                TextSpan(
                  text: "Elimina ",
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize:
                        isLandscape ? media.width * .015 : media.height * .02,
                  ),
                ),
                TextSpan(
                  text:
                      " per eliminare la storia sociale (se stai modificando una storia sociale già creata)\n\n",
                  style: GoogleFonts.poppins(
                    fontSize:
                        isLandscape ? media.width * .015 : media.height * .02,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black.withOpacity(0),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<SocialStoryEditorCubit>(context);
    Size media = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: ConstantGraphics.colorBlue,
        appBar: AppBar(
          backgroundColor: ConstantGraphics.colorBlue,
          foregroundColor: Colors.black87,
          title: Text(
            widget.socialStory.title.isEmpty
                ? 'Nuova storia sociale'
                : widget.socialStory.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => _showInfoModal(),
              icon: Image.asset("assets/icons/icon_info.png"),
            ),
          ],
          centerTitle: false,
          elevation: 0,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          elevation: 5,
          selectedLabelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: ConstantGraphics.colorBlue,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(),
          onTap: ((value) {
            setState(() {
              currentIndex = value;
              controller.animateToPage(
                value,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInSine,
              );
            });
          }),
          items: [
            BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/icons/icon_form_inactive.png",
                  height: 30,
                ),
                activeIcon: Image.asset(
                  "assets/icons/icon_form.png",
                  height: 30,
                ),
                label: "Dati"),
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/icons/icon_image_content_inactive.png",
                height: 30,
              ),
              activeIcon: Image.asset(
                "assets/icons/icon_image_content.png",
                height: 30,
              ),
              label: 'Contenuto',
            ),
          ],
        ),
        body: PageView(
          controller: controller,
          physics: NeverScrollableScrollPhysics(),
          children: [
            SocialStoryEditData(),
            SocialStoryEditContent(),
          ],
        ),
        persistentFooterButtons: [
          Row(
            mainAxisAlignment:
                cubit.caaContentOperation == CAAContentOperation.UPDATE
                    ? MainAxisAlignment.spaceEvenly
                    : MainAxisAlignment.end,
            children: [
              if (cubit.caaContentOperation == CAAContentOperation.UPDATE &&
                  cubit.isUserSocialStory())
                VocecaaButton(
                  color: Colors.red[200]!,
                  text: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.delete_outline_rounded),
                      SizedBox(width: 3),
                      Text(
                        'Elimina',
                        maxLines: 1,
                        style:
                            GoogleFonts.poppins(fontSize: media.height * .013),
                      )
                    ],
                  ),
                  onTap: () {
                    cubit.deleteSocialStory();
                    //Navigator.pop(context);
                  },
                ),
              if (cubit.isUserSocialStory()) SizedBox(width: 10),
              if (cubit.isUserSocialStory())
                VocecaaButton(
                  color: Color(0xFFFFE45E),
                  text: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.save_as_outlined),
                      SizedBox(width: 3),
                      Text(
                        'Salva le modifiche',
                        style:
                            GoogleFonts.poppins(fontSize: media.height * .013),
                      )
                    ],
                  ),
                  onTap: () {
                    cubit.saveSocialStory();
                    //Navigator.pop(context);
                  },
                ),
              if (cubit.isUserSocialStory() &&
                  cubit.caaContentOperation == CAAContentOperation.UPDATE)
                SizedBox(width: 10),
              if (cubit.isUserSocialStory() ||
                  cubit.caaContentOperation == CAAContentOperation.UPDATE)
                VocecaaButton(
                  color: Color(0xFFFFE45E),
                  text: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.copy_outlined),
                      SizedBox(width: 3),
                      Text(
                        'Duplica',
                        style:
                            GoogleFonts.poppins(fontSize: media.height * .013),
                      )
                    ],
                  ),
                  onTap: () {
                    cubit.duplicateSocialStory();
                  },
                ),
            ],
          )
        ]);
  }
}
