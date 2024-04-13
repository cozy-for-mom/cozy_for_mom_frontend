import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

const Color activeColor = Color(0xff5CA6F8);
const Color defaultColor = Color(0xffBADBFF);
const Color thickLineColor = Color(0xffCDCED5);
const Color defaultLineColor = Color(0xffF0F0F5);

class LineChart extends StatefulWidget {
  const LineChart({
    super.key,
    required this.dataList,
    required this.baseValue,
    required this.unit,
  });

  final List<LineChartData> dataList;
  final double baseValue;
  final String unit;

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

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      zoomPanBehavior: _zoomPanBehavior,
      backgroundColor: Colors.white,
      series: <ChartSeries>[
        LineSeries<LineChartData, String>(
          dataSource: widget.dataList.reversed.toList(),
          xValueMapper: (LineChartData data, _) => data.xValue,
          yValueMapper: (LineChartData data, _) => data.yValue,
          color: defaultColor,
          width: 3,
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
            padding: const EdgeInsets.all(10),
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
        axisLine: const AxisLine(
          color: thickLineColor,
          width: 1.7,
        ),
        labelStyle: TextStyle(
          color: Colors.black.withOpacity(0.5),
        ),
      ),
      primaryYAxis: NumericAxis(
        interval: 5,
        axisLine: const AxisLine(width: 1, color: Colors.white),
        majorTickLines: const MajorTickLines(width: 0), // 제거
        opposedPosition: true,
        maximumLabels: 4,
        minorTicksPerInterval: 1,
        tickPosition: TickPosition.inside,
        majorGridLines: const MajorGridLines(
          width: 1.7,
          color: thickLineColor,
        ),
        minorGridLines: const MinorGridLines(
          width: 1,
        ),

        // minimum: widget.baseValue - 20,
        // maximum: widget.baseValue
        // plotBands: <PlotBand>[
        //   PlotBand(
        //     borderColor: thickLineColor,
        //     color: thickLineColor,
        //     isVisible: true,
        //     borderWidth: 1.7,
        //     start: widget.baseValue,
        //     end: widget.baseValue,
        //   ),
        //   PlotBand(
        //     borderColor: thickLineColor,
        //     color: thickLineColor,
        //     isVisible: true,
        //     borderWidth: 2.5,
        //     start: widget.baseValue + 15, // TODO 어떻게 지정해야할지 고민 필요
        //     end: widget.baseValue + 15,
        //   ),
        // ],
      ),
    );
  }
}

class LineChartData {
  final String xValue;
  final double yValue;

  LineChartData(this.xValue, this.yValue);
}
