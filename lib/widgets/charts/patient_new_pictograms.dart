import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/dash_patient_new_pictograms_cubit.dart';
import 'package:voce/widgets/charts/chart_utils.dart';
import 'package:voce/widgets/date_input_widget.dart';
import 'package:voce/widgets/radio_button_widget.dart';

class StackedPatientNewPictograms extends StatefulWidget {
  const StackedPatientNewPictograms({Key? key}) : super(key: key);

  @override
  State<StackedPatientNewPictograms> createState() =>
      _StackedPatientNewPictogramsState();
}

class _StackedPatientNewPictogramsState
    extends State<StackedPatientNewPictograms> {
  late DashPatientNewPictogramsCubit cubit;
  final betweenSpace = .2;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of(context);
  }

  BarChartGroupData generateGroupData(
    int x,
    double oldPictograms,
    double newPictograms,
  ) {
    return BarChartGroupData(
      x: x,
      groupVertically: true,
      barRods: [
        BarChartRodData(
            fromY: 0,
            toY: oldPictograms,
            color: AppColors.contentColorBlue,
            width: 15,
            borderRadius: BorderRadius.all(Radius.circular(2))),
        BarChartRodData(
          fromY: oldPictograms + betweenSpace,
          toY: oldPictograms + betweenSpace + newPictograms,
          color: AppColors.contentColorOrange,
          width: 15,
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
      ],
    );
  }

  List<BarChartGroupData> generateStackedData(
    List<Map<String, dynamic>> data,
    bool weekView,
  ) {
    List<BarChartGroupData> listGroupData = List.empty(growable: true);

    double oldPictograms = 0;
    double newPictograms = 0;

    data.forEach((element) {
      oldPictograms = (element["n_pictograms_already_used"] as int).toDouble();
      newPictograms = (element["n_pictograms_new"] as int).toDouble();

      String strDate = element["date_start_interval"];
      String strEndDate = element["date_end_interval"];

      int xValue = 0;
      if (weekView) {
        String strXValue = strDate.split("/")[0] +
            strDate.split("/")[1] +
            strEndDate.split("/")[0] +
            strEndDate.split("/")[1];

        xValue = int.parse(strXValue);
      } else {
        xValue = DateTime(
          int.parse(strDate.split("/")[2]),
          int.parse(strDate.split("/")[1]),
          int.parse(strDate.split("/")[0]),
        ).month;
      }

      listGroupData.add(generateGroupData(
        xValue,
        oldPictograms,
        newPictograms,
      ));
    });
    return listGroupData;
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    String text;
    switch (value.toInt()) {
      case 1:
        text = 'GEN';
        break;
      case 2:
        text = 'FEB';
        break;
      case 3:
        text = 'MAR';
        break;
      case 4:
        text = 'APR';
        break;
      case 5:
        text = 'MAG';
        break;
      case 6:
        text = 'GIU';
        break;
      case 7:
        text = 'LUG';
        break;
      case 8:
        text = 'AGO';
        break;
      case 9:
        text = 'SET';
        break;
      case 10:
        text = 'OTT';
        break;
      case 11:
        text = 'NOV';
        break;
      case 12:
        text = 'DIC';
        break;
      default:
        String strValue = value.truncate().toString();
        if (strValue.length < 8) {
          strValue = "0" + strValue;
        }
        String startDay = strValue.substring(0, 2);
        String startMonth = strValue.substring(2, 4);
        String endDay = strValue.substring(4, 6);
        String endMonth = strValue.substring(6);

        text = "$startDay/$startMonth\n$endDay/$endMonth";
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value == meta.max) {
      return Container();
    }
    const style = TextStyle(
      fontSize: 10,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Text(
          meta.formattedValue,
          style: style,
        ),
      ),
    );
  }

  double getMaxY(List<Map<String, dynamic>> data) {
    double maxCount = 0;
    data.forEach((element) {
      if ((element["n_pictograms_new"] + element["n_pictograms_already_used"]
                  as int)
              .toDouble() >
          maxCount) {
        maxCount = (element["n_pictograms_new"] +
                element["n_pictograms_already_used"] as int)
            .toDouble();
      }
    });
    print(maxCount);
    return maxCount.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon(
              //   Icons.replay_outlined,
              //   color: Colors.black87,
              // ),
              // SizedBox(width: 5),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: 'Nuovi pittogrammi usati',
                    style: GoogleFonts.poppins(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
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
                        "${cubit.startDate.day}/${cubit.startDate.month}/${cubit.startDate.year}",
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
              Spacer(),
              Expanded(
                flex: 12,
                child: Container(
                  height: 45,
                  child: RadioButtonWidget(onChanged: (value) {
                    cubit.updateWeekView(value);
                  }),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: BlocBuilder<DashPatientNewPictogramsCubit,
                DashPatientNewPictogramsState>(
              builder: (context, state) {
                if (state is DashPatientNewPictogramsLoaded) {
                  return BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceBetween,
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: leftTitles,
                              reservedSize: 38,
                              interval: 5),
                        ),
                        rightTitles: AxisTitles(),
                        topTitles: AxisTitles(),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: bottomTitles,
                            reservedSize: 30,
                          ),
                        ),
                      ),
                      barTouchData: BarTouchData(enabled: false),
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(show: false),
                      barGroups:
                          generateStackedData(state.data, cubit.weekView),
                      maxY: getMaxY(state.data) + 7,
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          SizedBox(height: 10),
          LegendsListWidget(
            legends: [
              Legend('Già utilizzati', AppColors.contentColorBlue),
              Legend('Nuovi', AppColors.contentColorOrange),
            ],
          ),
        ],
      ),
    );
  }
}
