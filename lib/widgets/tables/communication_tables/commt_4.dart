import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuple/tuple.dart';
import 'package:voce/cubit/patient_communication_cubit.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/table_sector.dart';
import 'package:voce/widgets/vocecaa_pictogram.dart';

class CommT4 extends StatefulWidget {
  final CaaTable caaTable;

  const CommT4({
    Key? key,
    required this.caaTable,
  }) : super(key: key);

  @override
  State<CommT4> createState() => _CommT4State();
}

class _CommT4State extends State<CommT4> {
  late PatientCommunicationCubit cubit;

  @override
  void initState() {
    super.initState();

    cubit = BlocProvider.of<PatientCommunicationCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;

    return SizedBox(
      width: orientation == Orientation.portrait
          ? media.width * .9
          : media.width * .35,
      height: orientation == Orientation.portrait
          ? media.height * .52
          : media.height * .6,
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
        children: [
          TableRow(
            children: [
              SizedBox(
                height: orientation == Orientation.portrait
                    ? media.width < 600
                        ? media.height * .21
                        : media.height * .26
                    : media.height * .29,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildTableSector(widget.caaTable.sectorList[0], 0)),
              ),
              SizedBox(
                height: orientation == Orientation.portrait
                    ? media.width < 600
                        ? media.height * .21
                        : media.height * .26
                    : media.height * .29,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildTableSector(widget.caaTable.sectorList[1], 1)),
              ),
            ],
          ),
          TableRow(
            children: [
              SizedBox(
                height: orientation == Orientation.portrait
                    ? media.width < 600
                        ? media.height * .21
                        : media.height * .26
                    : media.height * .29,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildTableSector(widget.caaTable.sectorList[3], 3)),
              ),
              SizedBox(
                height: orientation == Orientation.portrait
                    ? media.width < 600
                        ? media.height * .21
                        : media.height * .26
                    : media.height * .29,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildTableSector(widget.caaTable.sectorList[2], 2)),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTableSector(TableSector tableSector, int sectorIndex) {
    Orientation orientation = MediaQuery.of(context).orientation;
    Size media = MediaQuery.of(context).size;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              orientation == Orientation.landscape ? 3 : 2, // Numero di colonne
          mainAxisSpacing: 5.0, // Spazio verticale tra le righe
          crossAxisSpacing: 5.0,
          childAspectRatio: 1 // Spazio orizzontale tra le colonne
          ),
      itemCount: tableSector.imageList.length,
      itemBuilder: (context, index) => VocecaaPictogram(
        widthFactor: .3,
        heightFactor: .25,
        fontSizeFactor: orientation == Orientation.portrait ? .035 : .018,
        caaImage: tableSector.imageList[index],
        color: Color(tableSector.sectorColor),
        onTap: () {
          cubit.updateImageBar(
            Tuple2(
              tableSector.imageList[index],
              Color(tableSector.sectorColor),
            ),
            widget.caaTable,
          );
          if (cubit.getActivePatient().fullTtsEnabled) {
            cubit.playAudio(tableSector.imageList[index].audioTTSList);
          }
        },
      ),
    );
  }
}

class TableSectorWrap extends StatelessWidget {
  const TableSectorWrap({
    Key? key,
    required this.tableSector,
    required this.caaTable,
  }) : super(key: key);

  final TableSector tableSector;
  final CaaTable caaTable;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Wrap(
          spacing: 3.0,
          runSpacing: 4.0,
          // padding: const EdgeInsets.all(8),
          children: List.generate(
            tableSector.imageList.length,
            (index) => VocecaaPictogram(
              heightFactor: .18,
              widthFactor: .21,
              fontSizeFactor: .035,
              caaImage: tableSector.imageList[index],
              color: Color(
                tableSector.sectorColor,
              ),
              onTap: () {
                BlocProvider.of<PatientCommunicationCubit>(context)
                    .updateImageBar(
                        Tuple2(
                          tableSector.imageList[index],
                          Color(tableSector.sectorColor),
                        ),
                        caaTable);
              },
            ),
          ),
        ),
      ),
    );
  }
}
