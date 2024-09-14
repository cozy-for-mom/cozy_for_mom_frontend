import 'package:cozy_for_mom_frontend/common/widget/delete_modal.dart';
import 'package:cozy_for_mom_frontend/common/widget/select_bottom_modal.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/logout_modal.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/user_delete_screen.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
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

  final momInfoType = ["이름", "닉네임", "이메일", "생년월일"];

  bool _isSuffixVisible = false;
  bool _isEmailValid = false;
  bool _isNicknameValid = false;
  bool _isBirthValid = false;
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
      '이메일': TextEditingController(),
      '생년월일': TextEditingController(),
    };
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      var pregnantInfo = await userApiService.getUserInfo(context);
      introduceController.text = pregnantInfo['introduce'];
      controllers['이름']!.text = pregnantInfo['name'];
      controllers['닉네임']!.text = pregnantInfo['nickname'];
      controllers['이메일']!.text = pregnantInfo['email'];
      controllers['생년월일']!.text =
          receiveFormatUsingRegex(pregnantInfo['birth']);
      userProfileImageUrl = pregnantInfo['imageUrl'];
      setState(() {
        _isNicknameValid = true;
        _isEmailValid = true;
        _isBirthValid = true;
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

  String sendFormatUsingRegex(String date) {
    return date.replaceAll(RegExp(r'\.'), '-');
  }

  String receiveFormatUsingRegex(String date) {
    return date.replaceAll(RegExp(r'\-'), '.');
  }

  void _updateEmailValidity(bool isValid) {
    if (mounted) {
      setState(() {
        _isEmailValid = isValid;
      });
    }
  }

  void _updateNicknameValidity(bool isValid) {
    if (mounted) {
      setState(() {
        _isNicknameValid = isValid;
      });
    }
  }

  void _updateBirthValidity(bool isValid) {
    if (mounted) {
      setState(() {
        _isBirthValid = isValid;
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
    return showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: AppUtils.scaleSize(context, 272 + 15),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: AppUtils.scaleSize(context, 8)),
                width: screenWidth - AppUtils.scaleSize(context, 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Center(
                  child: Column(children: <Widget>[
                    ListTile(
                      title: Center(
                          child: Text(
                        '직접 찍기',
                        style: TextStyle(
                          color: mainTextColor,
                          fontWeight: FontWeight.w600,
                          fontSize: AppUtils.scaleSize(context, 16),
                        ),
                      )),
                      onTap: () async {
                        Navigator.pop(context);
                        final selectedImage = await ImagePicker()
                            .pickImage(source: ImageSource.camera);
                        if (mounted && selectedImage != null) {
                          final imageUrl = await imageApiService.uploadImage(
                              context, selectedImage);
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
                          fontSize: AppUtils.scaleSize(context, 16),
                        ),
                      )),
                      onTap: () async {
                        Navigator.pop(context);
                        final selectedImage = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (mounted && selectedImage != null) {
                          final imageUrl = await imageApiService.uploadImage(
                              context, selectedImage);
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
                          fontSize: AppUtils.scaleSize(context, 16),
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
                height: AppUtils.scaleSize(context, 15),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: screenWidth - AppUtils.scaleSize(context, 40),
                  height: AppUtils.scaleSize(context, 56),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xffC2C4CB),
                  ),
                  child: Center(
                      child: Text(
                    "취소",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: AppUtils.scaleSize(context, 16),
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
            title: Container(
              margin: EdgeInsets.only(bottom: AppUtils.scaleSize(context, 13)),
              child: Text('프로필 수정',
                  style: TextStyle(
                      color: mainTextColor,
                      fontWeight: FontWeight.w600,
                      fontSize: AppUtils.scaleSize(context, 18))),
            ),
            leading: Container(
              margin: EdgeInsets.only(bottom: AppUtils.scaleSize(context, 13)),
              child: IconButton(
                icon: Image(
                  image: const AssetImage('assets/images/icons/back_ios.png'),
                  width: AppUtils.scaleSize(context, 34),
                  height: AppUtils.scaleSize(context, 34),
                  color: mainTextColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            actions: [
              InkWell(
                child: Center(
                  child: Container(
                    margin: EdgeInsets.only(
                        right: AppUtils.scaleSize(context, 20),
                        bottom: AppUtils.scaleSize(context, 13)),
                    alignment: Alignment.center,
                    width: AppUtils.scaleSize(context, 53),
                    height: AppUtils.scaleSize(context, 29),
                    decoration: BoxDecoration(
                      color: areAllFieldsFilled(controllers) &&
                              _isEmailValid &&
                              _isNicknameValid &&
                              _isBirthValid
                          ? primaryColor
                          : induceButtonColor,
                      borderRadius: BorderRadius.circular(33),
                    ),
                    child: Text(
                      '완료',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: AppUtils.scaleSize(context, 12)),
                    ),
                  ),
                ),
                onTap: () async {
                  if (areAllFieldsFilled(controllers) &&
                      _isEmailValid &&
                      _isNicknameValid &&
                      _isBirthValid) {
                    await userApiService.modifyUserProfile(
                        context,
                        controllers['이름']!.text,
                        controllers['닉네임']!.text,
                        introduceController.text,
                        userProfileImageUrl,
                        sendFormatUsingRegex(controllers['생년월일']!.text),
                        controllers['이메일']!.text);
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
                height: AppUtils.scaleSize(context, 140),
                child: Stack(
                  children: [
                    Positioned(
                      top: AppUtils.scaleSize(context, 10),
                      left: AppUtils.scaleSize(context, 145),
                      child: userProfileImageUrl == null
                          ? Image(
                              image: const AssetImage(
                                  "assets/images/icons/momProfile.png"),
                              width: AppUtils.scaleSize(context, 100),
                              height: AppUtils.scaleSize(context, 100))
                          : ClipOval(
                              // 원형
                              child: Image.network(
                                userProfileImageUrl!,
                                fit: BoxFit.cover,
                                width: AppUtils.scaleSize(context, 100),
                                height: AppUtils.scaleSize(context, 100),
                              ),
                            ),
                    ),
                    Positioned(
                      top: AppUtils.scaleSize(context, 181 - 109),
                      left: AppUtils.scaleSize(context, 229),
                      child: Image(
                        image: const AssetImage(
                            "assets/images/icons/circle_pen.png"),
                        width: AppUtils.scaleSize(context, 24),
                        height: AppUtils.scaleSize(context, 24),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: AppUtils.scaleSize(context, 20)),
              width: screenWidth - AppUtils.scaleSize(context, 40),
              height: AppUtils.scaleSize(context, 96),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "소개",
                    style: TextStyle(
                        color: offButtonTextColor,
                        fontWeight: FontWeight.w600,
                        fontSize: AppUtils.scaleSize(context, 14)),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: introduceController,
                    textAlign: TextAlign.start,
                    cursorColor: primaryColor,
                    cursorHeight: AppUtils.scaleSize(context, 17),
                    cursorWidth: AppUtils.scaleSize(context, 1.5),
                    maxLength: 30,
                    style: TextStyle(
                        color: mainTextColor,
                        fontWeight: FontWeight.w500,
                        fontSize: AppUtils.scaleSize(context, 16)),
                    decoration: InputDecoration(
                      counterText: '',
                      counterStyle: TextStyle(
                          color: offButtonTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: AppUtils.scaleSize(context, 14)),
                      border: InputBorder.none,
                      hintText: "자기소개를 입력해주세요",
                      hintStyle: TextStyle(
                          color: beforeInputColor,
                          fontWeight: FontWeight.w500,
                          fontSize: AppUtils.scaleSize(context, 16)),
                      suffixIcon: introduceController.text.isNotEmpty &&
                              _isSuffixVisible
                          ? IconButton(
                              icon: Image.asset(
                                'assets/images/icons/text_delete.png',
                                width: AppUtils.scaleSize(context, 16),
                                height: AppUtils.scaleSize(context, 16),
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
                    width: screenWidth - AppUtils.scaleSize(context, 40),
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
                } else if (type == '닉네임') {
                  hint = '8자 이내로 입력해주세요.';
                } else if (type == '이메일') {
                  hint = 'cozy@cozy.com';
                } else {
                  hint = 'YYYY.MM.DD';
                }
                return Column(
                  children: [
                    ProfileInfoForm(
                        title: type,
                        hint: hint,
                        controller: controllers[type],
                        updateValidity: type == '닉네임'
                            ? _updateNicknameValidity
                            : type == '이메일'
                                ? _updateEmailValidity
                                : type == '생년월일'
                                    ? _updateBirthValidity
                                    : _updateNameValidity),
                    SizedBox(height: AppUtils.scaleSize(context, 24)),
                  ],
                );
              },
              childCount: momInfoType.length,
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              width: AppUtils.scaleSize(context, 132),
              height: AppUtils.scaleSize(context, 21),
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
                        child: Text(
                          '로그아웃',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: AppUtils.scaleSize(context, 14),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: AppUtils.scaleSize(context, 10),
                      ),
                      Container(
                        width: 1,
                        height: AppUtils.scaleSize(context, 11),
                        color: primaryColor,
                      ),
                      SizedBox(
                        width: AppUtils.scaleSize(context, 10),
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
                            fontSize: AppUtils.scaleSize(context, 14),
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
  }
}
