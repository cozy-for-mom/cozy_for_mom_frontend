import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

const Color activeColor = Color(0xff5CA6F8);
const Color defaultColor = Color(0xffBADBFF);
const Color thickLineColor = Color(0xffCDCED5);
const Color defaultLineColor = Color(0xffF0F0F5);

class LineChart extends StatefulWidget {
  const LineChart(
      {super.key,
      required this.dataList,
      required this.baseValue,
      required this.unit,
      required this.timeType});

  final List<LineChartData> dataList;
  final double baseValue;
  final String unit;
  final String timeType;

  @override
  State<LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enablePanning: true,
    );
    super.initState();
  }

  findMonday(DateTime date) {
    // `date.weekday`: 1(월요일)부터 7(일요일)까지의 값
    // 월요일로부터 몇 일 떨어져 있는지 계산
    int daysFromMonday = date.weekday - DateTime.monday;

    // 계산된 일수를 현재 날짜에서 빼서 해당 주의 월요일을 구한다.
    DateTime monday = date.subtract(Duration(days: daysFromMonday));
    return monday;
  }

  DateTime findSunday(DateTime date) {
    DateTime sunday = date.add(const Duration(days: 7));
    return sunday;
  }

  String dateToString(DateTime date) {
    return DateFormat('MM.dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      zoomPanBehavior: _zoomPanBehavior,
      backgroundColor: Colors.white,
      series: <ChartSeries>[
        LineSeries<LineChartData, String>(
          dataSource: widget.dataList.reversed.toList(),
          xValueMapper: (LineChartData data, _) => widget.timeType == 'daily'
              ? dateToString(data.xValue)
              : widget.timeType == 'weekly'
                  ? '${dateToString(data.xValue).substring(0, 3)}${DateFormat('dd').format(findMonday(data.xValue))} - ${DateFormat('dd').format(findSunday(findMonday(data.xValue)))}'
                  : '${dateToString(data.xValue)[1]}월',
          yValueMapper: (LineChartData data, _) => data.yValue,
          color: defaultColor,
          width: AppUtils.scaleSize(context, 3),
          markerSettings: const MarkerSettings(
            isVisible: true,
            shape: DataMarkerType.circle,
            color: Colors.white,
            borderColor: defaultColor,
            borderWidth: 2,
          ),
        ),
      ],
      tooltipBehavior: TooltipBehavior(
        color: const Color(0xff5CA6F8), // 툴팁 배경색 설정
        duration: 5000,
        enable: true,
        builder: (
          dynamic data,
          dynamic point,
          dynamic series,
          int pointIndex,
          int seriesIndex,
        ) {
          return Container(
            padding: EdgeInsets.all(AppUtils.scaleSize(context, 10)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.black.withOpacity(0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${data.yValue} ',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  widget.unit,
                  style: const TextStyle(
                    color: Color(0xffBADBFF),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      primaryXAxis: CategoryAxis(
        autoScrollingDelta: 4,
        autoScrollingMode: AutoScrollingMode.end,
        majorGridLines: const MajorGridLines(
          width: 0,
        ),
        majorTickLines: const MajorTickLines(
          // 짧은 눈금선 제거
          width: 0,
        ),
        minorGridLines: const MinorGridLines(
          width: 0,
        ),
        axisLine: AxisLine(
          color: thickLineColor,
          width: AppUtils.scaleSize(context, 1.7),
        ),
        labelStyle: TextStyle(
          color: Colors.black.withOpacity(0.5),
        ),
      ),
      primaryYAxis: NumericAxis(
        interval: 10,
        axisLine: const AxisLine(width: 1, color: Colors.white),
        majorTickLines: const MajorTickLines(width: 0), // 제거
        opposedPosition: true,
        maximumLabels: 4,
        minorTicksPerInterval: 1,
        tickPosition: TickPosition.inside,
        majorGridLines: MajorGridLines(
          width: AppUtils.scaleSize(context, 1.7),
          color: thickLineColor,
        ),
        minorGridLines: const MinorGridLines(
          width: 1,
        ),
        minimum: widget.unit == "kg"
            ? ((widget.baseValue - 10) / 10).roundToDouble() * 10
            : ((widget.baseValue - 15) / 10).roundToDouble() * 10,
      ),
    );
  }
}

class LineChartData {
  final DateTime xValue;
  final double yValue;

  LineChartData(this.xValue, this.yValue);
}
