import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/join/join_input_data.dart';

class BabyBirthnameScreen extends StatefulWidget {
  const BabyBirthnameScreen({super.key});

  @override
  State<BabyBirthnameScreen> createState() => _BabyBirthnameScreenState();
}

class _BabyBirthnameScreenState extends State<BabyBirthnameScreen> {
  TextEditingController textController = TextEditingController();
  bool _isBirthnameValid = false;
  bool _isInputValid = false;
  bool _isInitiate = true;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final joinInputData = Provider.of<JoinInputData>(context);
    textController.text = joinInputData.birthName;
    return Stack(
      children: [
        const Positioned(
          top: 90,
          left: 20,
          child: Text('아기의 태명을 입력해주세요',
              style: TextStyle(
                  color: mainTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 26)),
        ),
        const Positioned(
          top: 135,
          left: 20,
          child: Text('정보는 언제든지 마이로그에서 수정할 수 있어요.',
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
                maxLength: 9,
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
                                    joinInputData.setBirthname('');
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
                                image: AssetImage(_isBirthnameValid
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
                    _isInitiate = false;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    joinInputData.birthName = value;
                    _isBirthnameValid = value.length <= 8;
                    _isInputValid = true;
                    if (value.isEmpty) {
                      _isInputValid = false;
                    }
                  });
                },
              )),
        ),
        _isInitiate
            ? Container()
            : Positioned(
                top: 279,
                left: 39,
                child: Text(
                  _isInputValid
                      ? (_isBirthnameValid ? '' : '테명은 최대 8자까지 입력이 가능해요.')
                      : '아기의 태명을 입력해주세요.',
                  style: const TextStyle(
                      color: deleteButtonColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ))
      ],
    );
  }
}
