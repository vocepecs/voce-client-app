import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/profile_info_screen/profile_info_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/screens/user_profile_screens/mbs/mb_update_profile_field.dart';
import 'package:voce/screens/user_profile_screens/mbs/modal_delete_account.dart';
import 'package:voce/screens/user_profile_screens/ui_components/profile_info_list_tile.dart';
import 'package:voce/widgets/mbs/mb_info.dart';

class OperatorDataPanel extends StatelessWidget {
  const OperatorDataPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    ProfileInfoCubit cubit = BlocProvider.of<ProfileInfoCubit>(context);
    double textBaseSize =
        orientation == Orientation.landscape ? media.width : media.height;
    return BlocBuilder<ProfileInfoCubit, ProfileInfoState>(
      builder: (context, state) {
        if (state is ProfileInfoLoaded) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(flex: 1),
                Expanded(
                  child: ListTile(
                    dense: true,
                    leading: Container(
                      width: textBaseSize * .05,
                      height: textBaseSize * .05,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.grey[350]),
                      child: Center(
                        child: Icon(
                          Icons.person,
                          size: textBaseSize * .03,
                        ),
                      ),
                    ),
                    title: Text(
                      '${state.user.name}',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: textBaseSize * .016,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      '${state.user.email}',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: textBaseSize * .015,
                          color: Colors.black54),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => ModalDeleteAccount(),
                        backgroundColor: Colors.black.withOpacity(0),
                        isScrollControlled: true,
                      ).then((value) {
                        if (value != null) {
                          cubit.sendDeleteAccountRequest();
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: ConstantGraphics.colorPink,
                      elevation: 0,
                    ),
                    child: Text(
                      'Richiedi eliminazione account',
                      style: GoogleFonts.poppins(
                        color: ConstantGraphics.colorPink,
                        fontWeight: FontWeight.bold,
                        fontSize: textBaseSize * .018,
                      ),
                    ),
                  ),
                ),
                Spacer(flex: 1),
                ProfileInfoListTile(
                  title: 'Nome',
                  subtitle: '${state.user.name}',
                  onTap: () {
                    showModalBottomSheet(
                      isDismissible: false,
                      context: context,
                      builder: (context) => MbUpdateProfileField(
                        initialValue: state.user.name,
                        textFieldLabel: 'Nome Utente',
                        title: 'Modifica Nome Utente',
                      ),
                      backgroundColor: Colors.black.withOpacity(0),
                      isScrollControlled: true,
                    ).then((value) => cubit.updateUserName(value[0] as String));
                  },
                ),
                ProfileInfoListTile(
                  title: 'Email',
                  subtitle: '${state.user.email}',
                  onTap: () {
                    showModalBottomSheet(
                      isDismissible: false,
                      context: context,
                      builder: (context) => MbUpdateProfileField(
                        initialValue: state.user.email,
                        textFieldLabel: 'Email utente',
                        title: 'Modifica email utente',
                      ),
                      backgroundColor: Colors.black.withOpacity(0),
                      isScrollControlled: true,
                    ).then(
                        (value) => cubit.updateUserEmail(value[0] as String));
                  },
                ),
                ProfileInfoListTile(
                  title: 'Password',
                  subtitle: '********',
                  isPasswordField: true,
                  onTap: () {
                    showModalBottomSheet(
                      isDismissible: false,
                      context: context,
                      builder: (context) => MbUpdateProfileField(
                        textFieldLabel: 'Inserisci la nuova password',
                        title: 'Modifica password utente',
                        isPasswordUpdate: true,
                      ),
                      backgroundColor: Colors.black.withOpacity(0),
                      isScrollControlled: true,
                    ).then(
                      (value) => cubit.updateUserPassword(
                        value[0] as String,
                        value[1] as String,
                      ),
                    );
                  },
                ),
                Spacer(flex: orientation == Orientation.landscape ? 2 : 6),
              ],
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
