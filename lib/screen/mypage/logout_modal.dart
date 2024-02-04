import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:flutter/material.dart';

class LogoutModal extends StatefulWidget {
  const LogoutModal({super.key});

  @override
  State<LogoutModal> createState() => _LogoutModalState();
}

class _LogoutModalState extends State<LogoutModal> {
  var selected = false;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "cozyformom11 ",
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ), // TODO 산모 닉네임으로 수정해야함.

                  Text("아이디가 로그아웃됩니다."),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "해당 아이디는 간편 아이디로 계속 유지되며, 원하지 않을 경우 삭제 할 수 있습니다.",
                style: TextStyle(
                  color: Color(0xff858998),
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(
                color: Color(0xffE1E1E7),
                thickness: 2,
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  children: [
                    InkWell(
                      child: Image(
                        image: AssetImage(
                          selected
                              ? 'assets/images/icons/logout_agree_active.png'
                              : 'assets/images/icons/logout_agree_inactive.png',
                        ),
                        width: 20,
                        height: 20,
                      ),
                      onTap: () {
                        setState(() {
                          selected = !selected;
                        });
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "간편로그인 (cozyformom11) 삭제",
                      style: TextStyle(
                        color: Color(0xff858998),
                      ),
                    ), // TODO 산모 닉네임으로 수정해야함.
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  print(selected);
                  print("확인 버튼 클릭"); // TODO 확인 api 호출
                },
                child: Container(
                  width: 350, // TODO
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
  }
}
