import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voce/cubit/table_panel_cubit.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/enums/table_format.dart';
import 'package:voce/widgets/tables/reordable_sector.dart';


class ConT3Left extends StatefulWidget {
  const ConT3Left({
    Key? key,
    required this.caaTable,
  }) : super(key: key);

  final CaaTable caaTable;

  @override
  State<ConT3Left> createState() => _ConT3LeftState();
}

class _ConT3LeftState extends State<ConT3Left> {
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
            flex: 3,
            child: ReordableTableSector(
              imageList: widget.caaTable.sectorList[0].imageList,
              tableSector: widget.caaTable.sectorList[0],
              tableFormat: TableFormat.THREE_SECTORS_LEFT,
              sectorIndex: 0,
            ),
          ),
          VerticalDivider(
            color: Colors.black87,
            thickness: 2,
          ),
          Expanded(
            flex: 9,
            child: Column(
              children: [
                Expanded(
                  flex: media.width < 600 ? 4 : orientation == Orientation.landscape ? 3 : 5,
                  child: ReordableTableSector(
                imageList: widget.caaTable.sectorList[1].imageList,
                tableSector: widget.caaTable.sectorList[1],
                tableFormat: TableFormat.THREE_SECTORS_LEFT,
                sectorIndex: 1,
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
                tableFormat: TableFormat.THREE_SECTORS_LEFT,
                sectorIndex: 2,
              ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
