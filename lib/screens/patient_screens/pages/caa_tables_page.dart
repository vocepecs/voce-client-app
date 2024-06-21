import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voce/cubit/image_list_panel_cubit.dart';
import 'package:voce/cubit/patient_screen_cubit.dart';
import 'package:voce/cubit/speech_to_text_cubit.dart';
import 'package:voce/cubit/table_context_cubit.dart';
import 'package:voce/cubit/table_panel_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/models/enums/table_operation.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/screens/table_screens/table_details_screen.dart';
import 'package:voce/screens/table_screens/ui_components/table_card.dart';
import 'package:voce/services/voce_api_repository.dart';

class PatientCaaTablesPage extends StatelessWidget {
  const PatientCaaTablesPage({
    Key? key,
    required this.patient,
  }) : super(key: key);

  final Patient patient;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    var cubit = BlocProvider.of<PatientScreenCubit>(context);
    Orientation orientation = MediaQuery.of(context).orientation;
    double textBaseSize =
        orientation == Orientation.landscape ? media.width : media.height;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: media.width < 600 ? 1 : 2, // Numero di colonne
        mainAxisSpacing: 10.0, // Spazio verticale tra le righe
        crossAxisSpacing: 10.0,
        childAspectRatio: orientation == Orientation.landscape
            ? 6 / 3
            : media.width < 600
                ? 8 / 3
                : 7 / 3, // Spazio orizzontale tra le colonne
      ),
      itemCount: patient.tableList.length,
      itemBuilder: (context, index) => TableCard(
        caaTable: patient.tableList[index],
        bottomRightActions: [
          GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AutoSizeText(
                    'Maggiori dettagli',
                    maxLines: 1,
                    style: GoogleFonts.poppins(
                        fontSize: textBaseSize * .013,
                        fontWeight: FontWeight.bold,
                        color: ConstantGraphics.colorPink),
                  ),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: textBaseSize * .02,
                    color: ConstantGraphics.colorPink,
                  ),
                ],
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
                                tableOperation: CAAContentOperation.UPDATE,
                                caaTable: patient.tableList[index],
                                patient: cubit.patient),
                          ),
                          BlocProvider<TableContextCubit>(
                            create: (context) => TableContextCubit(
                              voceAPIRepository: VoceAPIRepository(),
                            ),
                          ),
                          BlocProvider(
                            create: (context) => ImageListPanelCubit(
                              user: cubit.user,
                              voceAPIRepository: VoceAPIRepository(),
                            ),
                          )
                        ],
                        child: TableDetailsScreen(),
                      ),
                    )).then((_) {
                  var cubit = BlocProvider.of<PatientScreenCubit>(context);
                  cubit.getPatientData();
                });
              }),
        ],
      ),
    );
  }
}
