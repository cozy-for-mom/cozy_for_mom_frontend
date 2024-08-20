import 'package:cozy_for_mom_frontend/service/user/join_api_service.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/join/join_input_data.dart';
import 'dart:async';

class MomNicknameInputScreen extends StatefulWidget {
  final Function(bool) updateValidity;
  const MomNicknameInputScreen({super.key, required this.updateValidity});

  @override
  State<MomNicknameInputScreen> createState() => _MomNicknameInputScreenState();
}

class _MomNicknameInputScreenState extends State<MomNicknameInputScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  bool _isNicknameLengthNotExceeded = false;
  bool? _isNicknameNotDuplicated = false;
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
        Positioned(
          top: AppUtils.scaleSize(context, 50),
          left: AppUtils.scaleSize(context, 20),
          child: Text('사용할 닉네임을 입력해주세요',
              style: TextStyle(
                  color: mainTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: AppUtils.scaleSize(context, 26))),
        ),
        Positioned(
          top: AppUtils.scaleSize(context, 95),
          left: AppUtils.scaleSize(context, 20),
          child: Text('닉네임은 마이로그에서도 수정할 수 있어요.',
              style: TextStyle(
                  color: offButtonTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: AppUtils.scaleSize(context, 14))),
        ),
        Positioned(
          top: AppUtils.scaleSize(context, 180),
          left: AppUtils.scaleSize(context, 20),
          child: Container(
              width: screenWidth - AppUtils.scaleSize(context, 40),
              height: AppUtils.scaleSize(context, 48),
              padding: EdgeInsets.symmetric(
                  vertical: AppUtils.scaleSize(context, 10),
                  horizontal: AppUtils.scaleSize(context, 20)),
              decoration: BoxDecoration(
                  color: contentBoxTwoColor,
                  borderRadius: BorderRadius.circular(10)),
              child: TextFormField(
                controller: _nicknameController,
                keyboardType: TextInputType.text,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(8),
                ],
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
                maxLength:
                    9, // TODO LengthLimitingTextInputFormatter 적용 결과 보고 지우기
                cursorColor: primaryColor,
                cursorHeight: AppUtils.scaleSize(context, 14),
                cursorWidth: AppUtils.scaleSize(context, 1.2),
                style: TextStyle(
                    color: mainTextColor,
                    fontWeight: FontWeight.w400,
                    fontSize: AppUtils.scaleSize(context, 14)),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      vertical: AppUtils.scaleSize(context, 10)),
                  border: InputBorder.none,
                  hintText: '8자 이내로 입력해주세요',
                  hintStyle: TextStyle(
                      color: beforeInputColor,
                      fontWeight: FontWeight.w400,
                      fontSize: AppUtils.scaleSize(context, 14)),
                  counterText: '',
                  suffixIcon: _isNicknameValid
                      ? SizedBox(
                          width: AppUtils.scaleSize(context, 42),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () {
                                  if (mounted) {
                                    setState(() {
                                      joinInputData.setNickname('');
                                      _isNicknameValid = !_isNicknameValid;
                                    });
                                  }
                                },
                                child: Image(
                                  image: const AssetImage(
                                      'assets/images/icons/text_delete.png'),
                                  width: AppUtils.scaleSize(context, 16),
                                  height: AppUtils.scaleSize(context, 16),
                                ),
                              ),
                              Image(
                                image: AssetImage(
                                    _isNicknameLengthNotExceeded &&
                                            _isNicknameNotDuplicated!
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
                onChanged: (value) {
                  joinInputData.setNickname(value);
                  if (_nicknameController.text.isEmpty) {
                    if (mounted) {
                      setState(() {
                        _isNicknameValid = false;
                        widget.updateValidity(false);
                      });
                    }
                  } else {
                    if (_debounce?.isActive ?? false) _debounce?.cancel();

                    _debounce =
                        Timer(const Duration(milliseconds: 200), () async {
                      if (_nicknameController.text.isEmpty) {
                        return; // 필드가 비어있다면, 더 이상 진행하지 않는다.
                      }

                      _isNicknameNotDuplicated = await JoinApiService()
                          .nicknameDuplicateCheck(context, value);
                      if (mounted) {
                        setState(() {
                          _isNicknameLengthNotExceeded = value.length <= 8;
                          _isNicknameValid = true;
                          widget.updateValidity(_isNicknameLengthNotExceeded &
                              _isNicknameValid &
                              _isNicknameNotDuplicated!);
                        });
                      }
                    });
                  }
                  widget.updateValidity(_isNicknameLengthNotExceeded &
                      _isNicknameNotDuplicated! &
                      _isNicknameValid);
                },
              )),
        ),
        _isNicknameValid
            ? Positioned(
                top: AppUtils.scaleSize(context, 239),
                left: AppUtils.scaleSize(context, 39),
                child: Text(
                  _isNicknameNotDuplicated!
                      ? _isNicknameLengthNotExceeded
                          ? '사용 가능한 닉네임입니다.'
                          : '닉네임은 최대 8자까지 입력이 가능해요.'
                      : '이미 사용중인 닉네임입니다.',
                  style: TextStyle(
                      color: !_isNicknameNotDuplicated! ||
                              !_isNicknameLengthNotExceeded
                          ? deleteButtonColor
                          : primaryColor,
                      fontWeight: FontWeight.w400,
                      fontSize: AppUtils.scaleSize(context, 14)),
                ))
            : Container(),
      ],
    );
  }
}
