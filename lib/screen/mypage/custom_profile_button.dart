import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:flutter/material.dart';

class CustomProfileButton extends StatefulWidget {
  final String text;
  final String imagePath;
  final Color offBackColor;
  final void Function() onPressed;
  final bool isSelected;

  CustomProfileButton(
      {required this.text,
      required this.imagePath,
      required this.offBackColor,
      required this.onPressed,
      required this.isSelected});
  @override
  _CustomProfileButtonState createState() => _CustomProfileButtonState();
}

class _CustomProfileButtonState extends State<CustomProfileButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: widget.isSelected
                      ? Border.all(width: 2, color: primaryColor)
                      : null,
                  color:
                      widget.isSelected ? profileColor : widget.offBackColor),
              child: widget.imagePath == ''
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: Image.asset(
                        'assets/images/icons/babyProfileOn.png',
                        width: 45,
                        height: 45,
                        alignment: Alignment.center,
                      ))
                  : ClipOval(
                      child: Image.network(
                        widget.imagePath,
                        fit: BoxFit.cover,
                        width: 82,
                        height: 82,
                      ),
                    ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.text,
              style: TextStyle(
                  color: widget.isSelected ? primaryColor : offButtonTextColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
