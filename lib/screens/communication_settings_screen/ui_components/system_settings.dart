import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/communication_settings_panel_cubit.dart';
import 'package:voce/cubit/home_page_cubit.dart';
import 'package:voce/screens/home_page/home_screen.dart';
import 'package:voce/services/auth_repository.dart';
import 'package:voce/services/voce_api_repository.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecaa_drawer.dart';

class SystemSettingsScreen extends StatefulWidget {
  _SystemSettingsScreen createState() => _SystemSettingsScreen();
}

class _SystemSettingsScreen extends State<SystemSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    String bullet = "\u2022 ";
    var cubit = BlocProvider.of<CommunicationSetupCubit>(context);
    return Stack(
      children: [
        Container(
          alignment: Alignment.topCenter,
          height: double.infinity,
          width: media.width * 0.35,
          padding: EdgeInsets.only(
            top: media.height * 0.035,
            left: media.width * 0.03,
            right: media.width * 0.05,
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: media.width * 0.3,
              maxHeight: media.height * 0.5,
            ),
            padding: EdgeInsets.only(
              top: media.height * 0.015,
              bottom: media.height * 0.015,
              left: media.width * 0.015,
              right: media.width * 0.015,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: ListView(
              children: [
                Text(
                  'Impostazioni',
                  style: GoogleFonts.poppins(
                    fontSize: media.width * 0.017,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  bullet + 'Luminosità',
                  style: GoogleFonts.poppins(
                    fontSize: media.width * 0.012,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  bullet + 'Volume',
                  style: GoogleFonts.poppins(
                    fontSize: media.width * 0.012,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  bullet + 'Aggiornamento immagini',
                  style: GoogleFonts.poppins(
                    fontSize: media.width * 0.012,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  height: media.height * 0.015,
                ),
                Text(
                  'Torna alla home page',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: media.width * 0.012,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  width: media.width * .13,
                  padding: EdgeInsets.symmetric(
                    horizontal: media.height * 0.002,
                    vertical: media.width * 0.002,
                  ),
                  child: VocecaaButton(
                    color: Color(0xFFFFE45E),
                    text: Text(
                      'Accedi',
                      style: GoogleFonts.poppins(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: media.width * .012,
                      ),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => HomePageCubit(
                            voceAPIRepository: VoceAPIRepository(),
                            authRepository: AuthRepository(),
                            userId: cubit.user.id!,
                          ),
                          child: VocecaaDrawer(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
