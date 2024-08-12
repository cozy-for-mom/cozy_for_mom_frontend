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
      color: Colors.transparent,
      margin: const EdgeInsets.only(bottom: 34),
      width: screenWidth - 40,
      height: 56,
      child: InkWell(
        onTap: widget.isActivated ? widget.tapped : null,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: widget.isActivated ? primaryColor : induceButtonColor,
              borderRadius: BorderRadius.circular(12)),
          child: Text(widget.text,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16)),
        ),
      ),
    );
  }
}
