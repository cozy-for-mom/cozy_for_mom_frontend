import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/join/join_input_data.dart';

class BuildRadioButton extends StatefulWidget {
  final String title;
  final String value;
  const BuildRadioButton({super.key, required this.title, required this.value});

  @override
  State<BuildRadioButton> createState() => _BuildRadioButtonState();
}

class _BuildRadioButtonState extends State<BuildRadioButton> {
  @override
  Widget build(BuildContext context) {
    final joinInputData = Provider.of<JoinInputData>(context);
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          color: contentBoxTwoColor,
          borderRadius: BorderRadius.circular(10),
          border: widget.value == joinInputData.fetalInfo
              ? Border.all(color: primaryColor, width: 2)
              : null),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.title,
              style: TextStyle(
                  color: widget.value == joinInputData.fetalInfo
                      ? mainTextColor
                      : beforeInputColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 14)),
          SizedBox(
            width: 18,
            child: Radio(
              value: widget.value,
              groupValue: joinInputData.fetalInfo,
              activeColor: primaryColor,
              onChanged: (newValue) {
                setState(() {
                  joinInputData.setFetalInfo(newValue as String);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
