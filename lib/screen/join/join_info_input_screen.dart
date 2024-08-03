import 'dart:async';

import 'package:cozy_for_mom_frontend/screen/main_screen.dart';
import 'package:cozy_for_mom_frontend/screen/welcome/welcome_screen.dart';
import 'package:cozy_for_mom_frontend/service/user/device_token_manager.dart';
import 'package:cozy_for_mom_frontend/service/user/token_manager.dart'
    as TokenManager;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/join/mom_email.dart';
import 'package:cozy_for_mom_frontend/screen/join/mom_name_birth.dart';
import 'package:cozy_for_mom_frontend/screen/join/mom_nickname.dart';
import 'package:cozy_for_mom_frontend/screen/join/join_input_data.dart';
import 'package:cozy_for_mom_frontend/screen/join/baby_duedate.dart';
import 'package:cozy_for_mom_frontend/screen/join/baby_fetal_info.dart';
import 'package:cozy_for_mom_frontend/screen/join/baby_gender_name.dart';
import 'package:cozy_for_mom_frontend/model/user_join_model.dart';
import 'package:cozy_for_mom_frontend/service/user/join_api_service.dart';
import 'package:cozy_for_mom_frontend/screen/login/login_screen.dart';

class JoinInfoInputScreen extends StatefulWidget {
  const JoinInfoInputScreen({super.key});

  @override
  State<JoinInfoInputScreen> createState() => _JoinInfoInputScreenState();
}

class _JoinInfoInputScreenState extends State<JoinInfoInputScreen> {
  final PageController _pageController = PageController();
  final joinApiService = JoinApiService();
  int _currentPage = 0;
  final int _totalPage = 6;
  final tokenManager = TokenManager.TokenManager();
  bool _isEmailValid = false;
  bool _isNameAndBirthValid = false;
  bool _isNicknameValid = false;
  bool _isDueAtAndLastPeriodAtValid = false;
  final bool _isFetalInfoValid = true;
  bool _isBabyNameAndGenderValid = false;

  void _updateEmailValidity(bool isValid) {
    if (mounted) {
      setState(() {
        _isEmailValid = isValid;
      });
    }
  }

  void _updateNameAndBirthValidity(bool isValid) {
    if (mounted) {
      setState(() {
        _isNameAndBirthValid = isValid;
      });
    }
  }

  void _updateNicknameValidity(bool isValid) {
    if (mounted) {
      setState(() {
        _isNicknameValid = isValid;
      });
    }
  }

  void _updateDueAtAndLastPeriodAtValidity(bool isValid) {
    if (mounted) {
      setState(() {
        _isDueAtAndLastPeriodAtValid = isValid;
      });
    }
  }

  void _updateBabyNameAndGenderValidity(bool isValid) {
    if (mounted) {
      setState(() {
        _isBabyNameAndGenderValid = isValid;
      });
    }
  }

  void _nextPage() {
    if ((_currentPage == 0 && _isEmailValid) ||
        (_currentPage == 1 && _isNameAndBirthValid) ||
        (_currentPage == 2 && _isNicknameValid) ||
        (_currentPage == 3 && _isDueAtAndLastPeriodAtValid) ||
        (_currentPage == 4 && _isFetalInfoValid) ||
        (_currentPage == 5 && _isBabyNameAndGenderValid)) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final joinInputData = Provider.of<JoinInputData>(context);
    final deviceToken = DeviceTokenManager().deviceToken ?? 'Unknown';

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (_currentPage > 0) {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
              );
            } else {
              // 첫 페이지에서 뒤로 갈 때는 다시 로그인 페이지로 이동
              tokenManager.deleteToken();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            }
          },
        ),
        title: const Text('회원가입',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 18)),
        actions: [
          InkWell(
            onTap: () async {
              if (_currentPage < _totalPage - 1) {
                ((_currentPage == 0 && _isEmailValid) ||
                        (_currentPage == 1 && _isNameAndBirthValid) ||
                        (_currentPage == 2 &&
                            _isNicknameValid) || // TODO 닉네임 활성화 수정 필요
                        (_currentPage == 3 && _isDueAtAndLastPeriodAtValid) ||
                        (_currentPage == 4 && _isFetalInfoValid) ||
                        (_currentPage == 5 && _isBabyNameAndGenderValid))
                    ? _nextPage()
                    : null;
              } else {
                print('마지막 페이지입니다.');
                UserInfo userInfo = UserInfo(
                  oauthType: joinInputData.oauthType.name,
                  name: joinInputData.name,
                  nickname: joinInputData.nickname,
                  birth: joinInputData.birth.replaceAll('.', '-'),
                  email: joinInputData.email,
                  deviceToken: deviceToken,
                );
                List<Baby> babies =
                    List.generate(joinInputData.birthNames.length, (index) {
                  return Baby(
                      name: joinInputData.birthNames[index],
                      gender: joinInputData.genders[index]);
                });
                BabyInfo babyInfo = BabyInfo(
                    dueAt: joinInputData.dueDate.replaceAll('.', '-'),
                    lastPeriodAt:
                        joinInputData.laseMensesDate.replaceAll('.', '-'),
                    babies: babies);
                try {
                  final response =
                      await joinApiService.signUp(userInfo, babyInfo);
                  if (mounted && response['status'] == 201) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const WelcomeScreen()),
                    );
                  } else {
                    print('회원 가입을 실패했습니다.'); // TODO 회원가입 실패 알림 메시지 보여주기?
                  }
                } catch (e) {
                  print('회원가입 중 에러 발생: $e');
                }
              }
            },
            child: Padding(
              padding: EdgeInsets.only(right: screenWidth / 19),
              child: Text('다음',
                  style: TextStyle(
                      color: ((_currentPage == 0 && _isEmailValid) ||
                              (_currentPage == 1 && _isNameAndBirthValid) ||
                              (_currentPage == 2 && _isNicknameValid) ||
                              (_currentPage == 3 &&
                                  _isDueAtAndLastPeriodAtValid) ||
                              (_currentPage == 4 && _isFetalInfoValid) ||
                              (_currentPage == 5 && _isBabyNameAndGenderValid))
                          ? Colors.black
                          : navOffTextColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 18)),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: 43,
            left: 20,
            right: 20,
            child: LinearProgressIndicator(
              value: (_currentPage + 1) / _totalPage,
              backgroundColor: mainLineColor,
              color: primaryColor,
              borderRadius: BorderRadius.circular(20),
              minHeight: 6.0,
            ),
          ),
          Positioned.fill(
            top: 43,
            left: 0,
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                if (mounted) {
                  setState(() {
                    _currentPage = page;
                  });
                }
              },
              children: [
                MomEmailInputScreen(updateValidity: _updateEmailValidity),
                MomNameBirthInputScreen(
                    updateValidity: _updateNameAndBirthValidity),
                MomNicknameInputScreen(updateValidity: _updateNicknameValidity),
                BabyDuedateInputScreen(
                    updateValidity: _updateDueAtAndLastPeriodAtValidity),
                const BabyFetalInfoScreen(),
                BabyGenderBirthNameScreen(
                    updateValidity: _updateBabyNameAndGenderValidity),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
