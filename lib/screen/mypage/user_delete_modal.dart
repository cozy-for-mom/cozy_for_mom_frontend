import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/login/login_screen.dart';
import 'package:cozy_for_mom_frontend/service/user/join_api_service.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';

class UserDeleteModal extends StatefulWidget {
  final String reason;
  const UserDeleteModal({super.key, required this.reason});

  @override
  State<UserDeleteModal> createState() => UserDeleteModalState();
}

class UserDeleteModalState extends State<UserDeleteModal> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      child: Container(
        width: screenWidth - AppUtils.scaleSize(context, 40),
        height: AppUtils.scaleSize(context, 220),
        decoration: BoxDecoration(
          color: contentBoxTwoColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: AppUtils.scaleSize(context, 30),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "정말 코지포맘 계정을\n삭제하시겠어요?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: AppUtils.scaleSize(context, 1.5),
                  fontWeight: FontWeight.w600,
                  fontSize: AppUtils.scaleSize(context, 16),
                ),
              ),
              SizedBox(
                height: AppUtils.scaleSize(context, 15),
              ),
              Text(
                "회원을 탈퇴하면 모든 데이터가 소멸돼요.\n추후 같은 회원 정보일지라도 복구되지 않습니다.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: AppUtils.scaleSize(context, 1.5),
                  color: const Color(0xff9397A4),
                  fontWeight: FontWeight.w500,
                  fontSize: AppUtils.scaleSize(context, 13),
                ),
              ),
              SizedBox(
                height: AppUtils.scaleSize(context, 20),
              ),
              Column(
                children: [
                  Divider(
                    thickness: 1,
                    color: const Color(
                      0xffD9D9D9,
                    ),
                    height: AppUtils.scaleSize(context, 2),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: AppUtils.scaleSize(context, 56),
                          child: Text(
                            '취소',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: AppUtils.scaleSize(context, 14),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: AppUtils.scaleSize(context, 60),
                        color: const Color(0xffD9D9D9),
                      ),
                      InkWell(
                        onTap: () async {
                          await JoinApiService()
                              .signOut(context, widget.reason);
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
                          width: AppUtils.scaleSize(context, 56),
                          alignment: Alignment.center,
                          child: Text(
                            '탈퇴',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: AppUtils.scaleSize(context, 14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
