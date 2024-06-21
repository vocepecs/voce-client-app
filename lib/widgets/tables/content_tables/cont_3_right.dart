import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voce/cubit/table_panel_cubit.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/enums/table_format.dart';
import 'package:voce/widgets/tables/reordable_sector.dart';

class ConT3Right extends StatefulWidget {
  const ConT3Right({
    Key? key,
    required this.caaTable,
  }) : super(key: key);

  final CaaTable caaTable;

  @override
  State<ConT3Right> createState() => _ConT3RightState();
}

class _ConT3RightState extends State<ConT3Right> {
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
      child: Row(
        children: [
          Expanded(
            flex: orientation == Orientation.landscape
                ? Platform.isAndroid
                    ? 12
                    : 9
                : 8,
            child: Column(
              children: [
                Expanded(
                  flex: media.width < 600
                      ? 4
                      : orientation == Orientation.landscape
                          ? 3
                          : 5,
                  child: ReordableTableSector(
                    imageList: widget.caaTable.sectorList[0].imageList,
                    tableSector: widget.caaTable.sectorList[0],
                    tableFormat: TableFormat.THREE_SECTORS_RIGHT,
                    sectorIndex: 0,
                  ),
                ),
                Divider(
                  color: Colors.black87,
                  thickness: 2,
                ),
                Expanded(
                  flex: 8,
                  child: ReordableTableSector(
                    imageList: widget.caaTable.sectorList[2].imageList,
                    tableSector: widget.caaTable.sectorList[2],
                    tableFormat: TableFormat.THREE_SECTORS_RIGHT,
                    sectorIndex: 2,
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(
            color: Colors.black87,
            thickness: 2,
          ),
          Expanded(
            flex: 3,
            child: ReordableTableSector(
              imageList: widget.caaTable.sectorList[1].imageList,
              tableSector: widget.caaTable.sectorList[1],
              tableFormat: TableFormat.THREE_SECTORS_RIGHT,
              sectorIndex: 1,
            ),
          ),
        ],
      ),
    );
  }
}
