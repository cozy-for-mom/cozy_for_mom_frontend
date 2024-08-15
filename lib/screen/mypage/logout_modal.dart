import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/login/login_screen.dart';
import 'package:cozy_for_mom_frontend/service/user_api.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
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
            height: AppUtils.scaleSize(context, 252),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  top: AppUtils.scaleSize(context, 30),
                  left: AppUtils.scaleSize(context, 20),
                  right: AppUtils.scaleSize(context, 20)),
              child: Column(
                children: [
                  Text(
                    "로그아웃",
                    style: TextStyle(
                      fontSize: AppUtils.scaleSize(context, 20),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: AppUtils.scaleSize(context, 15),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${pregnantInfo['nickname']} ",
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: AppUtils.scaleSize(context, 14)),
                      ),
                      Text(
                        " 아이디가 로그아웃됩니다.",
                        style: TextStyle(
                            color: mainTextColor,
                            fontWeight: FontWeight.w500,
                            fontSize: AppUtils.scaleSize(context, 14)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: AppUtils.scaleSize(context, 10),
                  ),
                  Text(
                    "해당 아이디는 간편 아이디로 계속 유지되며, 원하지 않을 경우 삭제 할 수 있습니다.",
                    style: TextStyle(
                      color: offButtonTextColor,
                      height: AppUtils.scaleSize(context, 1.3),
                      fontWeight: FontWeight.w500,
                      fontSize: AppUtils.scaleSize(context, 12),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: AppUtils.scaleSize(context, 10),
                  ),
                  SizedBox(
                    height: AppUtils.scaleSize(context, 20),
                  ),
                  InkWell(
                    onTap: () async {
                      Navigator.pop(context);
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
                      height: AppUtils.scaleSize(context, 56),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(12)),
                      child: Text(
                        "확인",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: AppUtils.scaleSize(context, 16),
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
