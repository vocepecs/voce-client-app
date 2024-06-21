import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/profile_info_screen/profile_info_cubit.dart';
import 'package:voce/screens/user_profile_screens/ui_components/profile_info_list_tile.dart';

class CentreDataPanel extends StatelessWidget {
  const CentreDataPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
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
                if(orientation == Orientation.landscape)
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
                          Icons.house_rounded,
                          size: textBaseSize * .03,
                        ),
                      ),
                    ),
                    title: Text(
                      '${state.user.autismCentre!.name}',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: textBaseSize * .016,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      (() {
                        if (state.user.autismCentre!.address == null) {
                          return "Non specificato";
                        } else {
                          return state.user.autismCentre!.address!;
                        }
                      }()),
                      // '${state.user.autismCentre!.address}',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: textBaseSize * .015,
                          color: Colors.black54),
                    ),
                  ),
                ),
                SizedBox(height: media.height * .0),
                ProfileInfoListTile(
                  title: 'Nome centro',
                  subtitle: '${state.user.autismCentre!.name}',
                  onTap: () {},
                ),
                ProfileInfoListTile(
                  title: 'Indirizzo',
                  subtitle: (() {
                    if (state.user.autismCentre!.address == null) {
                      return "Non specificato";
                    } else {
                      return state.user.autismCentre!.address!;
                    }
                  }()),
                  onTap: () {},
                ),
                ProfileInfoListTile(
                  title: 'Secret Code',
                  subtitle: '${state.user.autismCentre!.secretCode}',
                  onTap: () {},
                  showTrailing: false,
                ),
                Spacer(flex: 2),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
