import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/main_screen.dart';
import 'package:flutter/material.dart';

class UserDeleteModal extends StatefulWidget {
  const UserDeleteModal({super.key});

  @override
  State<UserDeleteModal> createState() => UserDeleteModalState();
}

class UserDeleteModalState extends State<UserDeleteModal> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 350, // TODO 화면 너비에 맞춘 width로 수정해야함
        height: 220,
        decoration: BoxDecoration(
          color: contentBoxTwoColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 30,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "정말 코지포맘 계정을\n삭제하시겠어요?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "회원을 탈퇴하면 모든 데이터가 소멸돼요.\n추후 같은 회원 정보일지라도 복구되지 않습니다.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1.5,
                  color: Color(0xff9397A4),
                  fontSize: 13,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  const Divider(
                    thickness: 1,
                    color: Color(
                      0xffD9D9D9,
                    ),
                    height: 2,
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
                          width: 56,
                          child: const Text(
                            '취소',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 60,
                        color: const Color(0xffD9D9D9),
                      ),
                      InkWell(
                        onTap: () {
                          print('탈퇴 api call?');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainScreen(),
                            ),
                          );
                        },
                        child: Container(
                          width: 56,
                          alignment: Alignment.center,
                          child: const Text(
                            '탈퇴',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
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
