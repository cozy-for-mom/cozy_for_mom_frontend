import 'dart:async';

import 'package:cozy_for_mom_frontend/service/user/join_api_service.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:intl/intl.dart';

class ProfileInfoForm extends StatefulWidget {
  final String title;
  final String hint;
  final String suffix;
  final TextEditingController? controller;
  final Function(bool) updateValidity;

  const ProfileInfoForm(
      {super.key,
      required this.title,
      this.hint = '',
      this.suffix = '',
      this.controller,
      required this.updateValidity});

  @override
  State<ProfileInfoForm> createState() => _ProfileInfoFormState();
}

class _ProfileInfoFormState extends State<ProfileInfoForm> {
  bool _isSuffixVisible = false;
  bool? _isNicknameNotDuplicated = true;

  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth - AppUtils.scaleSize(context, 40),
      // height: 83,
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
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: widget.controller,
                textAlign: TextAlign.start,
                cursorColor: primaryColor,
                cursorHeight: AppUtils.scaleSize(context, 17),
                cursorWidth: AppUtils.scaleSize(context, 1.5),
                maxLength: widget.title == '닉네임'
                    ? 8
                    : widget.title == '생년월일'
                        ? 10
                        : 20,
                style: TextStyle(
                    color: afterInputColor,
                    fontWeight: FontWeight.w500,
                    fontSize: AppUtils.scaleSize(context, 16)),
                decoration: InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  suffixText: widget.suffix,
                  suffixStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: AppUtils.scaleSize(context, 16)),
                  hintText: widget.hint,
                  hintStyle: TextStyle(
                      color: beforeInputColor,
                      fontWeight: FontWeight.w500,
                      fontSize: AppUtils.scaleSize(context, 16)),
                  suffixIcon: (widget.title == '닉네임' ||
                              widget.title == '이메일') &&
                          _isSuffixVisible
                      ? SizedBox(
                          width: AppUtils.scaleSize(context, 42),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    widget.controller!.clear();
                                    _isSuffixVisible = false;
                                    widget.updateValidity(_isSuffixVisible);
                                  });
                                },
                                child: Image(
                                  image: const AssetImage(
                                      'assets/images/icons/text_delete.png'),
                                  width: AppUtils.scaleSize(context, 16),
                                  height: AppUtils.scaleSize(context, 16),
                                ),
                              ),
                              Image(
                                image: AssetImage((checkNicknameLength(
                                                widget.controller!.text) &&
                                            _isNicknameNotDuplicated!) ||
                                        _validateEmail(widget.controller!.text)
                                    ? 'assets/images/icons/pass.png'
                                    : 'assets/images/icons/unpass.png'),
                                width: AppUtils.scaleSize(context, 18),
                                height: AppUtils.scaleSize(context, 18),
                              ),
                            ],
                          ),
                        )
                      : null,
                ),
                onTap: () {
                  setState(() {
                    _isSuffixVisible = true;
                  });
                },
                onChanged: (text) {
                  if (widget.title == '생년월일') {
                    if (text.length < 10) {
                      if (mounted) {
                        setState(() {
                          widget.updateValidity(false);
                        });
                      }
                    }
                    setState(() {
                      String parsedDate;
                      if (text.length == 8 && _isNumeric(text)) {
                        try {
                          DateTime inputDate = DateTime.parse(text);
                          DateTime normalizedDate = inputDate
                                  .isAfter(DateTime.now())
                              ? DateTime.now().subtract(const Duration(days: 1))
                              : inputDate;
                          parsedDate =
                              DateFormat('yyyy.MM.dd').format(normalizedDate);
                          widget.updateValidity(true);
                        } catch (e) {
                          parsedDate = '';
                        }
                      } else {
                        parsedDate = text;
                        widget.updateValidity(isValidDateFormat(text));
                      }
                      widget.controller!.text = parsedDate;
                      widget.controller!.selection = TextSelection.fromPosition(
                          TextPosition(offset: widget.controller!.text.length));
                    });
                  } else if (widget.title == '닉네임') {
                    if (text.isEmpty) {
                      if (mounted) {
                        setState(() {
                          widget.controller!.clear();
                          _isSuffixVisible = false;
                          widget.updateValidity(_isSuffixVisible);
                        });
                      }
                    } else {
                      if (_debounce?.isActive ?? false) _debounce?.cancel();
                      _debounce =
                          Timer(const Duration(milliseconds: 200), () async {
                        if (text.isEmpty)
                          return; // Field is empty, no further action.

                        _isNicknameNotDuplicated = await JoinApiService()
                            .nicknameDuplicateCheck(context, text);
                        if (mounted) {
                          setState(() {
                            _isSuffixVisible = true;
                            widget.updateValidity(
                                _isSuffixVisible && _isNicknameNotDuplicated!);
                          });
                        }
                      });
                    }
                  } else {
                    setState(() {
                      if (text.isEmpty) {
                        widget.controller!.clear();
                        _isSuffixVisible = false;
                      } else {
                        _isSuffixVisible = true;
                      }
                      if (widget.title == '이메일') {
                        widget.updateValidity(_isSuffixVisible &&
                            _validateEmail(widget.controller!.text));
                      } else {
                        widget.updateValidity(_isSuffixVisible);
                      }
                    });
                  }
                },
              )),
          (widget.title == '닉네임' || widget.title == '이메일') && _isSuffixVisible
              ? Padding(
                  padding: EdgeInsets.only(
                      top: AppUtils.scaleSize(context, 5),
                      left: AppUtils.scaleSize(context, 10)),
                  child: Text(
                    (widget.title == '닉네임' &&
                            checkNicknameLength(widget.controller!.text))
                        ? (!_isNicknameNotDuplicated!
                            ? '이미 사용중인 닉네임입니다.'
                            : '사용 가능한 닉네임입니다.')
                        : (widget.title == '이메일' &&
                                _validateEmail(widget.controller!.text))
                            ? '사용 가능한 이메일입니다.'
                            : (widget.title == '닉네임' &&
                                    !checkNicknameLength(
                                        widget.controller!.text))
                                ? '닉네임은 최대 8자까지 입력이 가능해요.'
                                : '사용 불가능한 형식의 이메일입니다.',
                    style: TextStyle(
                        color: (widget.title == '닉네임' &&
                                    checkNicknameLength(
                                        widget.controller!.text) &&
                                    _isNicknameNotDuplicated!) ||
                                (widget.title == '이메일' &&
                                    _validateEmail(widget.controller!.text))
                            ? primaryColor
                            : deleteButtonColor,
                        fontWeight: FontWeight.w400,
                        fontSize: AppUtils.scaleSize(context, 12)),
                  ))
              : Container(),
        ],
      ),
    );
  }
}

bool checkNicknameLength(String nickName) {
  if (nickName.isEmpty) return false;
  return nickName.length < 9;
}

bool _validateEmail(String email) {
  if (email.isEmpty) return false;
  RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  return emailRegExp.hasMatch(email);
}

bool _isNumeric(String value) {
  final numericRegex = RegExp(r'^[0-9]+$');
  return numericRegex.hasMatch(value);
}

bool isValidDateFormat(String input) {
  // 'YYYY.MM.DD' 형식 검사
  RegExp dateRegExp = RegExp(r'^\d{4}\.\d{2}\.\d{2}$');
  return dateRegExp.hasMatch(input);
}
