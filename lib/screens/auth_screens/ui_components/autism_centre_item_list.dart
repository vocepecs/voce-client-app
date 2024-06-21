import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/dedicated_cubits/sign_up_centre_panel_cubit.dart';
import 'package:voce/models/autism_centre.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecaa_text_field.dart';
import 'package:voce/widgets/vocecca_card.dart';

class AutismCentreItemList extends StatelessWidget {
  const AutismCentreItemList({
    Key? key,
    required this.autismCentre,
    this.scaleBase = 1,
  }) : super(key: key);

  final AutismCentre autismCentre;
  final double scaleBase;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return VocecaaCard(
      hasShadow: false,
      backgroundColor: Colors.grey[200]!,
      padding: EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: AutoSizeText(
              autismCentre.name,
              maxLines: 2,
              style: GoogleFonts.poppins(
                fontSize: orientation == Orientation.landscape ? scaleBase * .014 : scaleBase * .016,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: orientation == Orientation.landscape ? media.width * .12 : media.width * .3,
            height: orientation == Orientation.landscape ? media.height * .05 : media.height * .04,
            child: VocecaaTextField(
                onChanged: (value) {
                  var cubit = BlocProvider.of<SignUpCentrePanelCubit>(context);
                  cubit.updateAutsimCentreCode(value);
                },
                label: 'Codice',
                initialValue: ''),
          ),
          Spacer(),
          VocecaaButton(
            color: ConstantGraphics.colorYellow,
            text: Text(
              'Seleziona',
              style: GoogleFonts.poppins(
                fontSize: scaleBase * .014,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              var cubit = BlocProvider.of<SignUpCentrePanelCubit>(context);
              cubit.verifyAutismCentreCode(autismCentre.id!);
            },
          ),
        ],
      ),
    );
  }
}
