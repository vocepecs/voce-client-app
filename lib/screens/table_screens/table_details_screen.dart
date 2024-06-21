import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voce/cubit/table_panel_cubit.dart';
import 'package:voce/screens/auth_screens/mbs/mb_error.dart';
import 'package:voce/screens/table_screens/layouts/landscape_layout.dart';
import 'package:voce/screens/table_screens/layouts/portrait_layout.dart';
import 'package:voce/widgets/mbs/mb_confirm.dart';
import 'package:voce/widgets/mbs/mb_confirm_new.dart';

class TableDetailsScreen extends StatefulWidget {
  const TableDetailsScreen({Key? key}) : super(key: key);

  @override
  State<TableDetailsScreen> createState() => _TableDetailsScreenState();
}

class _TableDetailsScreenState extends State<TableDetailsScreen> {
  late TablePanelCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<TablePanelCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TablePanelCubit, TablePanelState>(
      listener: (context, state) {
        if (state is TableCreated) {
          showModalBottomSheet(
            context: context,
            builder: (context) => MbsAnimationAlert(
              title: 'Tabella creata!',
              subtitle: 'Orai tornerai nella pagina di gestione delle tabelle',
            ),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          ).then((value) => Navigator.pop(context));
        } else if (state is TableCreationError) {
          showModalBottomSheet(
            context: context,
            builder: (context) => MbError(
              title: 'Errore nella creazione della tabella!',
              subtitle: 'Orai tornerai nella pagina di gestione delle tabelle',
            ),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          ).then((value) => Navigator.pop(context));
        } else if (state is TableUpdated) {
          showModalBottomSheet(
            context: context,
            builder: (context) => MbsAnimationAlert(
              title: 'Tabella aggiornata!',
              subtitle: 'Orai tornerai nella pagina di gestione delle tabelle',
            ),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          ).then((value) => Navigator.pop(context));
        } else if (state is TableDuplicated) {
          showModalBottomSheet(
            context: context,
            builder: (context) => MbsAnimationAlert(
              title: 'Tabella duplicata con successo!',
              subtitle: 'Orai tornerai nella pagina di gestione delle tabelle',
            ),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          ).then((value) => Navigator.pop(context));
        } else if (state is TableDeleted) {
          showModalBottomSheet(
            context: context,
            builder: (context) => MbsAnimationAlert(
              title: 'Tabella eliminata con successo!',
              subtitle: 'Orai tornerai nella pagina di gestione delle tabelle',
            ),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          ).then((value) => Navigator.pop(context));
        } else if (state is TablePanelError) {
          showModalBottomSheet(
            context: context,
            builder: (context) => MbError(
              title: 'Errore creazione tabella CAA',
              subtitle: 'Non è possibile creare una tabella vuota!',
            ),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          ).then((value) => cubit.emitTablePanelLoaded());
        } else if (state is TablePanelPersonalImagesWarning) {
          showModalBottomSheet(
            context: context,
            builder: (context) => VoceModalConfirm(
              animationPath: "assets/anim_warning.json",
              title: "Attenzione!",
              subtitle:
                  "Nella tabella sono presenti pittogrammi personali. Se confermi la tabella sarà resa automaticamente privata",
            ),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          ).then((value) {
            if (value) {
              cubit.saveTable(confirmPersonalImages: value);
            } else {
              cubit.emitTablePanelLoaded();
            }
          });
        }
      },
      builder: (context, state) {
        print(state);
        if (state is TablePanelLoaded) {
          return OrientationBuilder(
            builder: (context, orientation) {
              if (orientation == Orientation.landscape) {
                return TableDetailScreenLandscape();
              } else {
                return TableDetailScreenPortrait(caaTable: state.caaTable);
              }
            },
          );
        } else if (state is TablePanelLoading || state is TablePanelInitial) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Scaffold();
        }
      },
    );
  }
}
