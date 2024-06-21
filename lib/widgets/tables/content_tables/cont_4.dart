import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voce/cubit/table_panel_cubit.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/enums/table_format.dart';
import 'package:voce/widgets/tables/reordable_sector.dart';


class ConT4 extends StatefulWidget {
  const ConT4({
    Key? key,
    required this.caaTable,
  }) : super(key: key);

  final CaaTable caaTable;

  @override
  State<ConT4> createState() => _ConT4State();
}

class _ConT4State extends State<ConT4> {
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
      height: orientation == Orientation.portrait ? media.height * .31: media.height * .7,
      child: Table(
        border: TableBorder(
          verticalInside: BorderSide(
            color: Colors.black87,
            width: 2,
          ),
          horizontalInside: BorderSide(
            color: Colors.black87,
            width: 2,
          ),
        ),
        columnWidths: const <int, TableColumnWidth>{
          0: FlexColumnWidth(),
          1: FlexColumnWidth(),
        },
        children: <TableRow>[
          TableRow(children: [
            SizedBox(
              height: orientation == Orientation.portrait ? media.width < 600 ? media.height * .15 : media.height *.2 : media.height * .32,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ReordableTableSector(
                imageList: widget.caaTable.sectorList[0].imageList,
                tableSector: widget.caaTable.sectorList[0],
                tableFormat: TableFormat.FOUR_SECTORS,
                sectorIndex: 0,
                          ),
              ),
            ),
            SizedBox(
             height: orientation == Orientation.portrait ? media.width < 600 ? media.height * .15 : media.height *.2 : media.height * .32,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ReordableTableSector(
                imageList: widget.caaTable.sectorList[1].imageList,
                tableSector: widget.caaTable.sectorList[1],
                tableFormat: TableFormat.FOUR_SECTORS,
                sectorIndex: 1,
                          ),
              ),
            ),
          ]),
          TableRow(children: [
            SizedBox(
              height: orientation == Orientation.portrait ? media.width < 600 ? media.height * .15 : media.height *.2 : media.height * .32,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ReordableTableSector(
                imageList: widget.caaTable.sectorList[2].imageList,
                tableSector: widget.caaTable.sectorList[2],
                tableFormat: TableFormat.FOUR_SECTORS,
                sectorIndex: 2,
                          ),
              ),
            ),
            SizedBox(
              height: orientation == Orientation.portrait ? media.width < 600 ? media.height * .15 : media.height *.2 : media.height * .32,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ReordableTableSector(
                imageList: widget.caaTable.sectorList[3].imageList,
                tableSector: widget.caaTable.sectorList[3],
                tableFormat: TableFormat.FOUR_SECTORS,
                sectorIndex: 3,
                          ),
              ),
            ),
          ])
        ],
      ),
    );
  }
}
