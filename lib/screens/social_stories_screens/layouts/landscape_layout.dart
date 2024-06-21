import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/social_story_cubit/social_story_editor_cubit.dart';
import 'package:voce/models/enums/table_operation.dart';
import 'package:voce/screens/social_stories_screens/social_story_edit_pages/social_story_edit_content.dart';
import 'package:voce/screens/social_stories_screens/social_story_edit_pages/social_story_edit_data.dart';
import 'package:voce/widgets/mbs/mb_info.dart';
import 'package:voce/widgets/vocecaa_button.dart';

class SocialStoryDetailLandscape extends StatefulWidget {
  const SocialStoryDetailLandscape({Key? key}) : super(key: key);

  @override
  State<SocialStoryDetailLandscape> createState() =>
      _SocialStoryDetailLandscapeState();
}

class _SocialStoryDetailLandscapeState
    extends State<SocialStoryDetailLandscape> {
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
            "In questa pagina è possibile visualizzare le informazioni della storia sociale navigando con i pulsanti in alto (Dati, Contenuto).\n",
            textAlign: isLandscape ? TextAlign.center : TextAlign.start,
            style: GoogleFonts.poppins(
              fontSize: isLandscape ? media.width * .015 : media.height * .02,
            ),
          ),
          RichText(
            textAlign: TextAlign.center,
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
                      " per eliminare la storia sociale (se stai modificando una tabella già creata)\n\n",
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
      backgroundColor: Theme.of(context).primaryColor,
      // appBar: AppBar(
      //   centerTitle: false,
      //   toolbarHeight: media.height * .1,
      //   automaticallyImplyLeading: true,
      //   leading: IconButton(
      //     onPressed: () => Navigator.pop(context),
      //     icon: Icon(
      //       Icons.arrow_back_ios_rounded,
      //       color: Colors.black87,
      //     ),
      //   ),
      //   elevation: 0,
      //   backgroundColor: Theme.of(context).primaryColor,
      //   title: Text(
      //     'Crea una storia sociale',
      //     style: Theme.of(context).textTheme.headline1,
      //   ),
      // ),
      body: DefaultTabController(
        length: 2,
        child: BlocBuilder<SocialStoryEditorCubit, SocialStoryEditorState>(
          builder: (context, state) {
            if (state is SocialStoryEditorLoaded) {
              return Column(
                children: [
                  _buildCustomAppBar(
                      context,
                      state.socialStory.title.isEmpty
                          ? 'Crea una storia sociale'
                          : state.socialStory.title),
                  Expanded(
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        SocialStoryEditData(),
                        SocialStoryEditContent(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (cubit.caaContentOperation ==
                                CAAContentOperation.UPDATE &&
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
                                  style: GoogleFonts.poppins(
                                      fontSize: media.width * .013),
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
                                  style: GoogleFonts.poppins(
                                      fontSize: media.width * .013),
                                )
                              ],
                            ),
                            onTap: () {
                              cubit.saveSocialStory();
                              //Navigator.pop(context);
                            },
                          ),
                        if (cubit.isUserSocialStory() &&
                            cubit.caaContentOperation ==
                                CAAContentOperation.UPDATE)
                          SizedBox(width: 10),
                        if (cubit.isUserSocialStory() ||
                            cubit.caaContentOperation ==
                                CAAContentOperation.UPDATE)
                          SizedBox(
                            width: media.width * .1,
                            child: VocecaaButton(
                              color: Color(0xFFFFE45E),
                              text: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(Icons.copy_outlined),
                                  SizedBox(width: 3),
                                  Text(
                                    'Duplica',
                                    style: GoogleFonts.poppins(
                                        fontSize: media.width * .013),
                                  )
                                ],
                              ),
                              onTap: () {
                                cubit.duplicateSocialStory();
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            } else if (state is SocialStoryTranslationLoading) {
              return Center(
                child: SizedBox(
                  width: media.width * .9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Traduzione in corso',
                        style: GoogleFonts.poppins(
                          fontSize: media.width * .02,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildTabController(Size media) {
    return Container(
      width: media.width * .5,
      child: TabBar(
        indicator: BoxDecoration(
          color: Color(0xFFFFE45E),
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        labelStyle: GoogleFonts.poppins(),
        tabs: [
          Tab(
            text: 'Dati',
          ),
          Tab(
            text: 'Contenuto',
          ),
        ],
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context, String appBarTite) {
    Size media = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: media.height * .04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.black87,
                ),
              ),
              Text(
                appBarTite,
                style: Theme.of(context).textTheme.headline1,
              ),
            ],
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: _buildTabController(media),
          ),
          IconButton(
            onPressed: () => _showInfoModal(),
            icon: Image.asset("assets/icons/icon_info.png"),
          ),
        ],
      ),
    );
  }
}
