import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voce/cubit/image_list_panel_cubit.dart';
import 'package:voce/cubit/speech_to_text_cubit.dart';
import 'package:voce/cubit/table_context_cubit.dart';
import 'package:voce/cubit/table_panel_cubit.dart';
import 'package:voce/cubit/tables_screen_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/models/enums/table_operation.dart';
import 'package:voce/screens/table_screens/mbs/mb_table_details.dart';
import 'package:voce/screens/table_screens/table_details_screen.dart';
import 'package:voce/screens/table_screens/ui_components/table_card.dart';
import 'package:voce/services/speech_to_text_API.dart';
import 'package:voce/services/voce_api_repository.dart';

// ! Deprecated
class TablesGridView extends StatelessWidget {
  const TablesGridView({
    Key? key,
    required this.state,
  }) : super(key: key);

  final TablesScreenLoaded state;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    var cubit = BlocProvider.of<TablesScreenCubit>(context);
    return Center(
      child: SingleChildScrollView(
        child: Wrap(
          runSpacing: 10,
          spacing: 10,
          children: List.generate(
            state.caaTableList.length,
            (index) => SizedBox(
              width: media.width * .32,
              child: TableCard(
                caaTable: state.caaTableList[index],
                bottomRightActions: <Widget>[
                  GestureDetector(
                    // color: Color(0xFFFFE45E),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Maggiori dettagli',
                          style: GoogleFonts.poppins(
                              fontSize: media.width * .013,
                              fontWeight: FontWeight.bold,
                              color: ConstantGraphics.colorPink),
                        ),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: media.width * .02,
                          color: ConstantGraphics.colorPink,
                        ),
                      ],
                    ),
                    onTap: () => Navigator.push(
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
                                tableOperation: CAAContentOperation.UPDATE,
                                caaTable: state.caaTableList[index],
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
                      ),
                    ).then((value) {
                      cubit.getUserTables();
                    }),
                    // onTap: () => showModalBottomSheet(
                    //   context: context,
                    //   builder: (context) => ,
                    //   backgroundColor: Colors.black.withOpacity(0),
                    //   isScrollControlled: true,
                    // ).then((value) {
                    //   cubit.getUserTables();
                    // }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
