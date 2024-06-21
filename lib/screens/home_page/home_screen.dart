import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:voce/cubit/add_new_patient_cubit.dart';
import 'package:voce/cubit/auth_cubit.dart';
import 'package:voce/cubit/dedicated_cubits/download_centre_tables_cubit.dart';
import 'package:voce/cubit/dedicated_cubits/download_public_tables_cubit.dart';
import 'package:voce/cubit/dedicated_cubits/table_filter_panel_cubit.dart';
import 'package:voce/cubit/home_page_cubit.dart';

import 'package:voce/cubit/pictograms_cubit.dart';
import 'package:voce/cubit/social_story_cubit/social_story_manager_cubit.dart';
import 'package:voce/cubit/tables_screen_cubit.dart';
import 'package:voce/layouts/landscape_layout.dart';
import 'package:voce/layouts/portrait_layout.dart';
import 'package:voce/models/enums/patient_operation.dart';
import 'package:voce/screens/auth_screens/root_screen.dart';
import 'package:voce/screens/home_page/mbs/mb_add_new_patient.dart';
import 'package:voce/screens/home_page/ui_components/patient_card.dart';
import 'package:voce/screens/home_page/ui_components/section_card.dart';

import 'package:voce/screens/multimedia_contents_screens/pictograms_manager_screen.dart';
import 'package:voce/screens/social_stories_screens/social_stories_screen.dart';
import 'package:voce/screens/table_screens/tables_screen.dart';
import 'package:voce/services/auth_repository.dart';
import 'package:voce/services/voce_api_repository.dart';
import 'package:voce/widgets/mbs/mb_info.dart';
import 'package:voce/widgets/vocecaa_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    required this.drawerAction,
  }) : super(key: key);

  final Function() drawerAction;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late HomePageCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<HomePageCubit>(context);
    cubit.getUser();
  }

  Future<bool> _showExitPopup() async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Chiusura applicazione'),
            content: Text('Vuoi uscire dall\'applicazione?'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                //return false when click on "NO"
                child: Text('No'),
              ),
              ElevatedButton(
                onPressed: () => SystemNavigator.pop(),
                //return true when click on "Yes"
                child: Text('Si'),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  void _navigateToTablesManager() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => TablesScreenCubit(
                user: cubit.user,
                voceAPIRepository: VoceAPIRepository(),
              ),
            ),
            BlocProvider(
              create: (context) => DownloadPublicTablesCubit(
                voceAPIRepository: VoceAPIRepository(),
              ),
            ),
            BlocProvider(
              create: (context) => TableFilterPanelCubit(),
            ),
            BlocProvider(
              create: (context) => DownloadCentreTablesCubit(
                  voceAPIRepository: VoceAPIRepository(), user: cubit.user),
            ),
          ],
          child: TablesScreen(),
        ),
      ),
    ).then((value) => cubit.getUser());
  }

  void _navigateToStoriesManager() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => SocialStoryManagerCubit(
              user: cubit.user,
              voceAPIRepository: VoceAPIRepository(),
            ),
            child: SocialStoriesScreen(),
          ),
        )).then((value) => cubit.getUser());
  }

  void _navigatePictogramsManager() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => PictogramsCubit(
            voceAPIRepository: VoceAPIRepository(),
            user: cubit.user,
          ),
          child: PictogramManagerScreen(),
        ),
      ),
    ).then((value) => cubit.getUser());
  }

  void _showInfoModal() {
    Size media = MediaQuery.of(context).size;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    showModalBottomSheet(
      context: context,
      builder: (context) => MbsVoceInfo(
        title: "Gestione profili CAA",
        contents: [
          Text(
            "Da questa pagina puoi gestire i profili CAA, aggiungendone di nuovi, modificando quelli esistenti e cancellandoli.\n",
            textAlign: isLandscape ? TextAlign.center : TextAlign.start,
            style: GoogleFonts.poppins(
              fontSize: isLandscape ? media.width * .015 : media.height * .02,
            ),
          ),
          Text(
            "Clicca sul pulsante 'visualizza' nella card del profilo per visualizzare i dettagli del profilo selezionato.\n",
            textAlign: isLandscape ? TextAlign.center : TextAlign.start,
            style: GoogleFonts.poppins(
              fontSize: isLandscape ? media.width * .015 : media.height * .02,
            ),
          ),
          Text(
            "Oppure clicca su 'aggiungi' per creare un nuovo profilo.",
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

  Widget _buildSectionCard(
    String title,
    String subtitle,
    Image icon,
    double scaleBase,
    Function() onTap,
  ) {
    return SectionCard(
      icon: icon,
      scaleBase: scaleBase,
      title: title,
      subtitle: subtitle,
      onTap: () => onTap(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    var cubit = BlocProvider.of<HomePageCubit>(context);
    // auth = AuthProvider.of(context);
    return WillPopScope(
      onWillPop: _showExitPopup,
      child: BlocConsumer<HomePageCubit, HomePageState>(
        listener: (context, state) {
          if (state is UserSignOut) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => AuthCubit(
                        voceAPIRepository: VoceAPIRepository(),
                        authRepository: AuthRepository()),
                    child: RootScreen(),
                  ),
                ));
          }
        },
        builder: (context, state) {
          if (state is PatientListLoaded) {
            return OrientationBuilder(
              builder: (context, orientation) {
                if (orientation == Orientation.landscape) {
                  return LandscapeLayout(
                    appBarTitle: "Buongiorno",
                    leftSideWidgets: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoSizeText(
                            'I tuoi profili',
                            maxLines: 1,
                            style: GoogleFonts.poppins(
                              fontSize: media.width * .02,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () => _showInfoModal(),
                            icon: Image.asset("assets/icons/icon_info.png"),
                          ),
                          Spacer(),
                          VocecaaButton(
                            color: Color(0xFFFFE45E),
                            text: Row(
                              children: [
                                Icon(
                                  Icons.person_add,
                                  size: media.width * .012,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Aggiungi',
                                  style: GoogleFonts.poppins(
                                    fontSize: media.width * .01,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () => showModalBottomSheet(
                              context: context,
                              builder: (context) => BlocProvider(
                                child: MbAddNewPatient(),
                                create: (context) => AddNewPatientCubit(
                                  user: cubit.user,
                                  voceAPIRepository: VoceAPIRepository(),
                                  patientOperation: PatientOperation.CREATE,
                                ),
                              ),
                              backgroundColor: Colors.black.withOpacity(0),
                              isScrollControlled: true,
                            ).then((_) => cubit.getUser()),
                          ),
                        ],
                      ),
                      SizedBox(height: media.height * .05),
                      Expanded(
                          child: ListView.separated(
                        itemBuilder: (context, index) {
                          return PatientCard(
                            scaleBase: media.width,
                            patient: state.patientList[index],
                            user: cubit.user,
                          );
                        },
                        separatorBuilder: (_, __) => SizedBox(height: 10),
                        itemCount: state.patientList.length,
                      ))
                    ],
                    rightSideWidgets: <Widget>[
                      _buildSectionCard(
                        "Gestione Tabelle",
                        "Accedi per visualizzare le tue tabelle, modificarle, oppure crearne di nuove",
                        Image.asset("assets/icons/icon_table.png"),
                        media.width,
                        () => _navigateToTablesManager(),
                      ),
                      SizedBox(height: 10),
                      _buildSectionCard(
                        "Gestione Storie Sociali",
                        "Accedi per visualizzare le storie sociali, modificarle, oppure crearne di nuove",
                        Image.asset("assets/icons/icon_social_story.png"),
                        media.width,
                        () => _navigateToStoriesManager(),
                      ),
                      SizedBox(height: 10),
                      _buildSectionCard(
                        "Gestione Pittogrammi",
                        "Accedi per visualizzare i pittogrammi, modificarli, oppure crearne di nuovi",
                        Image.asset("assets/icons/icon_pictograms.png"),
                        media.width,
                        () => _navigatePictogramsManager(),
                      ),
                    ],
                    appBarButtonLeading: IconButton(
                      onPressed: () => widget.drawerAction(),
                      color: Colors.black87,
                      iconSize: media.width * .03,
                      icon: Icon(Icons.menu_rounded),
                    ),
                  );
                } else {
                  return PortraitLayout(
                    appBarTitle: "Buongiorno",
                    appBarButtonLeading: IconButton(
                      onPressed: () => widget.drawerAction(),
                      color: Colors.black87,
                      iconSize: media.height * .03,
                      icon: Icon(Icons.menu_rounded),
                    ),
                    columnWidgets: [
                      CarouselSlider(
                        items: [
                          _buildSectionCard(
                            "Gestione Tabelle",
                            "Accedi per visualizzare le tue tabelle, modificarle, oppure crearne di nuove",
                            Image.asset("assets/icons/icon_table.png"),
                            media.height,
                            () => _navigateToTablesManager(),
                          ),
                          _buildSectionCard(
                            "Gestione Storie Sociali",
                            "Accedi per visualizzare le storie sociali, modificarle, oppure crearne di nuove",
                            Image.asset("assets/icons/icon_social_story.png"),
                            media.height,
                            () => _navigateToStoriesManager(),
                          ),
                          _buildSectionCard(
                            "Gestione Pittogrammi",
                            "Accedi per visualizzare i pittogrammi, modificarli, oppure crearne di nuovi",
                            Image.asset("assets/icons/icon_pictograms.png"),
                            media.height,
                            () => _navigatePictogramsManager(),
                          ),
                        ],
                        options: CarouselOptions(
                          height: media.height * .22,
                          viewportFraction: 0.8,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: true,
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoSizeText(
                              'I tuoi profili',
                              maxLines: 1,
                              style: GoogleFonts.poppins(
                                fontSize: media.height * .025,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () => _showInfoModal(),
                              icon: Image.asset("assets/icons/icon_info.png"),
                            ),
                            Spacer(),
                            VocecaaButton(
                              color: Color(0xFFFFE45E),
                              text: Row(
                                children: [
                                  Icon(
                                    Icons.person_add,
                                    size: media.height * .02,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Aggiungi',
                                    style: GoogleFonts.poppins(
                                      fontSize: media.height * .018,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () => showModalBottomSheet(
                                context: context,
                                builder: (context) => BlocProvider(
                                  child: MbAddNewPatient(),
                                  create: (context) => AddNewPatientCubit(
                                    user: cubit.user,
                                    voceAPIRepository: VoceAPIRepository(),
                                    patientOperation: PatientOperation.CREATE,
                                  ),
                                ),
                                backgroundColor: Colors.black.withOpacity(0),
                                isScrollControlled: true,
                              ).then((_) => cubit.getUser()),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            return PatientCard(
                              scaleBase: media.height,
                              patient: state.patientList[index],
                              user: cubit.user,
                            );
                          },
                          separatorBuilder: (_, __) => SizedBox(height: 10),
                          itemCount: state.patientList.length,
                        ),
                      ))
                    ],
                  );
                }
              },
            );
          } else {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
