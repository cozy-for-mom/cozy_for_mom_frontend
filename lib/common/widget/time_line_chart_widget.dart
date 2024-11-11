import 'dart:math';

import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/line_chart_widget.dart';
import 'package:cozy_for_mom_frontend/common/widget/tab_indicator_widget.dart';
import 'package:cozy_for_mom_frontend/model/global_state.dart';
import 'package:cozy_for_mom_frontend/service/mom/mom_bloodsugar_api_service.dart';
import 'package:cozy_for_mom_frontend/service/mom/mom_weight_api_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum RecordType {
  weight("kg"),
  bloodsugar("mg/dL");

  final String unit;
  const RecordType(this.unit);
}

class TimeLineChart extends StatefulWidget {
  final RecordType recordType;
  const TimeLineChart({
    super.key,
    required this.recordType,
  });

  @override
  State<TimeLineChart> createState() => _TimeLineChartState();
}

class _TimeLineChartState extends State<TimeLineChart>
    with SingleTickerProviderStateMixin {
  late BloodsugarApiService bloodsugarPeriodViewModel;
  late WeightApiService weightPeriodViewModel;
  late Map<String, dynamic> data;
  String type = 'daily';
  late List<LineChartData> dataList;
  late List<dynamic> dataPerPeriod;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    type = 'daily';
    _tabController!.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController!.indexIsChanging) {
      setState(() {
        switch (_tabController!.index) {
          case 0:
            type = 'daily';
            break;
          case 1:
            type = 'weekly';
            break;
          case 2:
            type = 'monthly';
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final paddingValue = isTablet ? 30.w : 20.w;
    BloodsugarApiService bloodsugarPeriodViewModel =
        Provider.of<BloodsugarApiService>(context, listen: true);
    WeightApiService weightPeriodViewModel =
        Provider.of<WeightApiService>(context, listen: true);

    return Consumer<MyDataModel>(builder: (context, globalData, _) {
      return FutureBuilder(
          future: widget.recordType == RecordType.bloodsugar
              ? bloodsugarPeriodViewModel.getPeriodBloodsugars(
                  context, globalData.selectedDate, type)
              : weightPeriodViewModel.getWeights(
                  context, globalData.selectedDate, type),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              data = snapshot.data!;
              dataPerPeriod = (widget.recordType == RecordType.bloodsugar
                      ? data['bloodsugars']
                      : data['weightList']) ??
                  [];
              dataList = [
                if (dataPerPeriod.isNotEmpty)
                  ...(dataPerPeriod.map((data) {
                    return LineChartData(
                        DateTime.parse(data.endDate),
                        widget.recordType == RecordType.bloodsugar
                            ? data.averageLevel
                            : data.weight);
                  }).toList())
                else
                  LineChartData(DateTime.now(), 20)
              ];
            }
            if (!snapshot.hasData) {
              return const Center(
                  child: CircularProgressIndicator(
                backgroundColor: primaryColor,
                color: Colors.white,
              ));
            }
            return Container(
              width: screenWidth - 2 * paddingValue,
              height: min(400.w, 650),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.w),
                color: Colors.white,
              ),
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    TabBar(
                        controller: _tabController,
                        labelColor: mainTextColor,
                        labelStyle: TextStyle(
                          color: mainTextColor,
                          fontSize: min(16.sp, 26),
                          fontWeight: FontWeight.w700,
                        ),
                        unselectedLabelStyle: TextStyle(
                          color: offButtonTextColor,
                          fontWeight: FontWeight.w600,
                          fontSize: min(16.sp, 26),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 5.w),
                        labelPadding:
                            EdgeInsets.only(bottom: 3.w),
                        tabs: const [
                          Tab(text: "일간"),
                          Tab(text: "주간"),
                          Tab(text: "월간"),
                        ],
                        indicatorSize: TabBarIndicatorSize.label,
                        indicator: CustomTabIndicator(color: primaryColor)),
                    Expanded(
                      child: _tabBarView(widget, dataList, type),
                    )
                  ],
                ),
              ),
            );
          });
    });
  }
}

Widget _tabBarView(
    TimeLineChart widget, List<LineChartData> dataList, String type) {
  LineChartData minValuePoint = dataList
      .reduce((current, next) => current.yValue < next.yValue ? current : next);
  return TabBarView(
    children: [
      LineChart(
        dataList: dataList,
        baseValue: minValuePoint.yValue,
        unit: widget.recordType.unit,
        timeType: type,
      ),
      LineChart(
        dataList: dataList,
        baseValue: minValuePoint.yValue,
        unit: widget.recordType.unit,
        timeType: type,
      ),
      LineChart(
        dataList: dataList,
        baseValue: minValuePoint.yValue,
        unit: widget.recordType.unit,
        timeType: type,
      ),
    ],
  );
}
