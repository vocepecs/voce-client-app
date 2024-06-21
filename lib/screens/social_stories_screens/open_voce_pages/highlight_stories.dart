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

class HighlightStoriesPage extends StatefulWidget {
  const HighlightStoriesPage({Key? key}) : super(key: key);

  @override
  State<HighlightStoriesPage> createState() => _HighlightStoriesPageState();
}

class _HighlightStoriesPageState extends State<HighlightStoriesPage> {
  late OpenVoceSocialStoriesCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<OpenVoceSocialStoriesCubit>(context);
  }

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
                  ? 7 / 3
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
              // eightFactor: .23,
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

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'In Open VOCE puoi trovare tutte le storie sociali di dominio pubblico presenti nel database VOCE.\nDuplicale e importale sul tuo profilo per poterle modificare e personalizzare!',
            style: GoogleFonts.poppins(
              fontSize: orientation == Orientation.landscape
                  ? media.width * .014
                  : media.height * .018,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image.asset(
                'assets/icons/icon_popular.png',
                alignment: Alignment.centerLeft,
                height: isLandscape ? media.width * .03 : media.height * .04,
              ),
              SizedBox(width: 15),
              Text(
                'Storie Sociali in evidenza',
                style: GoogleFonts.poppins(
                  fontSize: orientation == Orientation.landscape
                      ? media.width * .018
                      : media.height * .022,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        BlocBuilder<OpenVoceSocialStoriesCubit, OpenVoceSocialStoriesState>(
          builder: (context, state) {
            if (state is OpenVoceSocialStoriesLoaded ||
                state is OpenVoceSocialStoriesLoading) {
              List<SocialStory> mostUsedSocialStories =
                  state.mostUsedSocialStoryList;
              return Expanded(
                // height: isLandscape ? media.height * .25 : media.height * .6,
                // width: media.width * .9,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildSocialStoriesGridView(
                    socialStoryList: mostUsedSocialStories,
                    isList: !isLandscape,
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
      ],
    );
  }
}
