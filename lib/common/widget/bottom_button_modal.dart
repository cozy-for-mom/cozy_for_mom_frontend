import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';

class BottomButtonWidget extends StatefulWidget {
  final bool isActivated;
  final String text;
  final VoidCallback tapped;
  const BottomButtonWidget(
      {super.key,
      required this.isActivated,
      required this.text,
      required this.tapped});

  @override
  State<BottomButtonWidget> createState() => _BottomButtonWidgetState();
}

class _BottomButtonWidgetState extends State<BottomButtonWidget> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter, // 그라데이션 시작점
          end: Alignment.topCenter, // 그라데이션 끝점
          colors: [
            Colors.white, // 시작 색상
            Colors.white.withOpacity(0.0), // 끝 색상
          ],
        ),
      ),
      padding: EdgeInsets.only(
          top: AppUtils.scaleSize(context, 20),
          bottom: AppUtils.scaleSize(context, 34)),
      child: Container(
        margin:
            EdgeInsets.symmetric(horizontal: AppUtils.scaleSize(context, 20)),
        alignment: Alignment.center,
        height: AppUtils.scaleSize(context, 56),
        child: InkWell(
          onTap: widget.isActivated ? widget.tapped : null,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: widget.isActivated ? primaryColor : induceButtonColor,
                borderRadius: BorderRadius.circular(12)),
            child: Text(widget.text,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: AppUtils.scaleSize(context, 16))),
          ),
        ),
      ),
    );
  }
}
