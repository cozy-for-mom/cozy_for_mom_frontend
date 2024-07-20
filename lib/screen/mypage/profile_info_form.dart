import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';

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
      width: 350,
      // height: 83,
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
                keyboardType: TextInputType.text,
                controller: widget.controller,
                textAlign: TextAlign.start,
                cursorColor: primaryColor,
                cursorHeight: 17,
                cursorWidth: 1.5,
                maxLength: widget.title == '닉네임' ? 8 : 20,
                style: const TextStyle(
                    color: afterInputColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
                decoration: InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  suffixText: widget.suffix,
                  suffixStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                  hintText: widget.hint,
                  hintStyle: const TextStyle(
                      color: beforeInputColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                  suffixIcon: (widget.title == '닉네임' ||
                              widget.title == '이메일') &&
                          _isSuffixVisible
                      ? SizedBox(
                          width: 42,
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
                                child: const Image(
                                  image: AssetImage(
                                      'assets/images/icons/text_delete.png'),
                                  width: 16,
                                  height: 16,
                                ),
                              ),
                              Image(
                                image: AssetImage(checkNicknameLength(
                                            widget.controller!.text) ||
                                        _validateEmail(widget.controller!.text)
                                    ? 'assets/images/icons/pass.png'
                                    : 'assets/images/icons/unpass.png'),
                                width: 18,
                                height: 18,
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
                  setState(() {
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
                  padding: const EdgeInsets.only(top: 5, left: 10),
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
                        fontSize: 12),
                  ))
              : Container(),
        ],
      ),
    );
  }
}

bool checkNicknameLength(String nickName) {
  if (nickName.isEmpty) return false;
  return nickName.length < 8;
}

bool _validateEmail(String email) {
  if (email.isEmpty) return false;
  RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  return emailRegExp.hasMatch(email);
}
