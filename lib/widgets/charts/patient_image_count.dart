import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/dash_patient_image_count_cubit.dart';
import 'package:voce/widgets/charts/chart_utils.dart';
import 'package:voce/widgets/date_input_widget.dart';
import 'package:voce/widgets/text_button_widget.dart';

class BarChartPatientImageCount extends StatefulWidget {
  BarChartPatientImageCount({key});

  final List<Color> colorList = const [
    AppColors.contentColorBlue,
    AppColors.contentColorYellow,
    AppColors.contentColorOrange,
    AppColors.contentColorGreen,
    AppColors.contentColorPurple,
    AppColors.contentColorPink,
    AppColors.contentColorRed,
    AppColors.contentColorCyan,
    AppColors.contentColorGray,
    AppColors.contentColorBrow,
  ];

  @override
  State<StatefulWidget> createState() => BarChartPatientImageCountState();
}

class BarChartPatientImageCountState extends State<BarChartPatientImageCount> {
  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  late DashPatientImageCountCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of(context);
  }

  void _generateHistData(List<Map<String, dynamic>> data) {
    final items = List.generate(data.length, (index) {
      if (cubit.chartTypePictograms) {
        return makeChartRodData(
          data[index]["image_id"],
          data[index]["count"],
          index,
        );
      } else {
        return makeChartRodData(
          data[index]["context_id"],
          data[index]["count_distinct"],
          index,
        );
      }
    });

    rawBarGroups = items;
    showingBarGroups = rawBarGroups;
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 12);
    String text;

    if (cubit.chartTypePictograms) {
      Map<String, dynamic> image = cubit.data.firstWhere(
        (element) => element["image_id"] == value,
      );
      text = image["label"];
    } else {
      Map<String, dynamic> context = cubit.data.firstWhere(
        (element) => element["context_id"] == value,
      );
      text = context["type"];
    }

    return Transform.rotate(
      angle: pi / 4,
      child: SideTitleWidget(
        axisSide: meta.axisSide,
        space: 12,
        fitInside: SideTitleFitInsideData(
          enabled: true,
          axisPosition: -1,
          parentAxisSize: 0,
          distanceFromEdge: -20,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AutoSizeText(
              text,
              maxLines: 2,
              style: style,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value == meta.max) {
      return Container();
    }
    const style = TextStyle(
      fontSize: 12,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        meta.formattedValue,
        style: style,
      ),
    );
  }

  double getMaxY(List<Map<String, dynamic>> data) {
    int maxCount = 0;
    String key = cubit.chartTypePictograms ? "count" : "count_distinct";
    data.forEach((element) {
      if (element[key] > maxCount) {
        maxCount = element[key];
      }
    });
    return maxCount.toDouble();
  }

  void barTouchEvent(BarTouchResponse response) {
    if (response.spot != null) {
      int touchedBarIndex = (response.spot!.props[1] as int);
      cubit.contextImageFocus(touchedBarIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.66,
      child: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Column(
            children: [
              BlocBuilder<DashPatientImageCountCubit,
                  DashPatientImageCountState>(
                builder: (context, state) {
                  if (state is DashPatientImageCountLoaded ||
                      state is DashPatientImageCountNotEnoughtData) {
                    return Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          cubit.chartTypePictograms
                              ? "Pittogrammi più usati"
                              : "Contesti più usati",
                          style: GoogleFonts.poppins(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        TextButtonWidget(
                          text: cubit.chartTypePictograms
                              ? "Contesti"
                              : "Pittogrammi",
                          icon: cubit.chartTypePictograms
                              ? Icons.topic
                              : Icons.image_outlined,
                          onPressed: () {
                            cubit.updateChartType(!cubit.chartTypePictograms);
                          },
                        )
                      ],
                    );
                  } else if (state is DashPatientImageCountFocusContext) {
                    return Row(
                      children: [
                        IconButton(
                          onPressed: () =>
                              cubit.getPatientImageAndContextStats(),
                          icon: Icon(Icons.arrow_back_outlined),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Focus immagini per contesto\n",
                                style: GoogleFonts.poppins(
                                  color: Colors.black87,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: state.context,
                                style: GoogleFonts.poppins(
                                  color: Colors.black87,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
              BlocBuilder<DashPatientImageCountCubit,
                  DashPatientImageCountState>(
                builder: (context, state) {
                  if (state is DashPatientImageCountLoaded ||
                      state is DashPatientImageCountNotEnoughtData) {
                    return Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Container(
                            height: 45,
                            child: DateInputWidget(
                              label: "Data inizio",
                              onChanged: (value) {
                                cubit.updateStartDate(value!);
                              },
                              initialValue:
                                  "${cubit.starteDate.day}/${cubit.starteDate.month}/${cubit.starteDate.year}",
                            ),
                          ),
                        ),
                        Spacer(),
                        Expanded(
                          flex: 10,
                          child: Container(
                            height: 45,
                            child: DateInputWidget(
                              label: "Data fine",
                              onChanged: (value) {
                                cubit.updateEndDate(value!);
                              },
                              initialValue:
                                  "${cubit.endDate.day}/${cubit.endDate.month}/${cubit.endDate.year}",
                            ),
                          ),
                        ),
                        Spacer(flex: 11),
                      ],
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
              SizedBox(height: 10),
              Expanded(
                child: BlocBuilder<DashPatientImageCountCubit,
                    DashPatientImageCountState>(
                  builder: (context, state) {
                    if (state is DashPatientImageCountLoaded) {
                      _generateHistData(state.data);
                      return BarChart(
                        BarChartData(
                          barTouchData: !cubit.chartTypePictograms
                              ? BarTouchData(
                                  enabled: true,
                                  touchCallback: (event, response) {
                                    if (event is FlTapUpEvent) {
                                      if (response != null &&
                                          response.spot != null) {
                                        barTouchEvent(response);
                                      }
                                    }
                                  },
                                )
                              : null,
                          maxY: getMaxY(state.data) + 1,
                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                                getTitlesWidget: bottomTitles,
                                reservedSize: 60,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 28,
                                interval: 2,
                                getTitlesWidget: leftTitles,
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: showingBarGroups,
                          gridData: FlGridData(show: false),
                        ),
                      );
                    } else if (state is DashPatientImageCountFocusContext) {
                      return PieChart(
                        PieChartData(
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                          sections: generateSections(state.imageList),
                        ),
                      );
                    } else if (state is DashPatientImageCountNotEnoughtData) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 40,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Non ci sono dati a sufficienza per calcolare le statistiche nel periodo selezionato",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              SizedBox(height: 15),
              BlocBuilder<DashPatientImageCountCubit,
                  DashPatientImageCountState>(
                builder: (context, state) {
                  if (state is DashPatientImageCountFocusContext) {
                    return LegendsListWidget(
                        legends: createLegend(state.imageList));
                  } else if (state is DashPatientImageCountLoaded) {
                    return LegendsListWidget(
                        legends: createBarChartLegend(state.data));
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ],
          )),
    );
  }

  BarChartGroupData makeChartRodData(int x, int y, int index) {
    return BarChartGroupData(
      barsSpace: 6,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y.toDouble(),
          color: AppColors.colorList_1[index],
          width: 20,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        )
      ],
    );
  }

  List<PieChartSectionData> generateSections(List<Map<String, dynamic>> data) {
    List<PieChartSectionData> sectionList = List.empty(growable: true);
    const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

    int total = 0;
    data.forEach((element) {
      total += element["count"] as int;
    });

    for (var i = 0; i < data.length; i++) {
      sectionList.add(
        PieChartSectionData(
          color: AppColors.colorList_1[i],
          value: double.parse(
              ((data[i]["count"] / total) * 100 as double).toStringAsFixed(1)),
          title:
              '${((data[i]["count"] / total) * 100 as double).toStringAsFixed(1)} % ',
          radius: 50.0,
          titleStyle: GoogleFonts.poppins(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            color: AppColors.mainTextColor1,
            shadows: shadows,
          ),
        ),
      );
    }

    return sectionList;
  }

  List<Legend> createLegend(List<Map<String, dynamic>> data) {
    List<Legend> legendList = List.empty(growable: true);
    for (var i = 0; i < data.length; i++) {
      legendList.add(Legend(data[i]["label"], AppColors.colorList_1[i]));
    }
    return legendList;
  }

  List<Legend> createBarChartLegend(List<Map<String, dynamic>> data) {
    List<Legend> legendList = List.empty(growable: true);
    for (var i = 0; i < data.length; i++) {
      if (cubit.chartTypePictograms) {
        legendList.add(Legend(data[i]["label"], AppColors.colorList_1[i]));
      } else {
        legendList.add(Legend(data[i]["type"], AppColors.colorList_1[i]));
      }
    }
    return legendList;
  }
}
