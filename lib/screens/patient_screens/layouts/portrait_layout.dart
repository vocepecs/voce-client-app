import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:voce/cubit/image_list_panel_cubit.dart';
import 'package:voce/cubit/patient_screen_cubit.dart';
import 'package:voce/cubit/social_story_cubit/social_story_editor_cubit.dart';
import 'package:voce/cubit/speech_to_text_cubit.dart';
import 'package:voce/cubit/table_context_cubit.dart';
import 'package:voce/cubit/table_panel_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/models/enums/table_operation.dart';
import 'package:voce/models/social_story.dart';
import 'package:voce/screens/patient_screens/pages/caa_tables_page.dart';
import 'package:voce/screens/patient_screens/pages/patient_dashboard_page.dart';
import 'package:voce/screens/patient_screens/pages/social_stories_page.dart';
import 'package:voce/screens/patient_screens/ui_components/patient_info_card.dart';
import 'package:voce/screens/social_stories_screens/social_story_creation_screen.dart';
import 'package:voce/screens/table_screens/table_details_screen.dart';
import 'package:voce/services/voce_api_repository.dart';
import 'package:voce/widgets/mbs/mb_info.dart';

class PatientScreenPortraitLayout extends StatefulWidget {
  const PatientScreenPortraitLayout({Key? key}) : super(key: key);

  @override
  State<PatientScreenPortraitLayout> createState() =>
      _PatientScreenPortraitLayoutState();
}

class _PatientScreenPortraitLayoutState
    extends State<PatientScreenPortraitLayout> {
  int currentIndex = 0;
  PageController controller = PageController(initialPage: 0);

  late PatientScreenCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<PatientScreenCubit>(context);
  }

  void _showInfoModal() {
    Size media = MediaQuery.of(context).size;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    showModalBottomSheet(
      context: context,
      builder: (context) => MbsVoceInfo(
        title: "Pagina Profilo CAA",
        contents: [
          Text(
            "Da questa pagina puoi visualizzare le tabelle CAA, le storie sociali e la dashboard dei progressi associati al profilo\n",
            textAlign: isLandscape ? TextAlign.center : TextAlign.start,
            style: GoogleFonts.poppins(
              fontSize: isLandscape ? media.width * .015 : media.height * .02,
            ),
          ),
          Text(
            "Utilizza il menù di navigazione in basso per visualizzare le diverse informazioni del profilo\n",
            textAlign: isLandscape ? TextAlign.center : TextAlign.start,
            style: GoogleFonts.poppins(
              fontSize: isLandscape ? media.width * .015 : media.height * .02,
            ),
          ),
          Text(
            "Utilizza i pulsanti di creazione e associazione per creare nuove tabelle CAA e storie sociali associate al profilo",
            textAlign: isLandscape ? TextAlign.center : TextAlign.start,
            style: GoogleFonts.poppins(
              fontSize: isLandscape ? media.width * .015 : media.height * .02,
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
    Size media = MediaQuery.of(context).size;
    initializeDateFormatting('it_IT', null);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black87,
          ),
        ),
        elevation: 0,
        centerTitle: false,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Profilo',
          style: GoogleFonts.poppins(
            fontSize: media.height * .03,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showInfoModal(),
            icon: Image.asset("assets/icons/icon_info.png"),
          ),
        ],
      ),
      body: BlocBuilder<PatientScreenCubit, PatientScreenState>(
        builder: (context, state) {
          if (state is PatientScreenLoaded) {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  SizedBox(
                    height: media.height * .1,
                    child: PatientInfoCard(patient: state.patient),
                  ),
                  SizedBox(height: 15),
                  Expanded(
                    child: PageView(
                      controller: controller,
                      children: [
                        PatientCaaTablesPage(patient: state.patient),
                        PatientSocialStoriesPage(patient: state.patient),
                        PatientDashboardPage(),
                      ],
                    ),
                  )
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
                "assets/icons/icon_table_inactive.png",
                height: 30,
              ),
              activeIcon: Image.asset(
                "assets/icons/icon_table.png",
                height: 30,
              ),
              label: "Tabelle CAA"),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/icons/icon_social_story_inactive.png",
              height: 30,
            ),
            activeIcon: Image.asset(
              "assets/icons/icon_social_story.png",
              height: 30,
            ),
            label: 'Storie Sociali',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/icons/icon_dashboard_inactive.png",
              height: 30,
            ),
            activeIcon: Image.asset(
              "assets/icons/icon_dashboard.png",
              height: 30,
            ),
            label: 'Dashboard',
          ),
        ],
      ),
      floatingActionButton: currentIndex != 2
          ? ElevatedButton(
              onPressed: () {
                if (currentIndex == 0) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MultiBlocProvider(
                          providers: [
                            BlocProvider<SpeechToTextCubit>(
                              create: (context) => SpeechToTextCubit(),
                            ),
                            BlocProvider<TablePanelCubit>(
                              create: (context) => TablePanelCubit(
                                user: cubit.user,
                                patient: cubit.patient,
                                voceApiRepository: VoceAPIRepository(),
                                tableOperation: CAAContentOperation
                                    .CREATE_PATIENT_ASSOCIATION,
                              ),
                            ),
                            BlocProvider<TableContextCubit>(
                              create: (context) => TableContextCubit(
                                voceAPIRepository: VoceAPIRepository(),
                              ),
                            ),
                            BlocProvider(
                              create: (context) => ImageListPanelCubit(
                                user: cubit.user,
                                voceAPIRepository: VoceAPIRepository(),
                                patient: cubit.patient,
                              ),
                            )
                          ],
                          child: TableDetailsScreen(),
                        ),
                      )).then((_) {
                    cubit.getPatientData();
                  });
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (context) => SocialStoryEditorCubit(
                                voceAPIRepository: VoceAPIRepository(),
                                user: cubit.user,
                                patient: cubit.patient,
                                caaContentOperation: CAAContentOperation
                                    .CREATE_PATIENT_ASSOCIATION,
                                socialStory: SocialStory.createEmptySocialStory(
                                    cubit.user.id!),
                              ),
                            ),
                            BlocProvider(
                              create: (context) => SpeechToTextCubit(),
                            ),
                          ],
                          child: SocialStorycreationScreen(),
                        ),
                      )).then((_) {
                    cubit.getPatientData();
                  });
                }
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
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
