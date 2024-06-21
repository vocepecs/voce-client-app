import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/table_panel_cubit.dart';
import 'package:voce/models/enums/table_scope.dart';
import 'package:voce/screens/table_screens/ui_components/table_division_panel.dart';
import 'package:voce/widgets/tables/vocecaa_table.dart';
import 'package:voce/widgets/vocecaa_color_picker.dart';
import 'package:voce/widgets/vocecca_card.dart';

class PageTableFormat extends StatefulWidget {
  const PageTableFormat({
    Key? key,
  }) : super(key: key);

  @override
  State<PageTableFormat> createState() => _PageTableFormatState();
}

class _PageTableFormatState extends State<PageTableFormat> {
  Widget _buildLandscapeLayout() {
    TablePanelCubit cubit = BlocProvider.of(context);
    Size media = MediaQuery.of(context).size;
    return BlocBuilder<TablePanelCubit, TablePanelState>(
      builder: (context, state) {
        if (state is TablePanelInitial) {
          return Center(child: CircularProgressIndicator());
        } else if (state is TablePanelLoaded) {
          print(state.caaTable.sectorList.length);
          return DefaultTabController(
            length: state.caaTable.sectorList.length,
            child: Row(
                mainAxisAlignment: cubit.isUserTableOwner()
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        height: double.maxFinite,
                        child: Center(
                          child: VocecaaTable(state.caaTable.tableFormat).build(
                            context: context,
                            caaTable: state.caaTable,
                            scope: TableScope.FORMAT,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (cubit.isUserTableOwner())
                    Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: _buildFormatPanel(),
                        )),
                ]),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildPortraitLatyout() {
    TablePanelCubit cubit = BlocProvider.of(context);
    Size media = MediaQuery.of(context).size;

    return DefaultTabController(
      length: cubit.caaTable!.sectorList.length,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
              children: <Widget>[
                    Center(
                      child: VocecaaCard(
                        child: SizedBox(
                          width: media.width * .9,
                          height: media.width < 600
                              ? media.height * .31
                              : media.height * .4,
                          child:
                              VocecaaTable(cubit.caaTable!.tableFormat).build(
                            context: context,
                            caaTable: cubit.caaTable!,
                            scope: TableScope.FORMAT,
                          ),
                        ),
                      ),
                    )
                  ] +
                  (() {
                    return !cubit.isUserTableOwner()
                        ? <Widget>[]
                        : [
                            SizedBox(height: media.height * .01),
                            Center(
                              child: SizedBox(
                                width: media.width * .9,
                                child: Text(
                                  'Divisioni tabella',
                                  style: GoogleFonts.poppins(
                                    fontSize: media.height * .018,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: media.height * .01),
                            Center(
                              child: SizedBox(
                                width: media.width * .9,
                                height: media.width < 600
                                    ? media.height * .07
                                    : media.height * .12,
                                child: TableDivisionPanel(
                                  caaTable: cubit.caaTable!,
                                ),
                              ),
                            ),
                            SizedBox(height: media.height * .01),
                            Center(
                              child: SizedBox(
                                width: media.width * .9,
                                child: Text(
                                  'Colori settore',
                                  style: GoogleFonts.poppins(
                                    fontSize: media.height * .018,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: media.height * .01),
                            TabBar(
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicatorColor: Theme.of(context).primaryColor,
                              indicatorWeight: 3,
                              labelPadding: EdgeInsets.only(bottom: 10),
                              labelStyle: GoogleFonts.poppins(),
                              tabs: cubit.caaTable!.getTableTabBar(),
                            ),
                            if (media.width >= 600)
                              SizedBox(height: media.height * .01),
                            SizedBox(
                              width: media.width < 600
                                  ? media.width * .9
                                  : media.width * .6,
                              height: media.height * .17,
                              child: TabBarView(
                                physics: NeverScrollableScrollPhysics(),
                                children: List.generate(
                                  cubit.caaTable!.sectorList.length,
                                  (index) => VocecaaColorPicker(
                                    onColorChange: (Color colorSelected) {
                                      var cubit =
                                          BlocProvider.of<TablePanelCubit>(
                                              context);
                                      cubit.updateSectorColor(
                                          index, colorSelected.value);
                                      // bloc.updateTable(snapshot.data!);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ];
                  }())),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    var cubit = BlocProvider.of<TablePanelCubit>(context);
    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.landscape
            ? _buildLandscapeLayout()
            : _buildPortraitLatyout();
      },
    );
  }

  Widget _buildFormatPanel() {
    TablePanelCubit cubit = BlocProvider.of(context);
    Size media = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(height: media.height * .02),
        Text('Divisioni tabella',
            style: GoogleFonts.poppins(
              fontSize: media.width * .013,
              fontWeight: FontWeight.bold,
            )),
        Center(
          child: SizedBox(
            height: media.height * .25,
            child: TableDivisionPanel(
              caaTable: cubit.caaTable!,
            ),
          ),
        ),
        SizedBox(height: media.height * .02),
        Text(
          'Seleziona i colori',
          style: GoogleFonts.poppins(
            fontSize: media.width * .013,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: media.height * .01),
        TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: Theme.of(context).primaryColor,
          indicatorWeight: 3,
          labelPadding: EdgeInsets.only(bottom: 10),
          labelStyle: GoogleFonts.poppins(),
          tabs: cubit.caaTable!.getTableTabBar(),
        ),
        SizedBox(
          width: media.width * .24,
          height: media.height * .3,
          child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: List.generate(
              cubit.caaTable!.sectorList.length,
              (index) => VocecaaColorPicker(
                onColorChange: (Color colorSelected) {
                  var cubit = BlocProvider.of<TablePanelCubit>(context);
                  cubit.updateSectorColor(index, colorSelected.value);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
