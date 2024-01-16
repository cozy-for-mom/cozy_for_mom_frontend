import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/join/mom_email.dart';
import 'package:cozy_for_mom_frontend/screen/join/mom_name_birth.dart';
import 'package:cozy_for_mom_frontend/screen/join/mom_nickname.dart';
import 'package:cozy_for_mom_frontend/screen/join/join_input_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const JoinInfoInputScreen(),
      theme: ThemeData(
        colorScheme: ColorScheme.light(),
        fontFamily: 'Pretendard',
      ),
    );
  }
}
// TODO main.dart의 하위 페이지로 연동 후, 위의 코드 삭제

class JoinInfoInputScreen extends StatefulWidget {
  const JoinInfoInputScreen({super.key});

  @override
  State<JoinInfoInputScreen> createState() => _JoinInfoInputScreenState();
}

class _JoinInfoInputScreenState extends State<JoinInfoInputScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPage = 7;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider(
      create: (context) =>
          JoinInputData(), // TODO main.dart의 하위 페이지로 연동 후, ChangeNotifierProvider 코드 삭제
      child: Scaffold(
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
                // 첫 페이지에서 뒤로 갈 때의 특별한 동작을 수행
                print('첫 페이지입니다.');
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
              onTap: () {
                if (_currentPage < _totalPage - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                  );
                } else {
                  // 페이지가 끝났을 때 다른 작업 수행
                  print('마지막 페이지입니다.');
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
              child: SizedBox(
                width: screenWidth - 40,
                child: LinearProgressIndicator(
                  value: (_currentPage + 1) / _totalPage,
                  backgroundColor: mainLineColor,
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(20),
                  minHeight: 6.0,
                ),
              ),
            ),
            Positioned.fill(
              top: 0,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
