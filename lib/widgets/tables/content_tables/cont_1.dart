import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';
import 'package:voce/cubit/table_panel_cubit.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/table_sector.dart';
import 'package:voce/widgets/mbs/mb_yes_or_no.dart';
import 'package:voce/widgets/vocecaa_pictogram.dart';

class ConT1 extends StatefulWidget {
  const ConT1({
    Key? key,
    required this.caaTable,
  }) : super(key: key);

  final CaaTable caaTable;

  @override
  State<ConT1> createState() => _ConT1State();
}

class _ConT1State extends State<ConT1> {
  final _scrollController = ScrollController();
  final _gridViewKey = GlobalKey();

  late TablePanelCubit cubit;

  @override
  void initState(){
    super.initState();
    cubit = BlocProvider.of<TablePanelCubit>(context);
  }

 List<Widget> getChildrens() {
  Orientation orientation = MediaQuery.orientationOf(context);
  TableSector ts = widget.caaTable.sectorList[0];
  return List.generate(
      widget.caaTable.sectorList.first.imageList.length,
      (index) => VocecaaPictogram(
        key: Key(ts.imageList[index].label + "$index"),
        widthFactor: .5,
        heightFactor: .4,
        fontSizeFactor: orientation == Orientation.portrait ? .035 : .018,
        caaImage: ts.imageList[index],
        color: Color(ts.sectorColor),
        onTap: () {
          if (cubit.isUserTableOwner()) {
            showModalBottomSheet(
              context: context,
              builder: (context) => MbYesOrNo(
                title:
                    "Confermi di voler eliminare il pittogramma dalla tabella ?",
              ),
              backgroundColor: Colors.black.withOpacity(0),
              isScrollControlled: true,
            ).then((value) {
              if (value == true) {
                cubit.removeSectorImage(0, index);
              }
            });
          }
        },
      ),
    );
 }


  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    
    Orientation orientation = MediaQuery.orientationOf(context);
    TableSector ts = widget.caaTable.sectorList[0];

    final generateChildren = List.generate(
      widget.caaTable.sectorList.first.imageList.length,
      (index) => VocecaaPictogram(
        key: Key(ts.imageList[index].label + "$index"),
        widthFactor: .5,
        heightFactor: .4,
        fontSizeFactor: orientation == Orientation.portrait ? .035 : .018,
        caaImage: ts.imageList[index],
        color: Color(ts.sectorColor),
        onTap: () {
          if (cubit.isUserTableOwner()) {
            showModalBottomSheet(
              context: context,
              builder: (context) => MbYesOrNo(
                title:
                    "Confermi di voler eliminare il pittogramma dalla tabella ?",
              ),
              backgroundColor: Colors.black.withOpacity(0),
              isScrollControlled: true,
            ).then((value) {
              if (value == true) {
                cubit.removeSectorImage(0, index);
              }
            });
          }
        },
      ),
    );

    return SizedBox(
      height: orientation == Orientation.portrait
          ? media.height * .35
          : media.height * .8,
      width: orientation == Orientation.portrait
          ? media.width * .9
          : media.width * .6,
      // child: Container(),
      child: ReorderableBuilder(
        children: getChildrens(),
        scrollController: _scrollController,
        
        onReorder: (List<OrderUpdateEntity> orderUpdateEntities) {
          for (final orderUpdateEntity in orderUpdateEntities) {
            cubit.updateSectorImagePosition(
              0,
              orderUpdateEntity.oldIndex,
              orderUpdateEntity.newIndex,
            );
          }
        },

        builder: (children) => GridView(
          key: _gridViewKey,
          controller: _scrollController,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: media.width < 600 ? 4 : 4, // Numero di colonne
            mainAxisSpacing: 5.0, // Spazio verticale tra le righe
            crossAxisSpacing: 5.0,
            childAspectRatio: 1, // Spazio orizzontale tra le colonne
          ),
          children: children,
          // itemCount: ts.imageList.length,
          // itemBuilder: (context, index) => VocecaaPictogram(
          //   key: Key(ts.imageList[index].label + "$index"),
          //   widthFactor: .5,
          //   heightFactor: .4,
          //   fontSizeFactor: orientation == Orientation.portrait ? .035 : .018,
          //   caaImage: ts.imageList[index],
          //   color: Color(ts.sectorColor),
          //   onTap: () {
          //     if (cubit.isUserTableOwner()) {
          //       showModalBottomSheet(
          //         context: context,
          //         builder: (context) => MbYesOrNo(
          //           title:
          //               "Confermi di voler eliminare il pittogramma dalla tabella ?",
          //         ),
          //         backgroundColor: Colors.black.withOpacity(0),
          //         isScrollControlled: true,
          //       ).then((value) {
          //         if (value == true) {
          //           cubit.removeSectorImage(0, index);
          //         }
          //       });
          //     }
          //   },
          // ),
        ),
      ),
    );
  }
}
