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
    return InkWell(
      onTap: widget.tapped,
      child: SizedBox(
        width: screenWidth - 40,
        height: 90,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 34),
          child: Container(
            height: 56,
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
      ),
    );
  }
}
