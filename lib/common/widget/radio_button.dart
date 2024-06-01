import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/join/join_input_data.dart';

enum RadioType { fetalInfo }

class BuildRadioButton extends StatefulWidget {
  final String title;
  final String value;
  final RadioType radioButtonType;
  const BuildRadioButton(
      {super.key,
      required this.title,
      required this.value,
      required this.radioButtonType});

  @override
  State<BuildRadioButton> createState() => _BuildRadioButtonState();
}

class _BuildRadioButtonState extends State<BuildRadioButton> {
  @override
  Widget build(BuildContext context) {
    final joinInputData = Provider.of<JoinInputData>(context);
    String? infoType;

    switch (widget.radioButtonType) {
      case RadioType.fetalInfo:
        infoType = joinInputData.fetalInfo;
        break;
    }
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        setState(() {
          if (widget.radioButtonType == RadioType.fetalInfo) {
            joinInputData.setFetalInfo(widget.value);
          }
        });
      },
      child: Container(
        height: 48,
        padding: EdgeInsets.symmetric(
            vertical: 10, horizontal: widget.value == infoType ? 18 : 20),
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
            color: contentBoxTwoColor,
            borderRadius: BorderRadius.circular(10),
            border: widget.value == infoType
                ? Border.all(color: primaryColor, width: 2)
                : null),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title,
                style: TextStyle(
                    color: (widget.value == infoType)
                        ? mainTextColor
                        : beforeInputColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 14)),
            SizedBox(
                width: 18,
                child: Image(
                    image: AssetImage((widget.value == infoType)
                        ? 'assets/images/icons/radio_selected.png'
                        : 'assets/images/icons/radio_unselected.png'))),
          ],
        ),
      ),
    );
  }
}
