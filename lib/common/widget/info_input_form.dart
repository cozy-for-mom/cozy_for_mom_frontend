import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';

class InfoInputForm extends StatelessWidget {
  final String title;
  final String hint;
  const InfoInputForm({super.key, required this.title, required this.hint});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      height: 83,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title,
              style: const TextStyle(
                  color: offButtonTextColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14)),
          const SizedBox(height: 14),
          Container(
              width: 350,
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: TextFormField(
                textAlign: TextAlign.start,
                cursorColor: beforeInputColor,
                style: const TextStyle(
                    color: afterInputColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle: const TextStyle(
                      color: beforeInputColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
              )),
        ],
      ),
    );
  }
}
