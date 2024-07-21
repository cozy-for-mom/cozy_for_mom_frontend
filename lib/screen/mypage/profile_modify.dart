import 'package:cozy_for_mom_frontend/common/widget/delete_modal.dart';
import 'package:cozy_for_mom_frontend/common/widget/select_bottom_modal.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/logout_modal.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/mypage_screen.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/user_delete_screen.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/service/user_api.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/profile_info_form.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cozy_for_mom_frontend/service/image_api.dart';
import 'package:camera/camera.dart';
import 'package:intl/intl.dart';

class MomProfileModify extends StatefulWidget {
  const MomProfileModify({super.key});

  @override
  State<MomProfileModify> createState() => _MomProfileModifyState();
}

class _MomProfileModifyState extends State<MomProfileModify> {
  late UserApiService userViewModel;
  late Map<String, dynamic> pregnantInfo;
  late TextEditingController introduceController;
  final momInfoType = ["이름", "닉네임", "이메일", "생년월일"];
  bool _isSuffixVisible = false;
  Map<String, TextEditingController> controllers = {};
  String? imageUrl;
  CameraController? cameraController;
  ImageApiService imageApiService = ImageApiService();

  Future<void> initCameraController() async {
    // 사용 가능한 카메라 목록을 가져옵니다.
    final cameras = await availableCameras();
    // 일반적으로 첫 번째 카메라(후면 카메라)를 사용합니다.
    final firstCamera = cameras.first;
    // 카메라 컨트롤러를 초기화합니다.
    cameraController = CameraController(
      firstCamera,
      ResolutionPreset.high, // 높은 해상도로 설정
    );
    // 컨트롤러를 초기화합니다.
    await cameraController!.initialize();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controllers.values.forEach((controller) {
      controller.dispose();
    });
    super.dispose();
  }

  Future<void> takePhoto() async {
    // TODO 카메라 연동
    // if (cameraController == null || !cameraController!.value.isInitialized) {
    //   print('Camera is not initialized');
    //   return;
    // }
    // // 카메라 프리뷰가 실행 중인지 확인
    // if (cameraController!.value.isTakingPicture) {
    //   // 이미 촬영 중인 경우
    //   return;
    // }
    // try {
    //   // 사진을 찍습니다.
    //   final image = await cameraController!.takePicture();
    //   Navigator.pop(context);
    //   setState(() {
    //     imageUrl = imageApiService.uploadImage(XFile(image.path));
    //   });
    // } catch (e) {
    //   print('Failed to take a picture: $e');
    // }
  }

  String sendFormatUsingRegex(String date) {
    return date.replaceAll(RegExp(r'\.'), '-');
  }

  String receiveFormatUsingRegex(String date) {
    return date.replaceAll(RegExp(r'\-'), '.');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    introduceController = TextEditingController();
    userViewModel = Provider.of<UserApiService>(context, listen: true);

    return FutureBuilder(
      future: userViewModel.getUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          pregnantInfo = snapshot.data!;
          introduceController.text = pregnantInfo['introduce'];
          imageUrl = imageUrl ?? pregnantInfo['imageUrl'];
          Map<String, TextEditingController> controllers = {
            '이름': TextEditingController(text: pregnantInfo['name']),
            '닉네임': TextEditingController(text: pregnantInfo['nickname']),
            '이메일': TextEditingController(text: pregnantInfo['email']),
            '생년월일': TextEditingController(
                text: receiveFormatUsingRegex(pregnantInfo['birth']))
          };
          return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: backgroundColor,
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  elevation: 0,
                  backgroundColor: backgroundColor,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.zero,
                    title: Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 10),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          const SizedBox(width: 100),
                          const Text('프로필 수정',
                              style: TextStyle(
                                  color: mainTextColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18)),
                        ],
                      ),
                    ),
                  ),
                  leading: Container(),
                  actions: [
                    InkWell(
                      child: Container(
                        margin: const EdgeInsets.only(right: 20, bottom: 23),
                        alignment: Alignment.center,
                        width: 60,
                        height: 20,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(33),
                        ),
                        child: const Text(
                          '완료',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12),
                        ),
                      ),
                      onTap: () {
                        userViewModel.modifyUserProfile(
                            controllers['이름']!.text,
                            controllers['닉네임']!.text,
                            introduceController.text,
                            imageUrl,
                            sendFormatUsingRegex(controllers['생년월일']!.text),
                            controllers['이메일']!.text);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyPage()),
                        );
                      },
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 140,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 10,
                          left: 145,
                          child: imageUrl == null
                              ? const Image(
                                  image: AssetImage(
                                      "assets/images/icons/momProfile.png"),
                                  width: 100,
                                  height: 100)
                              : ClipOval(
                                  // 원형
                                  child: Image.network(
                                    imageUrl!,
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 100,
                                  ),
                                ),
                        ),
                        Positioned(
                          top: 181 - 109,
                          left: 229,
                          child: InkWell(
                            onTap: () async {
                              showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (BuildContext context) {
                                  return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18.0),
                                      child: SelectBottomModal(
                                          selec1: '직접 찍기',
                                          selec2: '앨범에서 선택',
                                          tap1: () {
                                            takePhoto;
                                          },
                                          tap2: () async {
                                            Navigator.pop(context);
                                            final selectedImage =
                                                await ImagePicker().pickImage(
                                                    source:
                                                        ImageSource.gallery);
                                            if (selectedImage != null) {
                                              final selectedImageUrl =
                                                  await imageApiService
                                                      .uploadImage(
                                                          selectedImage);
                                              setState(() {
                                                imageUrl = selectedImageUrl;
                                              });
                                            } else {
                                              print('No image selected.');
                                            }
                                          }));
                                },
                              );
                            },
                            child: const Image(
                              image: AssetImage(
                                  "assets/images/icons/circle_pen.png"),
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: screenWidth - 40,
                    height: 96,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "소개",
                          style: TextStyle(
                              color: offButtonTextColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: introduceController,
                          textAlign: TextAlign.start,
                          cursorColor: primaryColor,
                          cursorHeight: 17,
                          cursorWidth: 1.5,
                          maxLength: 30,
                          style: const TextStyle(
                              color: mainTextColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                          decoration: InputDecoration(
                            counterText: '',
                            counterStyle: const TextStyle(
                                color: offButtonTextColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                            border: InputBorder.none,
                            hintText: "자기소개를 입력해주세요",
                            hintStyle: const TextStyle(
                                color: beforeInputColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                            suffixIcon: introduceController.text.isNotEmpty &&
                                    _isSuffixVisible
                                ? IconButton(
                                    icon: Image.asset(
                                      'assets/images/icons/text_delete.png',
                                      width: 16,
                                      height: 16,
                                    ),
                                    onPressed: () {
                                      introduceController.clear();
                                    },
                                  )
                                : null,
                          ),
                          onTap: () {
                            setState(() {
                              _isSuffixVisible = true;
                            });
                          },
                        ),
                        Container(
                          width: screenWidth - 40,
                          height: 1,
                          color: mainLineColor,
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      String type = momInfoType[index];
                      String hint = '';
                      if (type == '이름') {
                        hint = '이름을 입력해주세요.';
                        // controllers[type]!.text = pregnantInfo['name'];
                      } else if (type == '닉네임') {
                        hint = '8자 이내로 입력해주세요.';
                        // controllers[type]!.text = pregnantInfo['nickname'];
                      } else if (type == '이메일') {
                        hint = 'cozy@cozy.com';
                        // controllers[type]!.text = pregnantInfo['email'];
                      } else {
                        hint = 'YYYY.MM.DD';
                        // controllers[type]!.text = pregnantInfo['birth'];
                      }
                      return Column(
                        children: [
                          ProfileInfoForm(
                            title: type,
                            hint: hint,
                            controller: controllers[type],
                          ),
                          const SizedBox(height: 24),
                        ],
                      );
                    },
                    childCount: momInfoType.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    width: 132,
                    height: 21,
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext buildContext) {
                                    return const LogoutModal();
                                  },
                                );
                              },
                              child: const Text(
                                '로그아웃',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 1,
                              height: 11,
                              color: primaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserDeleteScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                '회원탈퇴',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: primaryColor,
              color: Colors.white,
            ),
          );
        }
      },
    );
  }
}
