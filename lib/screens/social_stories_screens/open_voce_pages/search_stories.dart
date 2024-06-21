import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/social_story_cubit/open_voce_social_stories_cubit.dart';
import 'package:voce/cubit/social_story_cubit/social_story_editor_cubit.dart';
import 'package:voce/models/enums/table_operation.dart';
import 'package:voce/models/social_story.dart';
import 'package:voce/screens/social_stories_screens/social_story_creation_screen.dart';
import 'package:voce/screens/social_stories_screens/ui_components/social_story_card.dart';
import 'package:voce/services/voce_api_repository.dart';
import 'package:voce/widgets/vocecaa_searchbar.dart';
import 'package:voce/widgets/vocecca_card.dart';

class SearchStoriesPage extends StatefulWidget {
  const SearchStoriesPage({Key? key}) : super(key: key);

  @override
  State<SearchStoriesPage> createState() => _SearchStoriesPageState();
}

class _SearchStoriesPageState extends State<SearchStoriesPage> {
  late OpenVoceSocialStoriesCubit cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of<OpenVoceSocialStoriesCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    bool isLandscape = orientation == Orientation.landscape;

    Widget _buildSocialStoriesGridView({
      required List<SocialStory> socialStoryList,
      bool isList = false,
    }) {
      Size media = MediaQuery.of(context).size;
      Orientation orientation = MediaQuery.of(context).orientation;
      bool isLandscape = orientation == Orientation.landscape;
      return socialStoryList.length > 0
          ? GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isList
                    ? 1
                    : media.width < 600
                        ? 1
                        : Platform.isAndroid
                            ? 3
                            : 2, // Numero di colonne
                mainAxisSpacing: 10.0, // Spazio verticale tra le righe
                crossAxisSpacing: 10.0,
                childAspectRatio: media.width < 600
                    ? 8 / 3
                    : isList
                        ? 1 / 2
                        : 14 / 6, // Spazio orizzontale tra le colonne
              ),
              itemCount: socialStoryList.length,
              scrollDirection: !isLandscape
                  ? Axis.vertical
                  : isList
                      ? Axis.horizontal
                      : Axis.vertical,
              itemBuilder: (context, index) => SocialStoryCard(
                currentUserId: cubit.user.id,
                socialStory: socialStoryList[index],
                eightFactor: .27,
                onButtonTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) => SocialStoryEditorCubit(
                            voceAPIRepository: VoceAPIRepository(),
                            caaContentOperation: CAAContentOperation.UPDATE,
                            user: cubit.user,
                            socialStory: socialStoryList[index],
                          ),
                        ),
                      ],
                      child: SocialStorycreationScreen(),
                    ),
                  ),
                ),
              ),
            )
          : Container();
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image.asset(
                'assets/icons/icon_search.png',
                alignment: Alignment.centerLeft,
                height: isLandscape ? media.width * .03 : media.height * .04,
              ),
              SizedBox(width: 15),
              Text(
                'Ricerca storie sociali',
                style: GoogleFonts.poppins(
                  fontSize:
                      isLandscape ? media.width * .018 : media.height * .022,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Esplora le storie sociali in modo intuitivo! Utilizza la potente funzione di ricerca inserendo parole chiave nella barra sottostante per trovare rapidamente le storie sociali di cui hai bisogno',
            style: GoogleFonts.poppins(
              fontSize: isLandscape ? media.width * .014 : media.height * .018,
            ),
          ),
        ),
        Center(
          child: VocecaaSearchBar(
            hintText: 'Cerca una storia sociale',
            inputContainerWidthRatio: .9,
            marginRatio: 0.02,
            onTextChange: (value) {
              cubit.updatePattern(value);
            },
            onIconButtonPressed: () {
              cubit.getSocialStories();
            },
          ),
        ),
        SizedBox(height: 20),
        BlocBuilder<OpenVoceSocialStoriesCubit, OpenVoceSocialStoriesState>(
          builder: (context, state) {
            if (state is OpenVoceSocialStoriesLoaded) {
              return Expanded(
                child: _buildSocialStoriesGridView(
                  socialStoryList: state.socialStoryList,
                ),
              );
            } else if (state is OpenVoceSocialStoriesEmpty) {
              return Center(
                child: SizedBox(
                  height: orientation == Orientation.landscape
                      ? media.height * .3
                      : media.height * .3,
                  width: media.width * .8,
                  child: VocecaaCard(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.image_not_supported_outlined,
                          size: orientation == Orientation.landscape
                              ? media.width * .06
                              : media.height * .1,
                        ),
                        Text(
                          'Nessuna storia sociale trovata',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: orientation == Orientation.landscape
                                ? media.width * .02
                                : media.height * .02,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Riprova con una nuova ricerca',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: orientation == Orientation.landscape
                                ? media.width * .015
                                : media.height * .016,
                            // fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Expanded(
                flex: 10,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
