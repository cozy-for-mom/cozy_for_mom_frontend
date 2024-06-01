import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/join/join_input_data.dart';

class MomNicknameInputScreen extends StatefulWidget {
  const MomNicknameInputScreen({super.key});

  @override
  State<MomNicknameInputScreen> createState() => _MomNicknameInputScreenState();
}

class _MomNicknameInputScreenState extends State<MomNicknameInputScreen> {
  TextEditingController textController = TextEditingController();
  bool _isNicknameValid = false;
  bool _isInputValid = false;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final joinInputData = Provider.of<JoinInputData>(context);
    textController.text = joinInputData.nickname;
    return Stack(
      children: [
        const Positioned(
          top: 90,
          left: 20,
          child: Text('사용할 닉네임을 입력해주세요',
              style: TextStyle(
                  color: mainTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 26)),
        ),
        const Positioned(
          top: 135,
          left: 20,
          child: Text('닉네임은 마이로그에서도 수정할 수 있어요.',
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
                keyboardType: TextInputType.text,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
                maxLength: 20,
                cursorColor: primaryColor,
                cursorHeight: 14,
                cursorWidth: 1.2,
                style: const TextStyle(
                    color: mainTextColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 14),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: InputBorder.none,
                  hintText: '8자 이내로 입력해주세요',
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
                                    joinInputData.setNickname('');
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
                                image: AssetImage(_isNicknameValid
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
                    joinInputData.setNickname(value);
                    _isNicknameValid = value.length <= 8;
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
                  _isNicknameValid
                      ? '사용 가능한 닉네임입니다.'
                      : '닉네임은 최대 8자까지 입력이 가능해요.', // TODO 닉네임 중복 체크
                  style: TextStyle(
                      color:
                          _isNicknameValid ? primaryColor : deleteButtonColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ))
            : Container(),
      ],
    );
  }
}
