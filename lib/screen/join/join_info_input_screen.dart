import 'package:cozy_for_mom_frontend/screen/main_screen.dart';
import 'package:cozy_for_mom_frontend/service/user/device_token_manager.dart';
import 'package:cozy_for_mom_frontend/common/widget/delete_complite_alert.dart';
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
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                );
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
                  if (response['status'] == 201) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const MainScreen()),
                    );
                  } else {
                    DeleteCompleteAlertModal.showDeleteCompleteDialog(
                        context, '회원가입을 실패했습니다.');
                  }
                } catch (e) {
                  print('회원가입 중 에러 발생: $e');
                  DeleteCompleteAlertModal.showDeleteCompleteDialog(
                      context, '회원가입 중 에러가 발생했습니다.');
                }
              }
            },
            child: Padding(
              padding: EdgeInsets.only(right: screenWidth / 19),
              child: const Text('다음',
                  style: TextStyle(
                      color: navOffTextColor, // TODO 텍스트 조건 체크 후, 활성화
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
                setState(() {
                  _currentPage = page;
                });
              },
              children: const [
                MomEmailInputScreen(),
                MomNameBirthInputScreen(),
                MomNicknameInputScreen(),
                BabyDuedateInputScreen(),
                BabyFetalInfoScreen(),
                BabyGenderScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
