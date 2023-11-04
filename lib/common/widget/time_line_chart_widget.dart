import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/line_chart_widget.dart';
import 'package:cozy_for_mom_frontend/common/widget/tab_indicator_widget.dart';
import 'package:flutter/material.dart';

enum TimeType { daily, weekly, monthly }

enum RecordType {
  weight("kg"),
  bloodsugar("mg/dL");

  final String unit;
  const RecordType(this.unit);
}

class TimeLineChart extends StatefulWidget {
  final RecordType recordType;
  final List<LineChartData> dataList;
  final TimeType timeType;
  const TimeLineChart({
    super.key,
    required this.recordType,
    required this.dataList,
    this.timeType = TimeType.daily,
  });

  @override
  State<TimeLineChart> createState() => _TimeLineChartState();
}

class _TimeLineChartState extends State<TimeLineChart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            _tabBar(),
            Expanded(
              child: _tabBarView(widget),
            )
          ],
        ),
      ),
    );
  }
}

Widget _tabBar() {
  return TabBar(
      labelColor: Colors.black,
      indicatorColor: Colors.red,
      labelStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 16,
      ),
      tabs: const [
        Tab(text: "일간"),
        Tab(text: "주간"),
        Tab(text: "월간"),
      ],
      indicatorSize: TabBarIndicatorSize.label,
      indicator: CustomTabIndicator(color: primaryColor)
      // indicator: BoxDecoration(
      //   borderRadius: BorderRadius.only(
      //     topLeft: Radius.circular(10),
      //     topRight: Radius.circular(10),
      //   ),
      //   color: Colors.white,
      // ),
      );
}

Widget _tabBarView(TimeLineChart widget) {
  return TabBarView(
    children: [
      LineChart(
        dataList: widget.dataList,
        baseValue: widget.dataList[0].yValue,
        unit: widget.recordType.unit,
      ),
      LineChart(
        dataList: widget.dataList,
        baseValue: widget.dataList[0].yValue,
        unit: widget.recordType.unit,
      ),
      LineChart(
        dataList: widget.dataList,
        baseValue: widget.dataList[0].yValue,
        unit: widget.recordType.unit,
      ),
    ],
  );
}

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: TimeLineChart(
          recordType: RecordType.bloodsugar,
          dataList: [
            LineChartData("05.11", 45),
            LineChartData("05.12", 47),
            LineChartData("05.13", 47),
            LineChartData("05.15", 50),
          ],
        ),
      ),
    );
  }
}
