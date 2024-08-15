import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';

class SelectBottomModal extends StatelessWidget {
  final String selec1;
  final String selec2;
  final VoidCallback tap1;
  final VoidCallback tap2;
  SelectBottomModal(
      {super.key,
      required this.selec1,
      required this.selec2,
      required this.tap1,
      required this.tap2});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth - AppUtils.scaleSize(context, 40),
      height: AppUtils.scaleSize(context, 220),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding:
                EdgeInsets.symmetric(vertical: AppUtils.scaleSize(context, 8)),
            width: screenWidth - AppUtils.scaleSize(context, 40),
            height: AppUtils.scaleSize(context, 128),
            decoration: BoxDecoration(
                color: contentBoxTwoColor,
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: tap1,
                  child: Text(selec1,
                      style: const TextStyle(
                          color: mainTextColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16)),
                ),
                InkWell(
                  onTap: tap2,
                  child: Text(selec2,
                      style: const TextStyle(
                          color: mainTextColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16)),
                ),
              ],
            ),
          ),
          SizedBox(height: AppUtils.scaleSize(context, 16)),
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              alignment: Alignment.center,
              width: screenWidth - AppUtils.scaleSize(context, 40),
              height: AppUtils.scaleSize(context, 56),
              decoration: BoxDecoration(
                  color: induceButtonColor,
                  borderRadius: BorderRadius.circular(12)),
              child: const Text('취소',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
