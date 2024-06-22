import 'package:cozy_for_mom_frontend/service/user/join_api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/join/join_input_data.dart';
import 'dart:async';

class MomNicknameInputScreen extends StatefulWidget {
  const MomNicknameInputScreen({super.key});

  @override
  State<MomNicknameInputScreen> createState() => _MomNicknameInputScreenState();
}

class _MomNicknameInputScreenState extends State<MomNicknameInputScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  bool _isNicknameLengthNotExceeded = false;
  bool _isNicknameNotDuplicated = false;
  bool _isNicknameValid = false;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final joinInputData = Provider.of<JoinInputData>(context);
    _nicknameController.text = joinInputData.nickname;
    return Stack(
      children: [
        const Positioned(
          top: 50,
          left: 20,
          child: Text('사용할 닉네임을 입력해주세요',
              style: TextStyle(
                  color: mainTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 26)),
        ),
        const Positioned(
          top: 95,
          left: 20,
          child: Text('닉네임은 마이로그에서도 수정할 수 있어요.',
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
                controller: _nicknameController,
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
                  suffixIcon: _isNicknameValid
                      ? SizedBox(
                          width: 42,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    joinInputData.setNickname('');
                                    _isNicknameValid = !_isNicknameValid;
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
                                image: AssetImage(_isNicknameLengthNotExceeded
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
                  joinInputData.setNickname(value);
                  if (_nicknameController.text.isEmpty) {
                    setState(() {
                      _isNicknameValid = false;
                    });
                  } else {
                    if (_debounce?.isActive ?? false) _debounce?.cancel();

                    _debounce =
                        Timer(const Duration(milliseconds: 200), () async {
                      if (_nicknameController.text.isEmpty) {
                        return; // 필드가 비어있다면, 더 이상 진행하지 않는다.
                      }

                      _isNicknameNotDuplicated =
                          await JoinApiService().nicknameDuplicateCheck(value);
                      setState(() {
                        _isNicknameLengthNotExceeded = value.length <= 8;
                        _isNicknameValid = true;
                      });
                    });
                  }
                },
              )),
        ),
        _isNicknameValid
            ? Positioned(
                top: 239,
                left: 39,
                child: Text(
                  _isNicknameNotDuplicated
                      ? _isNicknameLengthNotExceeded
                          ? '사용 가능한 닉네임입니다.'
                          : '닉네임은 최대 8자까지 입력이 가능해요.'
                      : '이미 사용중인 닉네임입니다.',
                  style: TextStyle(
                      color: !_isNicknameNotDuplicated ||
                              !_isNicknameLengthNotExceeded
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
