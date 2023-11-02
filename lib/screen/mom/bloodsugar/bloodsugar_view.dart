import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';

class BloodsugarView extends StatelessWidget {
  const BloodsugarView({super.key});

  final double avg = 109.0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            top: 204,
            left: 20,
            child: Container(
              width: 350,
              height: 399,
              decoration: const BoxDecoration(
                  color: Colors.white60,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
            )),
        Positioned(
            top: 635,
            left: 20,
            child: Container(
              width: 350,
              height: 114,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: BoxDecoration(
                  color: contentBoxTwoColor,
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('평균 ${avg}의 혈당 수치예요',
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 18)),
                        const Padding(padding: EdgeInsets.only(bottom: 6)),
                        const Text.rich(
                          TextSpan(
                            text: '임산부의 혈당치는 공복시 ',
                            style: TextStyle(
                                color: mainTextColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 12),
                            children: [
                              TextSpan(
                                  text: '평균 77mg/dL',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12)),
                              TextSpan(
                                  text: ' 정도로 \n일반인보다 낮은 편이네요!',
                                  style: TextStyle(
                                      color: mainTextColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Image.asset('assets/images/icons/icon_bloodsugar.png',
                        width: 47, height: 61),
                  ]),
            ))
      ],
    );
  }
}
