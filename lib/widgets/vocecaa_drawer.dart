import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:voce/cubit/communication_settings_panel_cubit.dart';
import 'package:voce/cubit/home_page_cubit.dart';
import 'package:voce/cubit/profile_info_screen/profile_info_cubit.dart';
import 'package:voce/cubit/social_story_communication_setup_cubit.dart';
import 'package:voce/models/constants/app_constants.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/screens/auth_screens/mbs/mb_error.dart';
import 'package:voce/screens/communication_screens/communication_setup_screen.dart';
import 'package:voce/screens/home_page/home_screen.dart';
import 'package:voce/screens/social_story_view_screens/social_story_communication_setup_screen.dart';
import 'package:voce/screens/user_profile_screens/user_profile_screen.dart';
import 'package:voce/services/voce_api_repository.dart';
import 'package:voce/widgets/mbs/mb_credits.dart';

final ZoomDrawerController z = ZoomDrawerController();

class VocecaaDrawer extends StatefulWidget {
  const VocecaaDrawer({Key? key}) : super(key: key);

  @override
  State<VocecaaDrawer> createState() => _VocecaaDrawerState();
}

class _VocecaaDrawerState extends State<VocecaaDrawer> {
  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return ZoomDrawer(
      controller: z,
      borderRadius: 24,
      drawerShadowsBackgroundColor: Colors.grey[300]!,
      style: DrawerStyle.defaultStyle,
      menuBackgroundColor: Color.fromARGB(255, 15, 101, 170),
      showShadow: true,
      openCurve: Curves.fastOutSlowIn,
      slideWidth: isLandscape ? media.width * 0.6 : media.width * .8,
      duration: const Duration(milliseconds: 100),
      closeCurve: Curves.fastOutSlowIn,
      angle: 0.0,
      menuScreen: const Body(),
      mainScreen: HomeScreen(
        drawerAction: () {
          z.open!();
        },
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late HomePageCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<HomePageCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size media = mediaQuery.size;
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;
    double textBaseSize = isLandscape ? media.width : media.height;

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 15, 101, 170),
        body: Padding(
          padding: EdgeInsets.only(top: media.height * .05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: media.width * .6,
                child: ListTile(
                  onTap: () => z.close!(),
                  minLeadingWidth: 10,
                  dense: true,
                  leading: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Torna alla Home',
                    style: GoogleFonts.poppins(
                      fontSize: isLandscape
                          ? media.width * .015
                          : media.height * .015,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(left: media.width * .05),
                child: ListTile(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => ProfileInfoCubit(
                          voceAPIRepository: VoceAPIRepository(),
                          userId: cubit.userId,
                        ),
                        child: UserProfileScreen(),
                      ),
                    ),
                  ),
                  contentPadding: EdgeInsets.zero,
                  minVerticalPadding: 0,
                  leading: CircleAvatar(
                    backgroundColor: ConstantGraphics.colorYellow,
                    minRadius: 20,
                    maxRadius: 30,
                    child: Image.asset(
                      "assets/icons/avatars/child.png",
                      height: textBaseSize * .07,
                    ),
                  ),
                  title: BlocBuilder<HomePageCubit, HomePageState>(
                    builder: (context, state) {
                      return Text(
                        state is PatientListLoaded ? "${cubit.user.name}" : "",
                        style: GoogleFonts.poppins(
                          fontSize: isLandscape
                              ? media.width * .018
                              : media.height * .02,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  subtitle: Text(
                    'Visualizza il profilo',
                    style: GoogleFonts.poppins(
                      fontSize:
                          isLandscape ? media.width * .018 : media.height * .02,
                      color: Colors.white60,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: media.width * .05,
                  top: media.height * .04,
                ),
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  minVerticalPadding: 0,
                  title: Text(
                    'Sessione comunicativa',
                    style: GoogleFonts.poppins(
                      fontSize:
                          isLandscape ? media.width * .02 : media.height * .025,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    'Accedi alla sessione comunicativa per dialogare con un soggetto',
                    style: GoogleFonts.poppins(
                      fontSize: isLandscape
                          ? media.width * .015
                          : media.height * .015,
                      color: Colors.white70,
                    ),
                  ),
                  onTap: () {
                    var cubit = BlocProvider.of<HomePageCubit>(context);
                    if (cubit.user.patientList!.isNotEmpty) {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => CommunicationHomePageScreen(),
                      //   ),
                      // );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => CommunicationSetupCubit(
                              voceAPIRepository: VoceAPIRepository(),
                              user: cubit.user,
                            ),
                            child: CommunicationSetupScreen(),
                          ),
                        ),
                      );
                    } else {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => MbError(
                          heightFactor: .7,
                          title: 'Non puoi ancora accedere',
                          subtitle:
                              'Per accedere alla sezione comunicativa devi avere creato almeno un profilo di un soggetto. Clicca sul tasto "aggiungi" nella schermata principale',
                        ),
                        isDismissible: false,
                        enableDrag: false,
                        backgroundColor: Colors.black.withOpacity(0),
                        isScrollControlled: true,
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: media.width * .05,
                  top: media.height * .01,
                ),
                child: ListTile(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => SocialStoryCommunicationSetupCubit(
                          VoceAPIRepository(),
                          cubit.user,
                        ),
                        child: SocialStoryCommunicationSetupScreen(),
                      ),
                    ),
                  ),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  minVerticalPadding: 0,
                  title: Text(
                    'Storie sociali',
                    style: GoogleFonts.poppins(
                      fontSize:
                          isLandscape ? media.width * .02 : media.height * .025,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    'Accedi alle storie sociali per visualizzare le storie sociali associate ad un soggetto',
                    style: GoogleFonts.poppins(
                      fontSize: isLandscape
                          ? media.width * .015
                          : media.height * .015,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: media.width * .05,
                  top: media.height * .07,
                ),
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  minVerticalPadding: 0,
                  title: Text(
                    'Crediti',
                    style: GoogleFonts.poppins(
                      fontSize: isLandscape
                          ? media.width * .015
                          : media.height * .018,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => VoceModalCredits(),
                      backgroundColor: Colors.black.withOpacity(0),
                      isScrollControlled: true,
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: media.width * .05,
                  top: media.height * .01,
                ),
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  minVerticalPadding: 0,
                  title: Text(
                    'Privacy Policy',
                    style: GoogleFonts.poppins(
                      fontSize: isLandscape
                          ? media.width * .015
                          : media.height * .018,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () async {
                    await launchUrl(Uri.parse(
                        "https://vocepecs.unipv.it/wp-content/uploads/2024/01/VOCE_privacy.pdf"));
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: media.width * .05,
                  top: media.height * .01,
                ),
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  minVerticalPadding: 0,
                  title: Text(
                    'Progetto VOCE',
                    style: GoogleFonts.poppins(
                      fontSize: isLandscape
                          ? media.width * .015
                          : media.height * .018,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () async {
                    await launchUrl(Uri.parse("https://vocepecs.unipv.it/"));
                  },
                ),
              ),
              const Spacer(
                flex: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: media.width * .05),
                child: ListTile(
                  onTap: () {
                    cubit.signOut();
                  },
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  minVerticalPadding: 0,
                  title: Text(
                    'Disconnetti',
                    style: GoogleFonts.poppins(
                      fontSize:
                          isLandscape ? media.width * .02 : media.height * .023,
                      color: ConstantGraphics.colorPink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Spacer(
                flex: isLandscape ? 1 : 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: media.width * .05),
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  minVerticalPadding: 0,
                  title: Text(
                    'Versione $APP_VERSION',
                    style: GoogleFonts.poppins(
                      fontSize:
                          isLandscape ? media.width * .01 : media.height * .015,
                      color: Colors.white,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
