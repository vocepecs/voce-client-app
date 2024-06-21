import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/social_story_communication_setup_cubit.dart';
import 'package:voce/cubit/social_story_cubit/social_story_comm_detail_cubit_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/models/social_story.dart';
import 'package:voce/screens/social_stories_screens/ui_components/social_story_card.dart';
import 'package:voce/screens/social_story_view_screens/social_story_comm_detail_screen.dart';
import 'package:voce/services/voce_api_repository.dart';
import 'package:voce/widgets/vocecca_card.dart';

class SocialStoryCommunicationSetupScreen extends StatefulWidget {
  const SocialStoryCommunicationSetupScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SocialStoryCommunicationSetupScreen> createState() =>
      _SocialStoryCommunicationSetupScreenState();
}

class _SocialStoryCommunicationSetupScreenState
    extends State<SocialStoryCommunicationSetupScreen> {
  late SocialStoryCommunicationSetupCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<SocialStoryCommunicationSetupCubit>(context);
    cubit.getData();
  }

  Widget _buildLandscapeLayout() {
    Size media = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          SizedBox(
            width: media.width * .3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Seleziona un profilo',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: BlocBuilder<SocialStoryCommunicationSetupCubit,
                          SocialStoryCommunicationSetupState>(
                        builder: (context, state) {
                          if (state is SocialStoryCommunicationSetupLoaded) {
                            return Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: ListView.separated(
                                itemBuilder: (context, index) => ListTile(
                                  selected: state.patientList[index].isActive!,
                                  selectedTileColor: ConstantGraphics.colorBlue,
                                  selectedColor: Colors.black87,
                                  title: Text(
                                    state.patientList[index].nickname,
                                    style: GoogleFonts.poppins(fontSize: 15),
                                  ),
                                  shape: Border(
                                    left: BorderSide(
                                        width: 3,
                                        color: ConstantGraphics.colorBlue),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Tabelle associate',
                                        style:
                                            GoogleFonts.poppins(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  trailing: TextButton(
                                    onPressed: () {
                                      cubit.setActivePatient(
                                          state.patientList[index]);
                                    },
                                    child: Text(
                                      'Seleziona',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                separatorBuilder: (context, index) => SizedBox(
                                  height: 15,
                                ),
                                itemCount: state.patientList.length,
                              ),
                            );
                          }else if (state
                              is SocialStoryCommunicationSetupNoActivePatient) {
                            return Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: ListView.separated(
                                itemBuilder: (context, index) => ListTile(
                                  selected: state.patientList[index].isActive!,
                                  selectedTileColor: ConstantGraphics.colorBlue,
                                  selectedColor: Colors.black87,
                                  title: Text(
                                    state.patientList[index].nickname,
                                    style: GoogleFonts.poppins(fontSize: 15),
                                  ),
                                  shape: Border(
                                    left: BorderSide(
                                        width: 3,
                                        color: ConstantGraphics.colorBlue),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Tabelle associate',
                                        style:
                                            GoogleFonts.poppins(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  trailing: TextButton(
                                    onPressed: () {
                                      cubit.setActivePatient(
                                          state.patientList[index]);
                                    },
                                    child: Text(
                                      'Seleziona',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                separatorBuilder: (context, index) => SizedBox(
                                  height: 15,
                                ),
                                itemCount: state.patientList.length,
                              ),
                            );
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      )),
                ),
              ],
            ),
          ),
          BlocBuilder<SocialStoryCommunicationSetupCubit,
              SocialStoryCommunicationSetupState>(
            builder: (context, state) {
              if (state is SocialStoryCommunicationSetupLoaded) {
                try {
                  List<SocialStory> patientSocialStories = state.patientList
                      .firstWhere((element) => element.isActive!)
                      .socialStoryList;

                  if (patientSocialStories.isEmpty) {
                    return Expanded(
                      child: _buildSocialStorySelectionPanel(
                        context: context,
                        socialStoryList: state.socialStoryList,
                        title:
                            "Seleziona una tabella da associare al profilo per iniziare la sessione",
                        onTableSelected: (socialStory) {
                          cubit.linkSocialStoryToPatient(socialStory);
                        },
                      ),
                    );
                  } else {
                    return Expanded(
                      child: _buildSocialStorySelectionPanel(
                        context: context,
                        socialStoryList: patientSocialStories,
                        title: "Seleziona una tabella per iniziare la sessione",
                        onTableSelected: (socialStory) {
                          cubit.setActiveStory(socialStory);
                        },
                      ),
                    );
                  }
                } catch (e) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        'Seleziona un profilo per scegliere\nla tabella da utilizzare',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  );
                }
              } else {
                return Container();
              }
            },
          )
        ],
      ),
    );
  }

  Widget _buildPortraitLayout() {
    Size media = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seleziona un profilo',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          BlocBuilder<SocialStoryCommunicationSetupCubit,
              SocialStoryCommunicationSetupState>(
            builder: (context, state) {
              if (state is SocialStoryCommunicationSetupLoaded ||
                  state is SocialStoryCommunicationSetupNoActivePatient) {
                List<Patient> patientList = state
                        is SocialStoryCommunicationSetupLoaded
                    ? state.patientList
                    : (state as SocialStoryCommunicationSetupNoActivePatient)
                        .patientList;
                return Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Numero di colonne
                      mainAxisSpacing: 10.0, // Spazio verticale tra le righe
                      crossAxisSpacing: 10.0,
                      childAspectRatio: media.width < 600
                          ? 6 / 3
                          : 7 / 3, // Spazio orizzontale tra le colonne
                    ),
                    itemCount: patientList.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        cubit.setActivePatient(patientList[index]);
                      },
                      child: VocecaaCard(
                        backgroundColor: patientList[index].isActive!
                            ? ConstantGraphics.colorBlue
                            : Colors.white,
                        hasShadow: true,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: media.width * .2,
                              child: AutoSizeText(
                                patientList[index].nickname,
                                maxLines: 2,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
          BlocBuilder<SocialStoryCommunicationSetupCubit,
              SocialStoryCommunicationSetupState>(
            builder: (context, state) {
              if (state is SocialStoryCommunicationSetupLoaded) {
                try {
                  List<SocialStory> patientSocialStories = state.patientList
                      .firstWhere((element) => element.isActive!)
                      .socialStoryList;

                  if (patientSocialStories.isEmpty) {
                    return Expanded(
                      flex: 2,
                      child: _buildSocialStorySelectionPanel(
                        context: context,
                        socialStoryList: state.socialStoryList,
                        title:
                            "Seleziona una storia sociale da associare al profilo per iniziare la sessione",
                        onTableSelected: (socialStory) {
                          cubit.linkSocialStoryToPatient(socialStory);
                        },
                      ),
                    );
                  } else {
                    return Expanded(
                      flex: 2,
                      child: _buildSocialStorySelectionPanel(
                        context: context,
                        socialStoryList: patientSocialStories,
                        title:
                            "Seleziona una storia sociale per iniziare la sessione",
                        onTableSelected: (socialStory) {
                          cubit.setActiveStory(socialStory);
                        },
                      ),
                    );
                  }
                } catch (e) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        'Seleziona un profilo per scegliere\nla tabella da utilizzare',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  );
                }
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    Size media = MediaQuery.of(context).size;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return AppBar(
      title: AutoSizeText('Visualizza la Storia Sociale'),
      centerTitle: false,
      elevation: 0,
      backgroundColor: Colors.grey[200],
      titleTextStyle: GoogleFonts.poppins(
        color: Colors.black87,
        fontSize: isLandscape ? media.width * .025 : media.height * .025,
      ),
      iconTheme: IconThemeData(
        color: Colors.black87,
        size: isLandscape ? media.width * .025 : media.height * .025,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SocialStoryCommunicationSetupCubit,
        SocialStoryCommunicationSetupState>(
      listener: (context, state) {
        if (state is SocialStoryCommunicationSetupEnded) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  BlocProvider<SocialStoryCommDetailCubitCubit>(
                create: (context) => SocialStoryCommDetailCubitCubit(
                  voceAPIRepository: VoceAPIRepository(),
                  user: cubit.user,
                  activePatient: state.patient,
                  socialStory: state.socialStory,
                ),
                child: SocialStoryCommDetailScreen(),
              ),
            ),
          ).then((_) {
            cubit.getData();
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: _buildAppBar(),
        body: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.landscape) {
              return _buildLandscapeLayout();
            } else {
              return _buildPortraitLayout();
            }
          },
        ),
      ),
    );
  }

  Widget _buildSocialStorySelectionPanel({
    required BuildContext context,
    required List<SocialStory> socialStoryList,
    required String title,
    required Function(SocialStory table) onTableSelected,
  }) {
    Size media = MediaQuery.of(context).size;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: media.width < 600 ? 1 : 2, // Numero di colonne
              mainAxisSpacing: 10.0, // Spazio verticale tra le righe
              crossAxisSpacing: 10.0,
              childAspectRatio: isLandscape
                  ? 6 / 3
                  : media.width < 600
                      ? 7 / 3
                      : 7 / 3, // Spazio orizzontale tra le colonne
            ),
            itemCount: socialStoryList.length,
            itemBuilder: (context, index) => SocialStoryCard(
              socialStory: socialStoryList[index],
              onButtonTap: () => onTableSelected(socialStoryList[index]),
              buttonLabel: 'Seleziona',
            ),
          ),
        ),
      ],
    );
  }
}
