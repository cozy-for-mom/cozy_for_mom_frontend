import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';

class InfoInputForm extends StatefulWidget {
  final String title;
  final String hint;
  final String unit;
  final TextEditingController? controller;
  final VoidCallback? onChanged;

  const InfoInputForm(
      {super.key,
      required this.title,
      this.hint = '',
      this.unit = '',
      this.controller,
      this.onChanged});

  @override
  State<InfoInputForm> createState() => _InfoInputFormState();
}

class _InfoInputFormState extends State<InfoInputForm> {
  bool _isHintVisible = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (widget.controller!.text.isNotEmpty) {
      _isHintVisible = false;
    }

    return SizedBox(
      width: screenWidth - AppUtils.scaleSize(context, 40),
      height: AppUtils.scaleSize(context, 83),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.title,
              style: TextStyle(
                  color: offButtonTextColor,
                  fontWeight: FontWeight.w600,
                  fontSize: AppUtils.scaleSize(context, 14))),
          SizedBox(height: AppUtils.scaleSize(context, 14)),
          Container(
              width: screenWidth - AppUtils.scaleSize(context, 40),
              height: AppUtils.scaleSize(context, 48),
              padding: EdgeInsets.symmetric(
                  horizontal: AppUtils.scaleSize(context, 20)),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IntrinsicWidth(
                    child: TextFormField(
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      controller: widget.controller,
                      maxLength: 8,
                      textAlign: TextAlign.start,
                      cursorColor: primaryColor,
                      cursorHeight: AppUtils.scaleSize(context, 17),
                      cursorWidth: AppUtils.scaleSize(context, 1.5),
                      style: TextStyle(
                          color: afterInputColor,
                          fontWeight: FontWeight.w500,
                          fontSize: AppUtils.scaleSize(context, 16)),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                        hintText: _isHintVisible ? widget.hint : null,
                        hintStyle: TextStyle(
                            color: beforeInputColor,
                            fontWeight: FontWeight.w500,
                            fontSize: AppUtils.scaleSize(context, 16)),
                      ),
                      onTap: () {
                        setState(() {
                          _isHintVisible = false;
                        });
                      },
                      onChanged: (text) {
                        setState(() {
                          widget.onChanged?.call();
                        });
                      },
                    ),
                  ),
                  _isHintVisible
                      ? Container()
                      : Text(
                          ' ${widget.unit}',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: AppUtils.scaleSize(context, 16)),
                        )
                ],
              )),
        ],
      ),
    );
  }
}
