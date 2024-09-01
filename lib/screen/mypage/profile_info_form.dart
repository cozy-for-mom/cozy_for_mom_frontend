import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:intl/intl.dart';

class ProfileInfoForm extends StatefulWidget {
  final String title;
  final String hint;
  final String suffix;
  final TextEditingController? controller;

  const ProfileInfoForm(
      {super.key,
      required this.title,
      this.hint = '',
      this.suffix = '',
      this.controller});

  @override
  State<ProfileInfoForm> createState() => _ProfileInfoFormState();
}

class _ProfileInfoFormState extends State<ProfileInfoForm> {
  bool _isSuffixVisible = false;

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
                maxLength: widget.title == '닉네임' ? 8 : 20,
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
                                image: AssetImage(checkNicknameLength(
                                            widget.controller!.text) ||
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
                  widget.title == '생년월일'
                      ? setState(() {
                          String parsedDate;
                          if (text.length == 8 && _isNumeric(text)) {
                            parsedDate = DateFormat('yyyy.MM.dd')
                                .format(DateTime.parse(text));
                            // 오늘 날짜보다 미래인 경우 어제 날짜로 변경
                            if (DateTime.parse(text).isAfter(DateTime.now())) {
                              parsedDate = DateFormat('yyyy.MM.dd').format(
                                  DateTime.now()
                                      .subtract(const Duration(days: 1)));
                            }
                          } else {
                            parsedDate = text;
                          }
                          widget.controller!.text = parsedDate;
                        })
                      : setState(() {
                          if (text.isEmpty) {
                            widget.controller!.clear();
                            _isSuffixVisible = false;
                          } else {
                            _isSuffixVisible = true;
                          }
                        });
                },
              )),
          (widget.title == '닉네임' || widget.title == '이메일') && _isSuffixVisible
              ? Padding(
                  padding: EdgeInsets.only(
                      top: AppUtils.scaleSize(context, 5),
                      left: AppUtils.scaleSize(context, 10)),
                  child: Text(
                    (widget.title == '닉네임' &&
                                checkNicknameLength(widget.controller!.text)) ||
                            (widget.title == '이메일' &&
                                _validateEmail(widget.controller!.text))
                        ? '사용 가능한 ${widget.title}입니다.'
                        : (widget.title == '닉네임' &&
                                !checkNicknameLength(widget.controller!.text))
                            ? '닉네임은 최대 8자까지 입력이 가능해요.'
                            : '사용 불가능한 형식의 이메일입니다.',
                    style: TextStyle(
                        color: (widget.title == '닉네임' &&
                                    checkNicknameLength(
                                        widget.controller!.text)) ||
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
