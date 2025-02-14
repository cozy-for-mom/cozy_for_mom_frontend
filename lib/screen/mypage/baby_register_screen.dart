import 'dart:math';

import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/complite_alert.dart';
import 'package:cozy_for_mom_frontend/common/widget/delete_modal.dart';
import 'package:cozy_for_mom_frontend/common/widget/select_bottom_modal.dart';
import 'package:cozy_for_mom_frontend/screen/join/join_input_data.dart';
import 'package:cozy_for_mom_frontend/service/image_api.dart';
import 'package:cozy_for_mom_frontend/service/user_api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BabyRegisterScreen extends StatefulWidget {
  final int? babyProfileId;
  final bool isRecentBabyProfile;
  const BabyRegisterScreen({super.key, this.babyProfileId = -1, this.isRecentBabyProfile = false});

  @override
  State<BabyRegisterScreen> createState() => _BabyRegisterScreenState();
}

const labelTextColor = Color(0xff858998);

class _BabyRegisterScreenState extends State<BabyRegisterScreen> {
  final List<String> genderItems = ['남아', '여아', '아직 모르겠어요'];
  TextEditingController dueDateController = TextEditingController();

  List<TextEditingController> birthNameControllers = [];
  List<TextEditingController> genderControllers = [];
  XFile? image;
  String? babyProfileImageUrl;
  var dueDate = '';
  List<BabyForRegister> babies = [];
  ImageApiService imageApiService = ImageApiService();
  late UserApiService userApiService = UserApiService();

  bool isGenderModal = false;
  int babyCount = 0;
  List<bool> isOpenGenderModal = [false];

  @override
  void initState() {
    super.initState();
    if (widget.babyProfileId! > -1) {
      _loadInitialData();
    } else {
      addBaby();
    }
  }

  Future<void> _loadInitialData() async {
    try {
      var babyProfileData =
          await userApiService.getBabyProfile(context, widget.babyProfileId!);
      setState(() {
        dueDateController.text = babyProfileData['dueAt'].replaceAll('-', '.');
        dueDate = dueDateController.text;
        babyProfileImageUrl = babyProfileData['profileImageUrl'];
        babies = babyProfileData['babies'];
        for (var baby in babies) {
          babyCount += 1;
          TextEditingController birthNameController =
              TextEditingController(text: baby.name);
          TextEditingController genderController =
              TextEditingController(text: baby.gender);
          birthNameControllers.add(birthNameController);
          genderControllers.add(genderController);
        }
      });
    } catch (e) {
      print('Error loading initial data: $e');
    }
  }

  void addBaby() {
    setState(() {
      babyCount += 1;
      birthNameControllers.add(TextEditingController());
      genderControllers.add(TextEditingController());
    });
  }

  bool _validateFields() {
    bool allFieldsValid = true;
    for (int i = 0; i < birthNameControllers.length; i++) {
      if (birthNameControllers[i].text.isEmpty ||
          genderControllers[i].text.isEmpty) {
        allFieldsValid = false;
        break;
      }
    }
    return allFieldsValid && dueDateController.text.isNotEmpty;
  }

  @override
  void dispose() {
    birthNameControllers.forEach((controller) {
      controller.dispose();
    });
    genderControllers.forEach((controller) {
      controller.dispose();
    });
    super.dispose();
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
          width: screenWidth - 2 * paddingValue,
          height: isTablet ? 214.w : 280.w,
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
                                babyProfileImageUrl = imageUrl;
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
                                babyProfileImageUrl = imageUrl;
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
                                      babyProfileImageUrl = null;
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

  Widget _buildBabyField(int index) {
    if (index >= birthNameControllers.length) {
      birthNameControllers.add(TextEditingController());
    }
    if (index >= genderControllers.length) {
      genderControllers.add(TextEditingController());
    }
    if (index >= isOpenGenderModal.length) {
      isOpenGenderModal.add(false);
    }
    if (index >= babies.length) {
      babies.add(BabyForRegister(name: '', gender: ''));
    }
    final screenWidth =
        MediaQuery.of(context).size.width; // TODO 중복 코드 통합할 수 있는 방법 고민
    final isTablet = screenWidth > 600;
    final paddingValue = isTablet ? 30.w : 20.w;

    return SizedBox(
      width: screenWidth - 2 * paddingValue,
      child: Column(
        children: [
          SizedBox(height: 30.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "태명",
                style: TextStyle(
                    color: labelTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: min(14.sp, 24)),
              ),
              widget.babyProfileId! > -1
                  ? Container()
                  : IconButton(
                      icon: Image(
                          image: const AssetImage(
                              'assets/images/icons/baby_remove.png'),
                          height: min(15.w, 35),
                          width: min(14.w, 24)),
                      onPressed: () {
                        print('$index 태아 삭제');
                        if (mounted && babyCount > 1) {
                          setState(() {
                            babyCount -= 1;
                            birthNameControllers.removeAt(index);
                            genderControllers.removeAt(index);
                            babies.removeAt(index);
                            isOpenGenderModal.add(false);
                          });
                        }
                      }),
            ],
          ),
          SizedBox(
            height: 14.w,
          ),
          Container(
            width: screenWidth - 2 * paddingValue,
            height: min(48.w, 78),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.w),
              color: Colors.white,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
            ),
            child: Center(
              child: TextFormField(
                cursorColor: primaryColor,
                cursorHeight: min(16.sp, 26),
                cursorWidth: 1.5.w,
                maxLength: 8,
                controller: birthNameControllers[index],
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  counterText: '',
                  fillColor: Colors.white,
                  hintText: "태명을 입력해주세요",
                  hintStyle: TextStyle(
                      color: const Color(0xffE1E1E7),
                      fontWeight: FontWeight.w500,
                      fontSize: min(16.sp, 26)),
                  hoverColor: Colors.white,
                  border: InputBorder.none,
                ),
                style: TextStyle(
                    color: mainTextColor,
                    fontWeight: FontWeight.w500,
                    fontSize: min(16.sp, 26)),
                onChanged: (value) {
                  if (mounted) {
                    setState(() {
                      babies[index].name = value;
                      _validateFields();
                    });
                  }
                },
              ),
            ),
          ),
          SizedBox(
            height: 30.w,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "성별",
              style: TextStyle(
                color: labelTextColor,
                fontWeight: FontWeight.w600,
                fontSize: min(14.sp, 24),
              ),
            ),
          ),
          SizedBox(
            height: 14.w,
          ),
          InkWell(
            onTap: () {
              if (mounted) {
                setState(() {
                  isOpenGenderModal[index] = !isOpenGenderModal[index];
                });
              }
            },
            child: Container(
              width: screenWidth - 2 * paddingValue,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.w)),
              padding: EdgeInsets.only(left: 20.w, right: 10.w),
              child: IgnorePointer(
                child: TextFormField(
                  controller: genderControllers[index],
                  readOnly: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 16.w),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10.w),
                    ),
                    hintText: '아직 모르겠어요',
                    hintStyle: TextStyle(
                        color: beforeInputColor,
                        fontWeight: FontWeight.w500,
                        fontSize: min(16.sp, 26)),
                    suffixIcon: Icon(CupertinoIcons.chevron_down,
                        size: min(15.w, 25), color: mainTextColor),
                  ),
                  style: TextStyle(
                      color: mainTextColor,
                      fontWeight: FontWeight.w500,
                      fontSize: min(16.sp, 26)),
                ),
              ),
            ),
          ),
          isOpenGenderModal[index]
              ? Container(
                  height: min(188.w, 288),
                  width: screenWidth - 2 * paddingValue,
                  margin: EdgeInsets.symmetric(vertical: 8.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.w),
                    color: contentBoxTwoColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: genderItems.map<Widget>((String item) {
                      return InkWell(
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              genderControllers[index] =
                                  (TextEditingController(text: item));
                              babies[index].gender = item;
                              _validateFields();
                              isOpenGenderModal[index] =
                                  !isOpenGenderModal[index];
                            });
                          }
                        },
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.all(8.w),
                            child: Text(
                              item,
                              style: TextStyle(
                                color: offButtonTextColor,
                                fontWeight: FontWeight.w500,
                                fontSize: min(16.sp, 26),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
              : Container(),
          babyCount > 1 && index < babyCount - 1
              ? Container(
                  margin: EdgeInsets.only(top: 20.w),
                  width: screenWidth - 2 * paddingValue,
                  height: 1.w,
                  color: mainLineColor)
              : Container(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.of(context).size.width; // TODO 중복 코드 통합할 수 있는 방법 고민
    final isTablet = screenWidth > 600;
    final paddingValue = isTablet ? 30.w : 20.w;
    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;
    final joinInputData = Provider.of<JoinInputData>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      appBar: AppBar(
          backgroundColor: backgroundColor,
          scrolledUnderElevation: 0,
          elevation: 0,
          leading: Container(),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.w),
              child: IconButton(
                  color: Colors.black,
                  icon: Icon(
                    Icons.close,
                    color: Colors.black,
                    size: min(28.w, 38),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ),
          ]),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 20.w,
                        right: 20.w,
                        bottom: (70 + keyboardPadding).w,
                        top: 15.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            if (babyProfileImageUrl == null) {
                              final selectedImage =
                                  await showImageSelectModal();
                              if (mounted && selectedImage != null) {
                                final imageUrl = await imageApiService
                                    .uploadImage(context, selectedImage);
                                setState(() {
                                  babyProfileImageUrl = imageUrl;
                                });
                              } else {
                                print('No image selected.');
                              }
                            } else {
                              showSelectModal();
                            }
                          },
                          child: Stack(
                            children: [
                              Center(
                                child: babyProfileImageUrl == null
                                    ? Image(
                                        image: const AssetImage(
                                            "assets/images/icons/babyProfile.png"),
                                        width: min(100.w, 200),
                                        height: min(100.w, 200),
                                      )
                                    : ClipOval(
                                        // 원형
                                        child: Image.network(
                                          babyProfileImageUrl!,
                                          fit: BoxFit.cover,
                                          width: min(100.w, 200),
                                          height: min(100.w, 200),
                                        ),
                                      ),
                              ),
                              Positioned(
                                top: isTablet ? 94.h : 64.h,
                                left: isTablet ? 203.w : 206.w,
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
                        SizedBox(
                          height: 30.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "출산예정일",
                              style: TextStyle(
                                  color: labelTextColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: min(14.sp, 24)),
                            ),
                            SizedBox(
                              height: 14.w,
                            ),
                            Container(
                                width: screenWidth - 2 * paddingValue,
                                height: min(48.w, 78),
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                decoration: BoxDecoration(
                                    color: contentBoxTwoColor,
                                    borderRadius: BorderRadius.circular(30.w)),
                                child: Center(
                                  child: TextFormField(
                                    controller: dueDateController,
                                    keyboardType: TextInputType.datetime,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    textAlign: TextAlign.start,
                                    maxLength: 10,
                                    cursorColor: primaryColor,
                                    cursorHeight: min(16.sp, 26),
                                    cursorWidth: 1.2.w,
                                    style: TextStyle(
                                        color: mainTextColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: min(16.sp, 26)),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                      hintText: 'YYYY.MM.DD',
                                      hintStyle: TextStyle(
                                          color: beforeInputColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: min(16.sp, 26)),
                                      counterText: '',
                                    ),
                                    onChanged: (value) {
                                      if (mounted) {
                                        setState(() {
                                          // TODO 자동완성 후, 지웠다가 다시 입력할때 자동완성 안됨
                                          String parsedDate;
                                          if (value.length == 8 &&
                                              _isNumeric(value)) {
                                            parsedDate =
                                                DateFormat('yyyy.MM.dd').format(
                                                    DateTime.parse(value));
                                            // 오늘 날짜보다 과거인 경우 내일 날짜로 변경
                                            if (DateTime.parse(value)
                                                .isBefore(DateTime.now())) {
                                              parsedDate = DateFormat(
                                                      'yyyy.MM.dd')
                                                  .format(DateTime.now().add(
                                                      const Duration(days: 1)));
                                            }
                                          } else {
                                            parsedDate = value;
                                          }
                                          dueDateController.text = parsedDate;
                                          dueDate = parsedDate;
                                        });
                                      }
                                    },
                                  ),
                                )),
                          ],
                        ),
                        Column(
                            children: List.generate(babyCount, (index) {
                          return _buildBabyField(index);
                        })),
                        Padding(
                          padding: EdgeInsets.only(top: 20.w, bottom: 60.w),
                          child: widget.babyProfileId! > -1
                              ? widget.isRecentBabyProfile
                              ? Container()
                              : InkWell(
                                  onTap: () {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext buildContext) {
                                        return DeleteModal(
                                          text:
                                              '등록된 데이터는 다시 복구할 수 없습니다.\n삭제하시겠습니까?',
                                          title: '프로필이',
                                          tapFunc: () async {
                                            await UserApiService()
                                                .deleteBabyProfile(context,
                                                    widget.babyProfileId!);


                                            return Future.value();
                                          },
                                          shouldCloseParentCnt: 2,
                                        );
                                      },
                                    );
                                  },
                                  child: Center(
                                    child: Text(
                                      '프로필 삭제하기',
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: min(14.sp, 24)),
                                    ),
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    if (mounted) {
                                      setState(() {
                                        babyCount += 1;
                                        isOpenGenderModal.add(false);
                                      });
                                    }
                                  },
                                  child: Center(
                                    child: Text(
                                      '+ 다태아 추가하기',
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: min(14.sp, 24)),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0.h,
            left: 0.w,
            right: 0.w,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.white,
                    Colors.white.withOpacity(0.2),
                  ],
                ),
              ),
              padding: EdgeInsets.only(
                top: 20.w,
                bottom: 54.w - paddingValue,
              ),
              child: InkWell(
                onTap: () async {
                  if (_validateFields()) {
                    if (widget.babyProfileId! > -1) {
                      await UserApiService().modifyBabyProfile(
                          context,
                          widget.babyProfileId!,
                          dueDate.replaceAll('.', '-'),
                          babyProfileImageUrl,
                          babies);
                      if (mounted) {
                        await CompleteAlertModal.showCompleteDialog(
                            context, '프로필이', '변경');
                      }
                    } else {
                      await UserApiService().addBabyProfile(
                          context,
                          dueDate.replaceAll('.', '-'),
                          babyProfileImageUrl,
                          babies);
                    }
                    // 화면 전환은 모든 작업이 완료된 후에 수행한다.
                    if (mounted) {
                      Navigator.pop(context, true);
                    }
                  }
                },
                child: Container(
                  height: min(56.w, 96),
                  margin: EdgeInsets.symmetric(
                    horizontal: paddingValue,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.w),
                    color: _validateFields()
                        ? primaryColor
                        : const Color(0xffC9DFF9),
                  ),
                  child: Center(
                    child: Text(
                      widget.babyProfileId! > -1 ? "수정하기" : "등록하기",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: min(16.sp, 26),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BabyForRegister {
  String name;
  String gender;

  BabyForRegister({
    required this.name,
    required this.gender,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'gender': gender,
      };
}

bool _isNumeric(String value) {
  final numericRegex = RegExp(r'^[0-9]+$');
  return numericRegex.hasMatch(value);
}
