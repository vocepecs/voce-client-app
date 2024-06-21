import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/dedicated_cubits/download_public_tables_cubit.dart';
import 'package:voce/cubit/tables_screen_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecaa_searchbar.dart';
import 'package:voce/widgets/vocecca_card.dart';

class PublicTableDownloadPanel extends StatelessWidget {
  const PublicTableDownloadPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    var cubit = BlocProvider.of<DownloadPublicTablesCubit>(context);
    return SizedBox(
      width: media.width * .5,
      height: media.height * .32,
      child: VocecaaCard(
        hasShadow: false,
        // padding: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ListTile(
              title: Text(
                'Scarica le tabelle pubbliche',
                style: GoogleFonts.poppins(
                  fontSize: media.width * .016,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Effettua una ricerca tramite parole chiave oppure lascia il campo vuoto per scaricare tutte le tabelle pubbliche',
                style: GoogleFonts.poppins(
                  fontSize: media.width * .014,
                ),
              ),
            ),
            Spacer(
              flex: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: media.width * .3,
                  child: VocecaaSearchBar(
                    marginRatio: 0,
                    hintText: 'Inserisci le parole chiave',
                    onTextChange: (value) {
                      cubit.updatePattern(value);
                    },
                    showSuffixIcon: false,
                  ),
                ),
                VocecaaButton(
                    color: ConstantGraphics.colorPink,
                    text: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Scarica le tabelle',
                        style: GoogleFonts.poppins(
                          fontSize: media.width * .014,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () {
                      cubit.getPublicTables();
                    })
              ],
            ),
            Spacer()
          ],
        ),
      ),
    );
  }
}
