import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/dedicated_cubits/download_public_tables_cubit.dart';
import 'package:voce/cubit/link_table_to_patient_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecaa_searchbar.dart';
import 'package:voce/widgets/vocecca_card.dart';

class DownloadPublicTablesPanel extends StatelessWidget {
  const DownloadPublicTablesPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    var cubit = BlocProvider.of<DownloadPublicTablesCubit>(context);
    return VocecaaCard(
      hasShadow: false,
      child: Container(
        // padding: EdgeInsets.all(media.width * .01),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: double.infinity,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  minVerticalPadding: 0,
                  visualDensity: VisualDensity.compact,
                  title: Text(
                    'Scarica le tabelle pubbliche',
                    style: GoogleFonts.poppins(
                      fontSize: media.width * .014,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Utilizza la barra di ricerca per scaricare una o più tabelle pubbliche dal database di Voce',
                    style: GoogleFonts.poppins(
                      fontSize: media.width * .013,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  VocecaaSearchBar(
                    hintText: 'Inserisci una parola chiave',
                    marginRatio: 0.01,
                    showSuffixIcon: false,
                    hasShadow: false,
                    onTextChange: (value) {
                      cubit.updatePattern(value);
                    },
                  ),
                  VocecaaButton(
                      color: ConstantGraphics.colorYellow,
                      text: Text(
                        'Scarica',
                        style: GoogleFonts.poppins(
                          fontSize: media.width * .015,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        cubit.getPublicTables();
                      })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
