import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';
import 'package:voce/cubit/table_panel_cubit.dart';
import 'package:voce/models/enums/table_format.dart';
import 'package:voce/models/image.dart';
import 'package:voce/models/table_sector.dart';
import 'package:voce/widgets/mbs/mb_yes_or_no.dart';
import 'package:voce/widgets/vocecaa_pictogram.dart';

class ReordableTableSector extends StatefulWidget {
  const ReordableTableSector({
    Key? key,
    required this.imageList,
    required this.tableSector,
    required this.tableFormat,
    required this.sectorIndex,
  }) : super(key: key);

  final List<CaaImage> imageList;
  final TableFormat tableFormat;
  final TableSector tableSector;
  final int sectorIndex;

  @override
  State<ReordableTableSector> createState() => _ReordableTableSectorState();
}

class _ReordableTableSectorState extends State<ReordableTableSector> {
  late TablePanelCubit cubit;
  final _scrollController = ScrollController();
  final _gridViewKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of(context);
  }

  int _getCrossAxisCount() {
    Size media = MediaQuery.of(context).size;
    if (widget.tableFormat == TableFormat.SINGLE_SECTOR ||
        widget.tableFormat == TableFormat.TWO_SECTORS_HORIZONTAL) {
      return 4;
    } else if (widget.tableFormat == TableFormat.TWO_SECTORS_VERTICAL ||
        widget.tableFormat == TableFormat.FOUR_SECTORS) {
      return media.width < 600 ? 2 : 3;
    } else {
      if (media.width < 600) {
        return widget.sectorIndex == 0 || widget.sectorIndex == 1 ? 1 : 3;
      } else {
        return widget.sectorIndex == 0 || widget.sectorIndex == 1
            ? 1
            : Platform.isAndroid
                ? 4
                : 3;
      }
    }
  }

  Axis _getScrollAxis() {
    Size media = MediaQuery.of(context).size;

    // if (media.width >= 600) {
    //   return Axis.vertical;
    // }

    if (widget.tableFormat == TableFormat.THREE_SECTORS_LEFT) {
      return widget.sectorIndex == 1 ? Axis.horizontal : Axis.vertical;
    } else if (widget.tableFormat == TableFormat.THREE_SECTORS_RIGHT) {
      return widget.sectorIndex == 0 ? Axis.horizontal : Axis.vertical;
    } else {
      return Axis.vertical;
    }
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.orientationOf(context);

    List<Widget> children = List.generate(
      widget.imageList.length,
      (index) => VocecaaPictogram(
        key: Key(widget.imageList[index].label + "$index"),
        widthFactor: .3,
        heightFactor: .2,
        fontSizeFactor: orientation == Orientation.portrait ? .035 : .018,
        caaImage: widget.imageList[index],
        color: Color(widget.tableSector.sectorColor),
        onTap: () {
          if (cubit.isUserTableOwner()) {
            showModalBottomSheet(
              context: context,
              builder: (context) => MbYesOrNo(
                title:
                    'Confermi di voler elimnare il pittogramma dalla tabella ?',
              ),
              backgroundColor: Colors.black.withOpacity(0),
              isScrollControlled: true,
            ).then((value) {
              if (value == true) {
                cubit.removeSectorImage(widget.sectorIndex, index);
              }
            });
          }
        },
      ),
    );

    return ReorderableBuilder(
      children: children,
      builder: (children) => GridView(
        key: _gridViewKey,
        controller: _scrollController,
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _getCrossAxisCount(), // Numero di colonne
            mainAxisSpacing: 5.0, // Spazio verticale tra le righe
            crossAxisSpacing: 5.0,
            childAspectRatio: 1 // Spazio orizzontale tra le colonne
            ),
        scrollDirection: _getScrollAxis(),
        children: children,
      ),
      onReorder: (List<OrderUpdateEntity> orderUpdateEntities) {
        for (final orderUpdateEntity in orderUpdateEntities) {
          cubit.updateSectorImagePosition(
            widget.sectorIndex,
            orderUpdateEntity.oldIndex,
            orderUpdateEntity.newIndex,
          );
        }
      },
    );
  }
}
