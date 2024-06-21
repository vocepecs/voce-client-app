import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voce/cubit/image_list_panel_cubit.dart';
import 'package:voce/cubit/speech_to_text_cubit.dart';
import 'package:voce/cubit/table_context_cubit.dart';
import 'package:voce/cubit/table_panel_cubit.dart';
import 'package:voce/cubit/tables_screen_cubit.dart';
import 'package:voce/models/enums/table_operation.dart';
import 'package:voce/screens/table_screens/mbs/mb_table_details.dart';
import 'package:voce/screens/table_screens/table_details_screen.dart';
import 'package:voce/services/speech_to_text_API.dart';
import 'package:voce/services/voce_api_repository.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecca_card.dart';

class NoExistingTablesNotice extends StatelessWidget {
  const NoExistingTablesNotice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    var cubit = BlocProvider.of<TablesScreenCubit>(context);
    return Center(
      child: VocecaaCard(
          hasShadow: true,
          child: SizedBox(
            width: media.width * .5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListTile(
                  title: Text(
                    'Non hai creato ancora nessuna tabella',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: media.width * .022,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Utilizza il pulsante \'Crea tabella\' per creare una nuova tabella CAA',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: media.width * .016,
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                SizedBox(
                  width: media.width * .15,
                  child: VocecaaButton(
                      color: Color(0xFFFFE45E),
                      text: ListTile(
                        contentPadding: EdgeInsets.zero,
                        minLeadingWidth: 0,
                        dense: true,
                        leading: Icon(
                          Icons.add_circle_outline_rounded,
                          size: media.width * .02,
                        ),
                        title: Text(
                          'Crea tabella',
                          style: GoogleFonts.poppins(
                            fontSize: media.width * .015,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MultiBlocProvider(
                                providers: [
                                  BlocProvider<SpeechToTextCubit>(
                                    create: (context) => SpeechToTextCubit(),
                                  ),
                                  BlocProvider<TablePanelCubit>(
                                    create: (context) => TablePanelCubit(
                                      user: cubit.user,
                                      voceApiRepository: VoceAPIRepository(),
                                      tableOperation:
                                          CAAContentOperation.CREATE_GENERAL,
                                    ),
                                  ),
                                  BlocProvider<TableContextCubit>(
                                    create: (context) => TableContextCubit(
                                      voceAPIRepository: VoceAPIRepository(),
                                    ),
                                  ),
                                  BlocProvider(
                                    create: (context) => ImageListPanelCubit(
                                      voceAPIRepository: VoceAPIRepository(),
                                      user: cubit.user,
                                    ),
                                  )
                                ],
                                child: TableDetailsScreen(),
                              ),
                            )).then((_) {
                          var cubit =
                              BlocProvider.of<TablesScreenCubit>(context);
                          cubit.getUserTables();
                        });
                      }),
                ),
              ],
            ),
          )),
    );
  }
}
