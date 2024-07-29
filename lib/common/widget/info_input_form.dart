import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:flutter/services.dart';

class InfoInputForm extends StatefulWidget {
  final String title;
  final String hint;
  final String suffix;
  final TextEditingController? controller;
  final VoidCallback? onChanged;

  const InfoInputForm(
      {super.key,
      required this.title,
      this.hint = '',
      this.suffix = '',
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

    return SizedBox(
      width: screenWidth - 40,
      height: 83,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.title,
              style: const TextStyle(
                  color: offButtonTextColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14)),
          const SizedBox(height: 14),
          Container(
              width: screenWidth - 40,
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                controller: widget.controller,
                textAlign: TextAlign.start,
                cursorColor: primaryColor,
                cursorHeight: 17,
                cursorWidth: 1.5,
                style: const TextStyle(
                    color: afterInputColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixText: widget.suffix,
                  suffixStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                  hintText: _isHintVisible ? widget.hint : null,
                  hintStyle: const TextStyle(
                      color: beforeInputColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
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
              )),
        ],
      ),
    );
  }
}
