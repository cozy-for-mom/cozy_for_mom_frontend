import 'dart:math';

import 'package:cozy_for_mom_frontend/common/widget/delete_modal.dart';
import 'package:cozy_for_mom_frontend/common/widget/select_bottom_modal.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/logout_modal.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/user_delete_screen.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/service/user_api.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/profile_info_form.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cozy_for_mom_frontend/service/image_api.dart';

class MomProfileModify extends StatefulWidget {
  final Function(bool)? onUpdate;
  const MomProfileModify({super.key, this.onUpdate});

  @override
  State<MomProfileModify> createState() => _MomProfileModifyState();
}

class _MomProfileModifyState extends State<MomProfileModify> {
  late Map<String, dynamic> pregnantInfo;
  late TextEditingController introduceController;
  late Map<String, TextEditingController> controllers;

  final momInfoType = ["이름", "닉네임"];

  bool _isSuffixVisible = false;
  bool _isNicknameValid = false;
  String? userProfileImageUrl;
  UserApiService userApiService = UserApiService();
  ImageApiService imageApiService = ImageApiService();

  @override
  void initState() {
    super.initState();
    introduceController = TextEditingController();
    controllers = {
      '이름': TextEditingController(),
      '닉네임': TextEditingController(),
    };
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      var pregnantInfo = await userApiService.getUserInfo(context);
      introduceController.text = pregnantInfo['introduce'];
      controllers['이름']!.text = pregnantInfo['name'];
      controllers['닉네임']!.text = pregnantInfo['nickname'];
      userProfileImageUrl = pregnantInfo['imageUrl'];
      setState(() {
        _isNicknameValid = true;
      }); // UI 갱신
    } catch (e) {
      print('Data loading failed: $e');
    }
  }

  @override
  void dispose() {
    controllers.values.forEach((controller) {
      controller.dispose();
    });
    super.dispose();
  }

  void _updateNicknameValidity(bool isValid) {
    if (mounted) {
      setState(() {
        _isNicknameValid = isValid;
      });
    }
  }

  void _updateNameValidity(bool isValid) {
    if (mounted) {
      setState(() {});
    }
  }

  bool areAllFieldsFilled(Map<String, TextEditingController> controllers) {
    return controllers.values.every((controller) => controller.text.isNotEmpty);
  }

  Future<XFile?> showImageSelectModal() async {
    XFile? selectedImage;

    String? choice = await showModalBottomSheet<String>(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        context: context,
        builder: (BuildContext context) {
          return SelectBottomModal(
            selec1: '직접 찍기',
            selec2: '앨범에서 선택',
            tap1: () {
              Navigator.pop(context, 'camera');
            },
            tap2: () {
              Navigator.pop(context, 'gallery');
            },
          );
        });

    if (choice != null) {
      ImageSource source =
          choice == 'camera' ? ImageSource.camera : ImageSource.gallery;
      selectedImage = await ImagePicker().pickImage(source: source);
    }

    return selectedImage;
  }

  Future<dynamic> showSelectModal() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final paddingValue = isTablet ? 30.w : 20.w;

    return showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: isTablet? 214.w : 280.w,
          child: Column(
            children: [
              Container(
                width: screenWidth - 2 * paddingValue,
                height: min(172.w, 272),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.w),
                  color: Colors.white,
                ),
                child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ListTile(
                          title: Center(
                              child: Text(
                            '직접 찍기',
                            style: TextStyle(
                              color: mainTextColor,
                              fontWeight: FontWeight.w600,
                              fontSize: min(16.sp, 26),
                            ),
                          )),
                          onTap: () async {
                            Navigator.pop(context);
                            final selectedImage = await ImagePicker()
                                .pickImage(source: ImageSource.camera);
                            if (mounted && selectedImage != null) {
                              final imageUrl = await imageApiService
                                  .uploadImage(context, selectedImage);
                              setState(() {
                                userProfileImageUrl = imageUrl;
                              });
                            } else {
                              print('No image selected.');
                            }
                          },
                        ),
                        ListTile(
                          title: Center(
                              child: Text(
                            '앨범에서 선택',
                            style: TextStyle(
                              color: mainTextColor,
                              fontWeight: FontWeight.w600,
                              fontSize: min(16.sp, 26),
                            ),
                          )),
                          onTap: () async {
                            Navigator.pop(context);
                            final selectedImage = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            if (mounted && selectedImage != null) {
                              final imageUrl = await imageApiService
                                  .uploadImage(context, selectedImage);
                              setState(() {
                                userProfileImageUrl = imageUrl;
                              });
                            } else {
                              print('No image selected.');
                            }
                          },
                        ),
                        ListTile(
                          title: Center(
                              child: Text(
                            '삭제하기',
                            style: TextStyle(
                              color: mainTextColor,
                              fontWeight: FontWeight.w600,
                              fontSize: min(16.sp, 26),
                            ),
                          )),
                          onTap: () async {
                            Navigator.pop(context);
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext buildContext) {
                                return DeleteModal(
                                  text: '등록된 사진을 삭제하시겠습니까?\n이 과정은 복구할 수 없습니다.',
                                  title: '사진이',
                                  tapFunc: () {
                                    setState(() {
                                      userProfileImageUrl = null;
                                    });

                                    return Future.value();
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ]),
                ),
              ),
              SizedBox(
                height: 15.w,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: screenWidth - 2 * paddingValue,
                  height: min(56.w, 96),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.w),
                    color: const Color(0xffC2C4CB),
                  ),
                  child: Center(
                      child: Text(
                    "취소",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: min(16.sp, 26),
                    ),
                  )),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final paddingValue = isTablet ? 30.w : 20.w;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: backgroundColor,
            scrolledUnderElevation: 0,
            title: Text('프로필 수정',
                style: TextStyle(
                    color: mainTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: min(18.sp, 28))),
            leading: IconButton(
              icon: Image(
                image: const AssetImage('assets/images/icons/back_ios.png'),
                width: min(34.w, 44),
                height: min(34.w, 44),
                color: mainTextColor,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: [
              InkWell(
                child: Center(
                  child: Container(
                    margin: EdgeInsets.only(
                      right: 10.w,
                    ),
                    alignment: Alignment.center,
                    width: min(53.w, 93),
                    height: min(29.w, 49),
                    decoration: BoxDecoration(
                      color: areAllFieldsFilled(controllers) &&
                              _isNicknameValid
                          ? primaryColor
                          : induceButtonColor,
                      borderRadius: BorderRadius.circular(33.w),
                    ),
                    child: Text(
                      '완료',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: min(12.sp, 22)),
                    ),
                  ),
                ),
                onTap: () async {
                  if (areAllFieldsFilled(controllers) &&
                      _isNicknameValid
                      ) {
                    await userApiService.modifyUserProfile(
                        context,
                        controllers['이름']!.text,
                        controllers['닉네임']!.text,
                        introduceController.text,
                        userProfileImageUrl);
                    if (mounted) {
                      Navigator.pop(context, true);
                    }
                  }
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: InkWell(
              onTap: () async {
                if (userProfileImageUrl == null) {
                  final selectedImage = await showImageSelectModal();
                  if (mounted && selectedImage != null) {
                    final imageUrl = await imageApiService.uploadImage(
                        context, selectedImage);
                    setState(() {
                      userProfileImageUrl = imageUrl;
                    });
                  } else {
                    print('No image selected.');
                  }
                } else {
                  showSelectModal();
                }
              },
              child: SizedBox(
                height: min(140.w, 280),
                child: Stack(
                  children: [
                    Positioned(
                      top: isTablet ? 30.h : 10.h,
                      left: 145.w,
                      child: userProfileImageUrl == null
                          ? Image(
                              image: const AssetImage(
                                  "assets/images/icons/momProfile.png"),
                              width: min(100.w, 200),
                              height: min(100.w, 200),
                            )
                          : ClipOval(
                              // 원형
                              child: Image.network(
                                userProfileImageUrl!,
                                fit: BoxFit.cover,
                                width: min(100.w, 200),
                                height: min(100.w, 200),
                              ),
                            ),
                    ),
                    Positioned(
                      top: isTablet ? 122.h : 72.h,
                      left: 249.w - paddingValue,
                      child: Image(
                        image: const AssetImage(
                            "assets/images/icons/circle_pen.png"),
                        width: min(24.w, 48),
                        height: min(24.w, 48),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: paddingValue),
              width: screenWidth - 2 * paddingValue,
              height: min(96.w, 146),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "소개",
                    style: TextStyle(
                        color: offButtonTextColor,
                        fontWeight: FontWeight.w600,
                        fontSize: min(14.sp, 24)),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: introduceController,
                    textAlign: TextAlign.start,
                    cursorColor: primaryColor,
                    cursorHeight: min(16.sp, 26),
                    cursorWidth: 1.5.w,
                    maxLength: 30,
                    style: TextStyle(
                        color: mainTextColor,
                        fontWeight: FontWeight.w500,
                        fontSize: min(16.sp, 26)),
                    decoration: InputDecoration(
                      counterText: '',
                      counterStyle: TextStyle(
                          color: offButtonTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: min(14.sp, 24)),
                      border: InputBorder.none,
                      hintText: "자기소개를 입력해주세요",
                      hintStyle: TextStyle(
                          color: beforeInputColor,
                          fontWeight: FontWeight.w500,
                          fontSize: min(16.sp, 26)),
                      suffixIcon: introduceController.text.isNotEmpty &&
                              _isSuffixVisible
                          ? IconButton(
                              icon: Image.asset(
                                'assets/images/icons/text_delete.png',
                                width: min(16.w, 26),
                                height: min(16.w, 26),
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
                    width: screenWidth - 2 * paddingValue,
                    height: 1.w,
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
                } else if (type == '닉네임') {
                  hint = '8자 이내로 입력해주세요.';
                }
                return Column(
                  children: [
                    ProfileInfoForm(
                        title: type,
                        hint: hint,
                        controller: controllers[type],
                        updateValidity: type == '닉네임'
                            ? _updateNicknameValidity
                            : _updateNameValidity),
                    SizedBox(height: 24.w),
                  ],
                );
              },
              childCount: momInfoType.length,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: isTablet? screenHeight * (1/6) : screenHeight * (1/4)),  // TODO 아이폰 체크
              width: 132.w,
              height: 21.w,
              child: Row(
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
                    child: Text(
                      '로그아웃',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: min(14.sp, 24),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Container(
                    width: 1.w,
                    height: 11.w,
                    color: primaryColor,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserDeleteScreen(),
                        ),
                      );
                    },
                    child: Text(
                      '회원탈퇴',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: min(14.sp, 24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
