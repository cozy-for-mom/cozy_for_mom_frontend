import 'dart:async';

import 'package:cozy_for_mom_frontend/screen/join/join_input_data.dart';
import 'package:cozy_for_mom_frontend/service/user/join_api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';

class MomEmailInputScreen extends StatefulWidget {
  final Function(bool) updateValidity;
  const MomEmailInputScreen({super.key, required this.updateValidity});

  @override
  State<MomEmailInputScreen> createState() => _MomEmailInputScreenState();
}

class _MomEmailInputScreenState extends State<MomEmailInputScreen> {
  TextEditingController textController = TextEditingController();
  bool _isEmailValid = false;
  bool _isInputValid = false;
  bool _isEmailNotDuplicated = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final joinInputData = Provider.of<JoinInputData>(context, listen: false);
    textController.text = joinInputData.email;
    // 소셜로그인에서 받아온 이메일이 있을 경우
    if (textController.text.isNotEmpty) {
      initEmail(textController.text);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    textController.dispose();
    super.dispose();
  }

  void initEmail(String text) async {
    _isEmailValid = _validateEmail(text);
    _isEmailNotDuplicated = await JoinApiService().emailDuplicateCheck(text);
    if (mounted) {
      setState(() {
        _isInputValid = text.isNotEmpty;
        widget.updateValidity(
            _isEmailValid && _isEmailNotDuplicated && _isInputValid);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final joinInputData = Provider.of<JoinInputData>(context);

    return Stack(
      children: [
        const Positioned(
          top: 50,
          left: 20,
          child: Text('사용할 이메일을 입력해 주세요',
              style: TextStyle(
                  color: mainTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 26)),
        ),
        const Positioned(
          top: 95,
          left: 20,
          child: Text('안심하세요! 개인정보는 외부에 공개되지 않아요.',
              style: TextStyle(
                  color: offButtonTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14)),
        ),
        Positioned(
          top: 180,
          left: 20,
          child: Container(
              width: screenWidth - 40,
              height: 48,
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 20, right: 20),
              decoration: BoxDecoration(
                  color: contentBoxTwoColor,
                  borderRadius: BorderRadius.circular(10)),
              child: TextFormField(
                controller: textController,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
                cursorColor: primaryColor,
                maxLength: 34,
                cursorHeight: 14,
                cursorWidth: 1.2,
                style: const TextStyle(
                    color: mainTextColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 14),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: InputBorder.none,
                  hintText: 'cozy@cozy.com',
                  hintStyle: const TextStyle(
                      color: beforeInputColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                  counterText: '',
                  suffixIcon: _isInputValid
                      ? SizedBox(
                          width: 42,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () {
                                  if (mounted) {
                                    setState(() {
                                      joinInputData.setEmail('');
                                      textController.clear();
                                      _isInputValid = !_isInputValid;
                                      widget.updateValidity(_isInputValid);
                                    });
                                  }
                                },
                                child: const Image(
                                  image: AssetImage(
                                      'assets/images/icons/text_delete.png'),
                                  width: 16,
                                  height: 16,
                                ),
                              ),
                              Image(
                                image: AssetImage(
                                    _isEmailValid && _isEmailNotDuplicated
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
                onChanged: (value) {
                  if (mounted) {
                    setState(() {
                      joinInputData.setEmail(value);
                      if (textController.text.isEmpty) {
                        setState(() {
                          _isInputValid = false;
                          widget.updateValidity(false);
                        });
                      } else {
                        if (_debounce?.isActive ?? false) _debounce?.cancel();

                        _debounce =
                            Timer(const Duration(milliseconds: 200), () async {
                          _isEmailNotDuplicated =
                              await JoinApiService().emailDuplicateCheck(value);
                          setState(() {
                            _isEmailValid = _validateEmail(value);
                            _isInputValid = true;
                            widget.updateValidity(_isEmailValid &
                                _isEmailNotDuplicated &
                                _isInputValid);
                          });
                        });
                      }
                    });
                  }
                },
              )),
        ),
        _isInputValid
            ? Positioned(
                top: 239,
                left: 39,
                child: Text(
                  _isEmailNotDuplicated
                      ? _isEmailValid
                          ? '사용 가능한 이메일입니다.'
                          : '사용 불가능한 형식의 이메일입니다.'
                      : '이미 사용중인 이메일입니다.',
                  style: TextStyle(
                      color: !_isEmailNotDuplicated || !_isEmailValid
                          ? deleteButtonColor
                          : primaryColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ))
            : Container(),
      ],
    );
  }
}

bool _validateEmail(String email) {
  RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  return emailRegExp.hasMatch(email);
}
