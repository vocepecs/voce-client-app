import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/multimedia_content_screen_cubit.dart';
import 'package:voce/widgets/vocecaa_labeled_switch.dart';

class FilterByOwnershipPanel extends StatelessWidget {
  const FilterByOwnershipPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    var cubit = BlocProvider.of<MultimediaContentScreenCubit>(context);
    return Container(
      padding: EdgeInsets.all(8.0),
      height: media.height * .3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ListTile(
            title: Text(
              'Filtra per proprietà',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Visualizza le immagini pubbliche o private',
              style: GoogleFonts.poppins(),
            ),
          ),
          Spacer(),
          SizedBox(
            width: double.maxFinite,
            child: VocecaaLabeledSwitch(
              onChange: (value) {
                cubit.updateFilterPublic(value);
              },
              label: 'Pubbliche',
            ),
          ),
          SizedBox(height: 5),
          SizedBox(
            width: double.maxFinite,
            child: VocecaaLabeledSwitch(
              onChange: (value) {
                cubit.updateFilterPrivate(value);
              },
              label: 'Private',
            ),
          ),
        ],
      ),
    );
  }
}
