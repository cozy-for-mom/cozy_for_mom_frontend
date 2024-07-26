import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/login/login_screen.dart';
import 'package:cozy_for_mom_frontend/service/user_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogoutModal extends StatefulWidget {
  const LogoutModal({super.key});

  @override
  State<LogoutModal> createState() => _LogoutModalState();
}

class _LogoutModalState extends State<LogoutModal> {
  var selected = false;
  late UserApiService userViewModel;
  late Map<String, dynamic> pregnantInfo;

  @override
  Widget build(BuildContext context) {
    userViewModel = Provider.of<UserApiService>(context, listen: true);
    return FutureBuilder(
      future: userViewModel.getUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          pregnantInfo = snapshot.data!;
        }
        if (!snapshot.hasData) {
          return const Center(
              child: CircularProgressIndicator(
            backgroundColor: primaryColor,
            color: Colors.white,
          ));
        }
        return Dialog(
          backgroundColor: Colors.white,
          elevation: 0.0,
          child: Container(
            height: 252,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
              child: Column(
                children: [
                  const Text(
                    "로그아웃",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${pregnantInfo['nickname']} ",
                        style: const TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14),
                      ),
                      const Text(
                        " 아이디가 로그아웃됩니다.",
                        style: TextStyle(
                            color: mainTextColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "해당 아이디는 간편 아이디로 계속 유지되며, 원하지 않을 경우 삭제 할 수 있습니다.",
                    style: TextStyle(
                      color: offButtonTextColor,
                      height: 1.3,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      await userViewModel.logOut();
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                          (Route<dynamic> route) => false, // 모든 이전 화면을 제거
                        );
                      }
                    },
                    child: Container(
                      height: 56,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(12)),
                      child: const Text(
                        "확인",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
