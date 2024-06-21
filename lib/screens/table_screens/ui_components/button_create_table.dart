import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:voce/cubit/image_list_panel_cubit.dart';
import 'package:voce/cubit/speech_to_text_cubit.dart';
import 'package:voce/cubit/table_context_cubit.dart';
import 'package:voce/cubit/table_panel_cubit.dart';
import 'package:voce/cubit/tables_screen_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/models/enums/table_operation.dart';

import 'package:voce/screens/table_screens/table_details_screen.dart';

import 'package:voce/services/voce_api_repository.dart';
import 'package:voce/widgets/vocecaa_button.dart';

class ButtonCreateTable extends StatelessWidget {
  const ButtonCreateTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    var cubit = BlocProvider.of<TablesScreenCubit>(context);
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return VocecaaButton(
      color: ConstantGraphics.colorYellow,
      text: AutoSizeText(
        "Crea tabella",
        maxLines: 1,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontSize: isLandscape ? media.width * .015 : media.height * .016,
          fontWeight: FontWeight.bold,
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
                      tableOperation: CAAContentOperation.CREATE_GENERAL,
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
          var cubit = BlocProvider.of<TablesScreenCubit>(context);
          cubit.getUserTables();
        });
      },
    );
  }
}
