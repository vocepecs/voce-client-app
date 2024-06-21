import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/social_story_cubit/open_voce_social_stories_cubit.dart';
import 'package:voce/cubit/social_story_cubit/social_story_editor_cubit.dart';
import 'package:voce/cubit/social_story_cubit/social_story_manager_cubit.dart';
import 'package:voce/cubit/speech_to_text_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/models/enums/table_operation.dart';
import 'package:voce/models/social_story.dart';
import 'package:voce/screens/patient_screens/mbs/mb_patient_share_selection.dart';
import 'package:voce/screens/social_stories_screens/open_voce_social_stories_screen.dart';
import 'package:voce/screens/social_stories_screens/social_story_creation_screen.dart';
import 'package:voce/screens/social_stories_screens/ui_components/social_story_card.dart';
import 'package:voce/services/voce_api_repository.dart';
import 'package:voce/widgets/mbs/mb_confirm.dart';
import 'package:voce/widgets/mbs/mb_info.dart';
import 'package:voce/widgets/panels/vocecaa_button_panel.dart';
import 'package:voce/widgets/panels/vocecaa_privacy_filter_panel.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecaa_text_field.dart';
import 'package:voce/widgets/vocecca_card.dart';

class SocialStoriesScreen extends StatefulWidget {
  const SocialStoriesScreen({Key? key}) : super(key: key);

  @override
  State<SocialStoriesScreen> createState() => _SocialStoriesScreenState();
}

class _SocialStoriesScreenState extends State<SocialStoriesScreen> {
  late SocialStoryManagerCubit cubit;

  int currentIndex = 0;
  PageController controller = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<SocialStoryManagerCubit>(context);
  }

  void _showInfoModal() {
    Size media = MediaQuery.of(context).size;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    showModalBottomSheet(
      context: context,
      builder: (context) => MbsVoceInfo(
        title: "Gestione Storie Sociali",
        contents: [
          Text(
            isLandscape
                ? "Da questa pagina è possibile gestire le Storie Sociali modificandole oppure creandone di nuove tramite il pulsante 'Nuova Storia Sociale'\n"
                : "Da questa pagina è possibile gestire le Storie Sociali modificandole oppure creandone di nuove tramite il pulsante '+' in basso a destra\n",
            textAlign: isLandscape ? TextAlign.center : TextAlign.start,
            style: GoogleFonts.poppins(
              fontSize: isLandscape ? media.width * .015 : media.height * .02,
            ),
          ),
          isLandscape
              ? RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                      color: Colors.black87,
                    ),
                    children: [
                      TextSpan(
                        text:
                            "Nella pagina viene mostra una lista di Storie Sociali, clicca sul pulsante ",
                        style: GoogleFonts.poppins(
                          fontSize: media.width * .015,
                        ),
                      ),
                      TextSpan(
                        text: "Maggiori dettagli ",
                        style: GoogleFonts.poppins(
                          color: ConstantGraphics.colorPink,
                          fontWeight: FontWeight.bold,
                          fontSize: isLandscape
                              ? media.width * .015
                              : media.height * .02,
                        ),
                      ),
                      TextSpan(
                        text:
                            "per visualizzare la storia sociale e modificarla oppure eliminarla.\n\n",
                        style: GoogleFonts.poppins(
                          fontSize: isLandscape
                              ? media.width * .015
                              : media.height * .02,
                        ),
                      ),
                      TextSpan(
                        text:
                            "Inoltre, puoi accedere al portale Open Voce, cliccando sul pulsante apposito, per visualizzare le storie sociali pubbliche e duplicarle nel tuo set per poterle utilizzare\n",
                        style: GoogleFonts.poppins(
                          fontSize: isLandscape
                              ? media.width * .015
                              : media.height * .02,
                        ),
                      ),
                    ],
                  ),
                )
              : RichText(
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                      color: Colors.black87,
                    ),
                    children: [
                      TextSpan(
                        text:
                            "Nella pagina viene mostra una lista di Storie sociali, clicca sul pulsante ",
                        style: GoogleFonts.poppins(
                          fontSize: isLandscape
                              ? media.width * .015
                              : media.height * .02,
                        ),
                      ),
                      TextSpan(
                        text: "Maggiori dettagli ",
                        style: GoogleFonts.poppins(
                          color: ConstantGraphics.colorPink,
                          fontWeight: FontWeight.bold,
                          fontSize: isLandscape
                              ? media.width * .015
                              : media.height * .02,
                        ),
                      ),
                      TextSpan(
                        text:
                            "per visualizzare la storia sociale e modificarla oppure eliminarla.",
                        style: GoogleFonts.poppins(
                          fontSize: isLandscape
                              ? media.width * .015
                              : media.height * .02,
                        ),
                      ),
                      TextSpan(
                        text: "Oppure clicca sull'icona ",
                        style: GoogleFonts.poppins(
                          fontSize: isLandscape
                              ? media.width * .015
                              : media.height * .02,
                        ),
                      ),
                      WidgetSpan(
                          child: Icon(Icons.share, color: Colors.black54)),
                      TextSpan(
                        text: " per associarela ad un profilo.\n\n",
                        style: GoogleFonts.poppins(
                          fontSize: isLandscape
                              ? media.width * .015
                              : media.height * .02,
                        ),
                      ),
                      TextSpan(
                        text:
                            "Inoltre, puoi accedere al portale Open Voce, cliccando sul pulsante apposito, per visualizzare le storie sociali pubbliche e duplicarle nel tuo set per poterle utilizzare\n",
                        style: GoogleFonts.poppins(
                          fontSize: isLandscape
                              ? media.width * .015
                              : media.height * .02,
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

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      backgroundColor: ConstantGraphics.colorBlue,
      foregroundColor: Colors.black87,
      title: Text(
        'Le tue storie sociali',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => _showInfoModal(),
          icon: Image.asset("assets/icons/icon_info.png"),
        ),
      ],
    );
  }

  Widget _buildPortraitExpandablePanel() {
    Size media = MediaQuery.of(context).size;
    return ExpandableNotifier(
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: Colors.grey[300],
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: ExpandablePanel(
          theme: ExpandableThemeData(
            headerAlignment: ExpandablePanelHeaderAlignment.center,
            tapBodyToExpand: true,
            tapBodyToCollapse: true,
            hasIcon: true,
            iconPadding: EdgeInsets.all(16),
            iconSize: media.height * .03,
            iconColor: Colors.black87,
          ),
          header: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AutoSizeText(
              'Imposta i filtri',
              style: GoogleFonts.poppins(
                fontSize: media.height * .018,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          collapsed: Container(),
          expanded: SizedBox(
            height: media.height * .53 -
                MediaQuery.of(context).viewInsets.bottom * .5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildTextFilter(
                      width: double.maxFinite,
                      height: media.height * .08,
                    ),
                    SizedBox(height: 10),
                    _buildPrivacyFilterPanel(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFilter({
    required double width,
    required double height,
  }) {
    return SizedBox(
      height: height,
      width: width,
      child: VocecaaTextField(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        onChanged: (value) {
          cubit.updateSearchText(value);
        },
        label: 'Cerca una storia sociale',
        initialValue: '',
        enableClearTextIcon: true,
      ),
    );
  }

  Widget _buildPrivacyFilterPanel() {
    return VocecaaPrivacyFilterPanel(
      title: "Filtra le tue storie sociali",
      subtitle:
          "Usa gli switch per visualizzare la tipologia di storia sociale desiderata",
      showAutsimCentre: cubit.user.autismCentre != null,
      onPrivateToggleChange: (value) {
        cubit.updateFilterPrivate(value);
      },
      onPublicToggleChange: (value) {
        cubit.updateFilterPublic(value);
      },
      onCentreToggleChange: (value) {
        cubit.updateFilterCentre(value);
      },
    );
  }

  Widget _buildCentreDownloadPanel() {
    return VocecaaButtonPanel(
      title: 'Scarica le storie sociali del centro',
      subtitle:
          'Scarica dal database VOCE tutte le storie sociali del tuo centro',
      buttonLabel: 'Scarica',
      onButtonTap: () {
        cubit.getCentreSocialStory();
      },
    );
  }

  Widget _buildOpenVocePanel() {
    return VocecaaButtonPanel(
      title: 'Open VOCE',
      subtitle:
          'Accedi al portale pubblico "Open VOCE" per visualizzare le storie sociali di altri utenti e aggiungerle al tuo profilo',
      buttonLabel: 'Accedi',
      onButtonTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => OpenVoceSocialStoriesCubit(
                user: cubit.user, voceAPIRepository: VoceAPIRepository()),
            child: OpenVoceSocialStoriesScreen(),
          ),
        ),
      ).then((value) => cubit.getSocialStories()),
    );
  }

  Widget _buildButtonCreateStory({
    required double labelFontSize,
  }) {
    return VocecaaButton(
      color: ConstantGraphics.colorYellow,
      text: Text(
        'Nuova storia sociale',
        style: GoogleFonts.poppins(
          fontSize: labelFontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => SocialStoryEditorCubit(
                    voceAPIRepository: VoceAPIRepository(),
                    user: cubit.user,
                    caaContentOperation: CAAContentOperation.CREATE_GENERAL,
                    socialStory:
                        SocialStory.createEmptySocialStory(cubit.user.id!),
                  ),
                ),
                BlocProvider(
                  create: (context) => SpeechToTextCubit(),
                ),
              ],
              child: SocialStorycreationScreen(),
            ),
          )).then((_) {
        cubit.getSocialStories();
      }),
    );
  }

  Widget _buildSocialStoryGridView({
    required List<SocialStory> socialStoryList,
  }) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    bool isLandscape = orientation == Orientation.landscape;
    return socialStoryList.length > 0
        ? GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: media.width < 600 ? 1 : 2, // Numero di colonne
              mainAxisSpacing: 10.0, // Spazio verticale tra le righe
              crossAxisSpacing: 10.0,
              childAspectRatio: orientation == Orientation.landscape
                  ? 6 / 3
                  : media.width < 600
                      ? Platform.isAndroid
                          ? 6 / 3
                          : 11 / 5
                      : 7 / 3, // Spazio orizzontale tra le colonne
            ),
            itemCount: socialStoryList.length,
            itemBuilder: (context, index) => SocialStoryCard(
              currentUserId: cubit.user.id,
              socialStory: socialStoryList[index],
              topRightActions: [
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => MbPatientShareSelection(
                        patientList: cubit.user.patientList ?? [],
                      ),
                      backgroundColor: Colors.black.withOpacity(0),
                      isScrollControlled: true,
                    ).then(
                      (value) => cubit.linkTableToPatients(
                        value,
                        socialStoryList[index],
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.share,
                    color: Colors.black54,
                  ),
                ),
              ],
              eightFactor: .28,
              onButtonTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) => SocialStoryEditorCubit(
                            voceAPIRepository: VoceAPIRepository(),
                            user: cubit.user,
                            caaContentOperation: CAAContentOperation.UPDATE,
                            socialStory: socialStoryList[index],
                          ),
                        ),
                        BlocProvider(
                          create: (context) => SpeechToTextCubit(),
                        ),
                      ],
                      child: SocialStorycreationScreen(),
                    ),
                  )).then((_) {
                cubit.getSocialStories();
              }),
            ),
          )
        : Center(
            child: VocecaaCard(
              child: SizedBox(
                width: isLandscape ? media.width * .4 : media.width * .8,
                height: isLandscape ? media.height * .3 : media.height * .4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.cloud,
                      size: isLandscape ? media.width * .05 : media.height * .1,
                      color: Colors.black87,
                    ),
                    Text(
                      'Non hai ancora creato la tua prima storia sociale',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: isLandscape
                            ? media.width * .014
                            : media.height * .02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Clicca sul pulsante per avviare la procedura di creazione!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: isLandscape
                            ? media.width * .014
                            : media.height * .02,
                      ),
                    ),
                    _buildButtonCreateStory(
                      labelFontSize:
                          isLandscape ? media.width * .015 : media.height * .02,
                    )
                  ],
                ),
              ),
            ),
          );
  }

  Widget _buildLandscapeLayout() {
    Size media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: _buildAppBar(),
      body: BlocBuilder<SocialStoryManagerCubit, SocialStoryManagerState>(
        builder: (context, state) {
          if (state is SocialStoryManagerLoaded) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildTextFilter(
                          width: media.width * .27,
                          height: media.height * .07,
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                _buildPrivacyFilterPanel(),
                                SizedBox(height: 10),
                                if (cubit.user.autismCentre != null)
                                  _buildCentreDownloadPanel(),
                                SizedBox(height: 10),
                                _buildOpenVocePanel(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: media.width * .25,
                        child: _buildButtonCreateStory(
                          labelFontSize: media.width * .015,
                        ),
                      )
                    ],
                  ),
                  Spacer(),
                  Expanded(
                    flex: 20,
                    child: _buildSocialStoryGridView(
                        socialStoryList: state.socialStoryList),
                  ),
                  Spacer(),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildPortraitLayout() {
    Size media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ConstantGraphics.colorBlue,
      appBar: _buildAppBar(),
      body: BlocBuilder<SocialStoryManagerCubit, SocialStoryManagerState>(
        builder: (context, state) {
          if (state is SocialStoryManagerLoaded) {
            return SingleChildScrollView(
              child: SizedBox(
                height: media.height * .86,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      _buildPortraitExpandablePanel(),
                      SizedBox(height: 10),
                      if (cubit.user.autismCentre != null)
                        _buildCentreDownloadPanel(),
                      if (cubit.user.autismCentre != null) SizedBox(height: 10),
                      _buildOpenVocePanel(),
                      SizedBox(height: 10),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 38.0),
                          child: _buildSocialStoryGridView(
                            socialStoryList: state.socialStoryList,
                          ),
                        ),
                      )
                    ],
                  ),
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
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => SocialStoryEditorCubit(
                        voceAPIRepository: VoceAPIRepository(),
                        user: cubit.user,
                        caaContentOperation: CAAContentOperation.CREATE_GENERAL,
                        socialStory:
                            SocialStory.createEmptySocialStory(cubit.user.id!),
                      ),
                    ),
                    BlocProvider(
                      create: (context) => SpeechToTextCubit(),
                    ),
                  ],
                  child: SocialStorycreationScreen(),
                ),
              )).then((_) {
            cubit.getSocialStories();
          });
        },
        child: Icon(
          Icons.add_rounded,
          size: 28,
        ),
        style: ElevatedButton.styleFrom(
          elevation: 10,
          shape: CircleBorder(
            side: BorderSide(
              color: Colors.black87,
              width: 3,
            ),
          ),
          padding: EdgeInsets.all(12),
          foregroundColor: Colors.black87,
          backgroundColor: ConstantGraphics.colorYellow,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SocialStoryManagerCubit, SocialStoryManagerState>(
      listener: (context, state) {
        if (state is SocialStoryAddedToPatients) {
          showModalBottomSheet(
            context: context,
            builder: (context) => MbsAnimationAlert(
              title: 'Storia sociale associata!',
              subtitle:
                  'La tua storia sociale è stata associata ai pazienti selezionati',
            ),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          ).then((value) => cubit.getSocialStories());
        }
      },
      child: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return _buildPortraitLayout();
          } else {
            return _buildLandscapeLayout();
          }
        },
      ),
    );
  }
}
