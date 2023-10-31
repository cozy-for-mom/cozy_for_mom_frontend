import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/model/global_state.dart';
import 'package:provider/provider.dart';

class BloodsugarModal extends StatelessWidget {
  final String time;
  final String period;

  BloodsugarModal({required this.time, required this.period});
  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<MyDataModel>(context, listen: false);
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 350,
        height: 207,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: contentBoxTwoColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('혈당 기록',
                style: TextStyle(
                    color: mainTextColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 20)),
            Container(
              width: 312,
              height: 80,
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 12),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: Text(time,
                          style: const TextStyle(
                              color: offButtonTextColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12)),
                    ),
                    SizedBox(
                      height: 32,
                      child: TextFormField(
                        onChanged: (text) {
                          globalState.setBloodSugarData(time + period, text);
                        },
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '${period} 혈당 수치 입력',
                            hintStyle: const TextStyle(
                                color: mainLineColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 16)),
                        cursorColor: mainLineColor,
                        style: const TextStyle(
                            color: mainTextColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
