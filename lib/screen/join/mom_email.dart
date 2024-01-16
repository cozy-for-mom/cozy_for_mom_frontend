import 'package:cozy_for_mom_frontend/screen/join/join_input_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';

class MomEmailInputScreen extends StatefulWidget {
  const MomEmailInputScreen({super.key});

  @override
  State<MomEmailInputScreen> createState() => _MomEmailInputScreenState();
}

class _MomEmailInputScreenState extends State<MomEmailInputScreen> {
  TextEditingController textController = TextEditingController();
  bool _isEmailValid = false;
  bool _isInputValid = false;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final joinInputData = Provider.of<JoinInputData>(context);
    textController.text = joinInputData.email;
    return Stack(
      children: [
        const Positioned(
          top: 90,
          left: 20,
          child: Text('사용할 이메일을 입력해 주세요',
              style: TextStyle(
                  color: mainTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 26)),
        ),
        const Positioned(
          top: 135,
          left: 20,
          child: Text('안심하세요! 개인정보는 외부에 공개되지 않아요.',
              style: TextStyle(
                  color: offButtonTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14)),
        ),
        Positioned(
          top: 220,
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
                                  setState(() {
                                    textController.clear();
                                    _isInputValid = !_isInputValid;
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
                                image: AssetImage(_isEmailValid
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
                  setState(() {
                    joinInputData.setEmail(value);
                    _isEmailValid = _validateEmail(value);
                    _isInputValid = true;
                    if (value.isEmpty) {
                      _isInputValid = false;
                    }
                  });
                },
              )),
        ),
        _isInputValid
            ? Positioned(
                top: 279,
                left: 39,
                child: Text(
                  _isEmailValid ? '사용 가능한 이메일입니다.' : '사용 불가능한 형식의 이메일입니다.',
                  style: TextStyle(
                      color: _isEmailValid ? primaryColor : deleteButtonColor,
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
