import 'package:smart_admin_dashboard/core/constants/color_constants.dart';
import 'package:smart_admin_dashboard/models/daily_info_model.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smart_admin_dashboard/screens/Pages/ChooseParkingSlotScreen.dart';
import 'package:smart_admin_dashboard/screens/Pages/MonthRes.dart';
import 'package:smart_admin_dashboard/screens/Pages/TotalPrices.dart';
import 'package:smart_admin_dashboard/screens/Pages/Weekly.dart';
import 'package:smart_admin_dashboard/screens/Pages/totalReservations.dart';
import 'package:smart_admin_dashboard/screens/Pages/totalSubs.dart';

import 'CountSpots.dart';

class MiniInformationWidget extends StatefulWidget {
  const MiniInformationWidget({
    Key? key,
    required this.dailyData,
  }) : super(key: key);
  final DailyInfoModel dailyData;

  @override
  _MiniInformationWidgetState createState() => _MiniInformationWidgetState();
}

int _value = 1;

class _MiniInformationWidgetState extends State<MiniInformationWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [


          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(defaultPadding * 0.75),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: widget.dailyData.color!.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Icon(
                  widget.dailyData.icon,
                  color: widget.dailyData.color,
                  size: 18,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 0.0),
                child: DropdownButton(
                  icon: Icon(Icons.more_vert, size: 18),
                  underline: SizedBox(),
                  style: Theme.of(context).textTheme.button,
                  value: _value,
                  items: [
                    DropdownMenuItem(
                      child: Text("This week"),
                      value: 1,
                    ),

                    DropdownMenuItem(
                      child: Text("This month"),
                      value: 2,
                    ),
                    DropdownMenuItem(
                      child: Text("Total"),

                      value: 3,
                    ),

                  ],
                  onChanged: (int? value) {
                    setState(() {
                      _value = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [


              Text(
                widget.dailyData.title!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                child: LineChartWidget(
                  colors: widget.dailyData.colors,
                  spotsData: widget.dailyData.spots,
                ),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),


          ProgressLine(
            color: widget.dailyData.color!,
            percentage: 2,
          ),
          if (widget.dailyData.title =="Total Reservations" && _value ==3 ) totalReservations(),
          if (widget.dailyData.title =="Total Reservations" && _value ==2 ) MonthlyRes(),
          if (widget.dailyData.title =="Total Reservations" && _value ==1 ) weekly(),
          if  (widget.dailyData.title =="Total Subscribers" && (_value ==3 || _value ==2 || _value ==1 ) ) totalSubs(),
          if (widget.dailyData.title =="Total income" && (_value ==3 || _value ==2 || _value ==1 )  ) total_income(),
          if (widget.dailyData.title =="Occupied Spots"  ) Bird1(),




        ],
      ),

    );
  }
}

class LineChartWidget extends StatelessWidget {
  const LineChartWidget({
    Key? key,
    required this.colors,
    required this.spotsData,
  }) : super(key: key);
  final List<Color>? colors;
  final List<FlSpot>? spotsData;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 30,
          child: LineChart(
            LineChartData(
                lineBarsData: [
                  LineChartBarData(
                      spots: spotsData,
                      belowBarData: BarAreaData(show: false),
                      aboveBarData: BarAreaData(show: false),
                      isCurved: true,
                      dotData: FlDotData(show: false),
                      colors: colors,
                      barWidth: 3),
                ],
                lineTouchData: LineTouchData(enabled: false),
                titlesData: FlTitlesData(show: false),
                axisTitleData: FlAxisTitleData(show: false),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false)),
          ),
        ),
      ],
    );
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = primaryColor,
    required this.percentage,
  }) : super(key: key);

  final Color color;
  final int percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage / 100),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}




