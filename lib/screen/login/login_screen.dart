import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -230,
            child: Image(
              image: const AssetImage('assets/images/login_confetti_image.png'),
              width: screenWidth,
              height: screenHeight,
            ),
          ),
          Positioned(
            top: 100,
            child: Column(
              children: [
                Image(
                  image: const AssetImage('assets/images/login_cozy_image.png'),
                  width: screenWidth,
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 60,
                  width: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xffFEE500),
                  ),
                  child: const Center(
                    child: Text(
                      "카카오로 시작하기",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 13,
                ),
                Container(
                  height: 60,
                  width: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xff393939),
                  ),
                  child: const Center(
                    child: Text(
                      "Apple로 시작하기",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                const Text(
                  "로그인하시면 아래 내용에 동의하는 것으로 간주됩니다.",
                  style: TextStyle(
                    color: Color(0xff858998),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Row(
                  children: [
                    Text(
                      "개인정보처리방침",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 12,
                        color: Color(0xff858998),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      "이용약관",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 12,
                        color: Color(0xff858998),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            // top: 700,
            bottom: -135,
            left: -170,
            child: Image(
              image: const AssetImage('assets/images/login_group_image.png'),
              width: screenWidth + 250,
            ),
          ),
        ],
      ),
    );
  }
}
