import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voce/cubit/table_panel_cubit.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/enums/table_format.dart';
import 'package:voce/widgets/tables/reordable_sector.dart';

class ConT2Vertical extends StatefulWidget {
  const ConT2Vertical({
    Key? key,
    required this.caaTable,
  }) : super(key: key);

  final CaaTable caaTable;

  @override
  State<ConT2Vertical> createState() => _ConT2VerticalState();
}

class _ConT2VerticalState extends State<ConT2Vertical> {
  late TablePanelCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.orientationOf(context);

    return SizedBox(
      width: orientation == Orientation.portrait
          ? media.width * .9
          : media.width * .35,
      child: Table(
        border: TableBorder(
            verticalInside: BorderSide(
          color: Colors.black87,
          width: 2,
        )),
        columnWidths: const <int, TableColumnWidth>{
          0: FlexColumnWidth(),
          1: FlexColumnWidth(),
        },
        children: <TableRow>[
          TableRow(
            children: [
              SizedBox(
                height: orientation == Orientation.portrait ? media.width < 600 ? media.height * .31 : media.height * .4 : media.height * .7,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ReordableTableSector(
                    imageList: widget.caaTable.sectorList[0].imageList,
                    tableSector: widget.caaTable.sectorList[0],
                    tableFormat: TableFormat.TWO_SECTORS_VERTICAL,
                    sectorIndex: 0,
                  ),
                ),
              ),
              SizedBox(
                height: orientation == Orientation.portrait ? media.width < 600 ? media.height * .31 : media.height * .4 : media.height * .7,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ReordableTableSector(
                    imageList: widget.caaTable.sectorList[1].imageList,
                    tableSector: widget.caaTable.sectorList[1],
                    tableFormat: TableFormat.TWO_SECTORS_VERTICAL,
                    sectorIndex: 1,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
