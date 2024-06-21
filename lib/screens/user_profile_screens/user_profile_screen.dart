import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/auth_cubit.dart';
import 'package:voce/cubit/profile_info_screen/profile_info_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/screens/auth_screens/root_screen.dart';
import 'package:voce/screens/user_profile_screens/ui_components/centre_data_panel.dart';
import 'package:voce/screens/user_profile_screens/ui_components/operator_data_panel.dart';
import 'package:voce/services/auth_repository.dart';
import 'package:voce/services/voce_api_repository.dart';
import 'package:voce/widgets/mbs/mb_confirm.dart';
import 'package:voce/widgets/vocecaa_button.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late ProfileInfoCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<ProfileInfoCubit>(context);
    cubit.getUserData();
  }

  Widget _buildLandscapeLayout() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 3,
            child: OperatorDataPanel(),
          ),
          Spacer(flex: cubit.user.autismCentre?.id != null ? 1 : 4),
          if (cubit.user.autismCentre?.id != null)
            Expanded(
              flex: 3,
              child: CentreDataPanel(),
            )
        ],
      ),
    );
  }

  Widget _buildPortraitLayout() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Expanded(
            child: OperatorDataPanel(),
          ),
          if (cubit.user.autismCentre?.id != null)
            Expanded(
              child: CentreDataPanel(),
            )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    double textBaseSize =
        orientation == Orientation.landscape ? media.width : media.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Profilo utente',
          style: GoogleFonts.poppins(
            fontSize: textBaseSize * .022,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<ProfileInfoCubit, ProfileInfoState>(
        listener: (context, state) {
          if (state is ProfileInfoUpdated) {
            showModalBottomSheet(
              context: context,
              builder: (context) => MbsAnimationAlert(
                title: 'Dati utente aggiornati',
                subtitle: 'I dati utente sono stati aggiornati con successo',
              ),
              backgroundColor: Colors.black.withOpacity(0),
              isScrollControlled: true,
            ).then((_) => cubit.emitProfileInfoLoaded());
          } else if (state is ProfileInfoUpdateError) {
            showModalBottomSheet(
              context: context,
              builder: (context) => MbsAnimationAlert(
                title: "Problema nell'aggiornamento dei dati",
                subtitle: state.message,
                animationPath: "assets/anim_warning.json",
              ),
              backgroundColor: Colors.black.withOpacity(0),
              isScrollControlled: true,
            ).then((_) => cubit.emitProfileInfoLoaded());
          } else if (state is ProfileInfoDeleted) {
            showModalBottomSheet(
              context: context,
              builder: (context) => MbsAnimationAlert(
                title: 'Richiesta di eliminazione inviata',
                subtitle:
                    'Abbiamo elaborato la tua richiesta di eliminazione\nsarai reindirizzato alla pagina di login.',
              ),
              backgroundColor: Colors.black.withOpacity(0),
              isScrollControlled: true,
            ).then((_) => cubit.signOut());
          } else if (state is UserSignOut) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => AuthCubit(
                      voceAPIRepository: VoceAPIRepository(),
                      authRepository: AuthRepository()),
                  child: RootScreen(),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileInfoLoaded) {
            return OrientationBuilder(
              builder: (context, orientation) {
                if (orientation == Orientation.landscape) {
                  return _buildLandscapeLayout();
                } else {
                  return _buildPortraitLayout();
                }
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: ConstantGraphics.colorBlue,
              ),
            );
          }
        },
      ),
      floatingActionButton: SizedBox(
        width: orientation == Orientation.landscape
            ? media.width * .18
            : media.width * .9,
        height: media.height * .07,
        child: VocecaaButton(
          color: Color(0xFFFFE45E),
          text: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (orientation == Orientation.landscape)
                Icon(Icons.save_as_outlined),
              if (orientation == Orientation.landscape) SizedBox(width: 3),
              Text(
                'Salva le modifiche',
                style: GoogleFonts.poppins(
                  fontSize: orientation == Orientation.landscape
                      ? textBaseSize * .013
                      : textBaseSize * .02,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          onTap: () {
            // cubit.saveTable();
            //Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
