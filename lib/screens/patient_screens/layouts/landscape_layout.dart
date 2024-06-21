import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:voce/cubit/patient_screen_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/screens/patient_screens/pages/caa_tables_page.dart';
import 'package:voce/screens/patient_screens/pages/patient_dashboard_page.dart';
import 'package:voce/screens/patient_screens/pages/social_stories_page.dart';
import 'package:voce/screens/patient_screens/ui_components/patient_info_card.dart';
import 'package:voce/screens/patient_screens/ui_components/patient_stories_management_card.dart';
import 'package:voce/screens/patient_screens/ui_components/patient_tables_management_card.dart';
import 'package:voce/widgets/mbs/mb_info.dart';
import 'package:voce/widgets/vocecca_card.dart';

class PatientScreenLandscapeLayout extends StatefulWidget {
  const PatientScreenLandscapeLayout({Key? key}) : super(key: key);

  @override
  State<PatientScreenLandscapeLayout> createState() =>
      _PatientScreenLandscapeLayoutState();
}

class _PatientScreenLandscapeLayoutState
    extends State<PatientScreenLandscapeLayout> {
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
            "Utilizza il menù di navigazione in alto per visualizzare le diverse informazioni del profilo (Tabella CAA, Storie Sociali, Dashboard)\n",
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
      resizeToAvoidBottomInset: false,
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
          style: Theme.of(context).textTheme.headline1,
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
            Patient patient = state.patient;
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          PatientInfoCard(patient: patient),
                          SizedBox(height: media.height * .01),
                          PatientTablesManagementCard(patient: patient),
                          SizedBox(height: media.height * .01),
                          PatientStoriesManagementCard(patient: patient),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: DefaultTabController(
                        length: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              VocecaaCard(
                                child: TabBar(
                                  indicator: BoxDecoration(
                                    color: Color(0xFFFFE45E),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  labelStyle: GoogleFonts.poppins(
                                    fontSize: media.width * .014,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  tabs: [
                                    Tab(
                                      text: 'Tabelle CAA',
                                    ),
                                    Tab(
                                      text: 'Storie Sociali',
                                    ),
                                    Tab(
                                      text: 'Dashboard',
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: media.height * .01),
                              Expanded(
                                child: TabBarView(
                                  physics: NeverScrollableScrollPhysics(),
                                  children: [
                                    PatientCaaTablesPage(patient: patient),
                                    PatientSocialStoriesPage(patient: patient),
                                    PatientDashboardPage(),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: ConstantGraphics.colorYellow,
              ),
            );
          }
        },
      ),
    );
  }
}
