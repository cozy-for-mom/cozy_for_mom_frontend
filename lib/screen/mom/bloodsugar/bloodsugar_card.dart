import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/screen/mom/bloodsugar/bloodsugar_modal.dart';
import 'package:cozy_for_mom_frontend/model/global_state.dart';
import 'package:provider/provider.dart';

class BloodsugarCard extends StatefulWidget {
  final String time;

  BloodsugarCard({required this.time});
  @override
  State<BloodsugarCard> createState() => _BloodsugarCardState();
}

class _BloodsugarCardState extends State<BloodsugarCard> {
  final List<String> periods = ['식전', '식후'];

  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<MyDataModel>(context);
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 12),
        width: 350,
        height: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              widget.time,
              style: const TextStyle(
                  color: offButtonTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 12),
            ),
            Column(
                children: periods.map((period) {
              String input =
                  globalState.bloodSugarData[widget.time + period] ?? '-';
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(period,
                          style: const TextStyle(
                              color: mainTextColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 16)),
                      Row(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return BloodsugarModal(
                                      time: widget.time, period: period);
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              width: 124,
                              height: 41,
                              decoration: BoxDecoration(
                                  color: input == '-'
                                      ? offButtonColor
                                      : primaryColor,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(input,
                                  textAlign: TextAlign.center,
                                  style: input == '-'
                                      ? const TextStyle(
                                          color: mainTextColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18)
                                      : const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16)),
                            ),
                          ),
                          const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Text(
                                'mg / dL',
                                style: TextStyle(
                                    color: mainTextColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              )),
                        ],
                      )
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 8)),
                ],
              );
            }).toList()),
          ],
        ),
      ),
    );
  }
}
