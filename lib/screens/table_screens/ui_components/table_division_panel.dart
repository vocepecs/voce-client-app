import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voce/cubit/table_panel_cubit.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/enums/table_format.dart';
import 'package:voce/widgets/mbs/mb_confirm_new.dart';
import 'package:voce/widgets/table_placeholder_1.dart';
import 'package:voce/widgets/table_placeholder_2.dart';
import 'package:voce/widgets/table_placeholder_2_horizontal.dart';
import 'package:voce/widgets/table_placeholder_3.dart';
import 'package:voce/widgets/table_placeholder_3_reverse.dart';
import 'package:voce/widgets/table_placeholder_4.dart';

class TableDivisionPanel extends StatefulWidget {
  const TableDivisionPanel({
    Key? key,
    required this.caaTable,
  }) : super(key: key);

  final CaaTable caaTable;

  @override
  State<TableDivisionPanel> createState() => _TableDivisionPanelState();
}

class _TableDivisionPanelState extends State<TableDivisionPanel> {
  late TablePanelCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<TablePanelCubit>(context);
  }

  bool _isSelected(TablePanelState state, int index) {
    int caaIndex = (state as TablePanelLoaded).caaTable.tableFormat.index;
    return caaIndex == index;
  }

  Future<bool> _alert() {
    return showModalBottomSheet(
      context: context,
      builder: (context) => VoceModalConfirm(
        title: "Attenzione",
        subtitle:
            "Sei sicuro di voler cambiare il formato della tabella? Tutte le immagini inserite verranno eliminate.",
        animationPath: "assets/anim_warning.json",
      ),
      backgroundColor: Colors.black.withOpacity(0),
      isScrollControlled: true,
    ).then((value) => value);
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return BlocBuilder<TablePanelCubit, TablePanelState>(
      builder: (context, state) {
        if (state is TablePanelInitial) {
          return Center(child: CircularProgressIndicator());
        } else {
          return GridView(
            physics: NeverScrollableScrollPhysics(),

            padding: orientation == Orientation.landscape
                ? EdgeInsets.fromLTRB(60, 10, 60, 0)
                : EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: orientation == Orientation.landscape
                  ? 3
                  : media.width < 600
                      ? 6
                      : 6, // Numero di colonne
              mainAxisSpacing: 5.0, // Spazio verticale tra le righe
              crossAxisSpacing: 5.0,
              childAspectRatio: orientation == Orientation.landscape
                  ? 3 / 3
                  : media.width < 600
                      ? 3 / 3
                      : 3 / 3, // Spazio orizzontale tra le colonne
            ),
            // shrinkWrap: true,
            // scrollDirection: Axis.vertical,
            children: [
              TablePlaceholder1(
                onTap: () {
                  if (cubit.caaTable!.getAllImages().isNotEmpty) {
                    _alert().then((value) {
                      if (value)
                        cubit.updateTableFormat(TableFormat.SINGLE_SECTOR);
                    });
                  } else {
                    cubit.updateTableFormat(TableFormat.SINGLE_SECTOR);
                  }
                },
                isSelected: _isSelected(state, 0),
              ),
              GestureDetector(
                onTap: () {
                  if (cubit.caaTable!.getAllImages().isNotEmpty) {
                    _alert().then((value) {
                      if (value)
                        cubit.updateTableFormat(
                          TableFormat.TWO_SECTORS_VERTICAL,
                        );
                    });
                  } else {
                    cubit.updateTableFormat(TableFormat.TWO_SECTORS_VERTICAL);
                  }
                },
                child: TablePlaceholder2(
                  isSelected: _isSelected(state, 1),
                ),
              ),
              GestureDetector(
                  onTap: () {
                    if (cubit.caaTable!.getAllImages().isNotEmpty) {
                    _alert().then((value) {
                      if (value)
                        cubit.updateTableFormat(
                          TableFormat.TWO_SECTORS_HORIZONTAL,
                        );
                    });
                  } else {
                    cubit.updateTableFormat(TableFormat.TWO_SECTORS_HORIZONTAL);
                  }
                  },
                  child: TablePlaceholder2Horizontal(
                    isSelected: _isSelected(state, 2),
                  )),
              GestureDetector(
                onTap: () {
                  if (cubit.caaTable!.getAllImages().isNotEmpty) {
                    _alert().then((value) {
                      if (value)
                        cubit.updateTableFormat(
                          TableFormat.THREE_SECTORS_LEFT,
                        );
                    });
                  } else {
                    cubit.updateTableFormat(TableFormat.THREE_SECTORS_LEFT);
                  }
                },
                child: TablePlaceholder3Reverse(
                  isSelected: _isSelected(state, 3),
                ),
              ),
              GestureDetector(
                onTap: () {
                   if (cubit.caaTable!.getAllImages().isNotEmpty) {
                    _alert().then((value) {
                      if (value)
                        cubit.updateTableFormat(
                          TableFormat.THREE_SECTORS_RIGHT,
                        );
                    });
                  } else {
                    cubit.updateTableFormat(TableFormat.THREE_SECTORS_RIGHT);
                  }
                },
                child: TablePlaceholder3(
                  isSelected: _isSelected(state, 4),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (cubit.caaTable!.getAllImages().isNotEmpty) {
                    _alert().then((value) {
                      if (value)
                        cubit.updateTableFormat(
                          TableFormat.FOUR_SECTORS,
                        );
                    });
                  } else {
                    cubit.updateTableFormat(TableFormat.FOUR_SECTORS);
                  }
                },
                child: TablePlaceholder4(
                  isSelected: _isSelected(state, 5),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
