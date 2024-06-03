import 'package:cozy_for_mom_frontend/screen/join/join_info_input_screen.dart';
import 'package:cozy_for_mom_frontend/screen/join/join_input_data.dart';
import 'package:cozy_for_mom_frontend/screen/main_screen.dart';
import 'package:cozy_for_mom_frontend/service/user/device_token_manager.dart';
import 'package:cozy_for_mom_frontend/service/user/oauth_api_service.dart';
import 'package:cozy_for_mom_frontend/service/user/token_manager.dart'
    as TokenManager;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final tokenManager = TokenManager.TokenManager();
  final oauthApiService = OauthApiService();
  late Future<String?> accessToken;

  @override
  void initState() {
    super.initState();
    accessToken = tokenManager.getToken();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final deviceToken = DeviceTokenManager().deviceToken ?? 'Unknown';
    print(deviceToken);

    return Scaffold(
        body: FutureBuilder<String?>(
            future: accessToken,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                print('wating');
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                handleUserType(context);
                print('circular');
                return const Center(
                    child: CircularProgressIndicator()); // 결과 대기 중 표시
              } else {
                print('success');
                return buildLoginScreen(screenWidth, screenHeight);
              }
            }));
  }

  void handleUserType(BuildContext context) async {
    final userType = await tokenManager.getUserType();
    if (userType == UserType.guest) {
      // UserType이 guest이면 회원가입 페이지로 이동
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const JoinInfoInputScreen()));
    } else {
      // UserType이 user이면 MainScreen으로 이동
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainScreen()));
    }
  }

  Widget buildLoginScreen(double screenWidth, double screenHeight) {
    final joinInputData = Provider.of<JoinInputData>(context);
    // 로그인 스크린 UI 구성
    return Stack(
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
              InkWell(
                onTap: () async {
                  UserType userType = await kakaoLogin();
                  joinInputData.setOauthType(OauthType.kakao);

                  if (!mounted) return; // 위젯이 여전히 활성 상태인지 확인

                  if (userType == UserType.guest) {
                    // UserType이 guest이면 회원가입 페이지로 이동
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const JoinInfoInputScreen()));
                  } else {
                    // UserType이 user이면 MainScreen으로 이동
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const MainScreen()));
                  }
                },
                child: Container(
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
              ),
              const SizedBox(
                height: 13,
              ),
              InkWell(
                onTap: () async {
                  UserType userType = await appleLogin();
                  joinInputData.setOauthType(OauthType.apple);

                  if (!mounted) return; // 위젯이 여전히 활성 상태인지 확인

                  if (userType == UserType.guest) {
                    // UserType이 guest이면 회원가입 페이지로 이동
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const JoinInfoInputScreen()));
                  } else {
                    // UserType이 user이면 MainScreen으로 이동
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const MainScreen()));
                  }
                },
                child: Container(
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
    );
  }

  Future<UserType> kakaoLogin() async {
    late String kakaoAccessToken;
    if (await isKakaoTalkInstalled()) {
      try {
        var res = await UserApi.instance.loginWithKakaoTalk();
        kakaoAccessToken = res.accessToken;
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');
        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          throw Exception(error.code); // TODO fix
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          var res = await UserApi.instance.loginWithKakaoAccount();
          kakaoAccessToken = res.accessToken;
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        var res = await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
        kakaoAccessToken = res.accessToken;
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
    return oauthApiService.authenticateByOauth(
        OauthType.kakao, kakaoAccessToken);
  }

  Future<UserType> appleLogin() async {
    late String appleAuthCode;
    try {
      var res = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      // print(res.identityToken);
      print('authorizationCode >>>>>>>> ${res.authorizationCode}');

      // 애플 인증 코드 저장
      appleAuthCode = res.authorizationCode;
    } catch (e) {
      print('애플로그인 실패: $e');
      if (e is PlatformException && e.code == 'CANCELED') {
        throw Exception(e.code); // TODO fix
      }
    }
    return oauthApiService.authenticateByOauth(OauthType.apple, appleAuthCode);
  }
}
