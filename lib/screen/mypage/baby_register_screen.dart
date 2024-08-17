import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/delete_complite_alert.dart';
import 'package:cozy_for_mom_frontend/common/widget/delete_modal.dart';
import 'package:cozy_for_mom_frontend/common/widget/select_bottom_modal.dart';
import 'package:cozy_for_mom_frontend/screen/join/join_input_data.dart';
import 'package:cozy_for_mom_frontend/service/image_api.dart';
import 'package:cozy_for_mom_frontend/service/user_api.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BabyRegisterScreen extends StatefulWidget {
  final int? babyProfileId;
  const BabyRegisterScreen({super.key, this.babyProfileId = -1});

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
          await userApiService.getBabyProfile(widget.babyProfileId!);
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
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return SelectBottomModal(
            selec1: '수정하기',
            selec2: '사진 삭제하기',
            tap1: () async {
              Navigator.pop(context);
              final selectedImage = await showImageSelectModal();
              if (selectedImage != null) {
                final imageUrl =
                    await imageApiService.uploadImage(selectedImage);
                setState(() {
                  babyProfileImageUrl = imageUrl;
                });
              } else {
                print('No image selected.');
              }
            },
            tap2: () {
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
          );
        });
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
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppUtils.scaleSize(context, 30)),
        SizedBox(
          width: screenWidth - AppUtils.scaleSize(context, 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "태명",
                style: TextStyle(
                    color: labelTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: AppUtils.scaleSize(context, 14)),
              ),
              widget.babyProfileId! > -1
                  ? Container()
                  : IconButton(
                      icon: Image(
                          image: const AssetImage(
                              'assets/images/icons/baby_remove.png'),
                          height: AppUtils.scaleSize(context, 15),
                          width: AppUtils.scaleSize(context, 14)),
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
        ),
        SizedBox(
          height: AppUtils.scaleSize(context, 14),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppUtils.scaleSize(context, 20),
            ),
            child: TextFormField(
              cursorColor: primaryColor,
              cursorHeight: AppUtils.scaleSize(context, 17),
              cursorWidth: AppUtils.scaleSize(context, 1.5),
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
                    fontSize: AppUtils.scaleSize(context, 16)),
                hoverColor: Colors.white,
                border: InputBorder.none,
              ),
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
          height: AppUtils.scaleSize(context, 30),
        ),
        Text(
          "성별",
          style: TextStyle(
            color: labelTextColor,
            fontWeight: FontWeight.w600,
            fontSize: AppUtils.scaleSize(context, 14),
          ),
        ),
        SizedBox(
          height: AppUtils.scaleSize(context, 14),
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
            width: screenWidth - AppUtils.scaleSize(context, 40),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.only(left: AppUtils.scaleSize(context, 20)),
            child: IgnorePointer(
              child: TextFormField(
                controller: genderControllers[index],
                readOnly: true,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(top: AppUtils.scaleSize(context, 16)),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: '아직 모르겠어요',
                  hintStyle: TextStyle(
                      color: beforeInputColor,
                      fontWeight: FontWeight.w400,
                      fontSize: AppUtils.scaleSize(context, 16)),
                  suffixIcon: const Icon(CupertinoIcons.chevron_down,
                      size: 16, color: mainTextColor),
                ),
                style: TextStyle(
                    color: mainTextColor,
                    fontWeight: FontWeight.w500,
                    fontSize: AppUtils.scaleSize(context, 16)),
              ),
            ),
          ),
        ),
        isOpenGenderModal[index]
            ? Container(
                height: AppUtils.scaleSize(context, 188),
                width: screenWidth - AppUtils.scaleSize(context, 40),
                margin: EdgeInsets.symmetric(
                    vertical: AppUtils.scaleSize(context, 8)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
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
                          padding:
                              EdgeInsets.all(AppUtils.scaleSize(context, 8)),
                          child: Text(
                            item,
                            style: TextStyle(
                              color: offButtonTextColor,
                              fontWeight: FontWeight.w500,
                              fontSize: AppUtils.scaleSize(context, 16),
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
                margin: EdgeInsets.only(top: AppUtils.scaleSize(context, 20)),
                width: screenWidth - AppUtils.scaleSize(context, 40),
                height: 1,
                color: mainLineColor)
            : Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final joinInputData = Provider.of<JoinInputData>(context, listen: false);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          backgroundColor: backgroundColor,
          scrolledUnderElevation: 0,
          elevation: 0,
          leading: Container(),
          actions: [
            IconButton(
                color: Colors.black,
                icon: const Icon(
                  Icons.close,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ]),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    left: AppUtils.scaleSize(context, 20),
                    right: AppUtils.scaleSize(context, 20),
                    bottom: AppUtils.scaleSize(context, 40),
                    top: AppUtils.scaleSize(context, 25)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Center(
                              child: babyProfileImageUrl == null
                                  ? Image(
                                      image: const AssetImage(
                                          "assets/images/icons/babyProfile.png"),
                                      width: AppUtils.scaleSize(context, 100),
                                      height: AppUtils.scaleSize(context, 100))
                                  : ClipOval(
                                      // 원형
                                      child: Image.network(
                                        babyProfileImageUrl!,
                                        fit: BoxFit.cover,
                                        width: AppUtils.scaleSize(context, 100),
                                        height:
                                            AppUtils.scaleSize(context, 100),
                                      ),
                                    ),
                            ),
                            Positioned(
                              left: AppUtils.scaleSize(context, 206),
                              top: AppUtils.scaleSize(context, 72),
                              child: InkWell(
                                onTap: () async {
                                  if (babyProfileImageUrl == null) {
                                    final selectedImage =
                                        await showImageSelectModal();
                                    if (selectedImage != null) {
                                      final imageUrl = await imageApiService
                                          .uploadImage(selectedImage);
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
                                child: Image(
                                  image: const AssetImage(
                                      "assets/images/icons/circle_pen.png"),
                                  width: AppUtils.scaleSize(context, 24),
                                  height: AppUtils.scaleSize(context, 24),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: AppUtils.scaleSize(context, 30),
                        ),
                        Text(
                          "출산예정일",
                          style: TextStyle(
                              color: labelTextColor,
                              fontWeight: FontWeight.w600,
                              fontSize: AppUtils.scaleSize(context, 14)),
                        ),
                        SizedBox(
                          height: AppUtils.scaleSize(context, 14),
                        ),
                        Container(
                            width:
                                screenWidth - AppUtils.scaleSize(context, 40),
                            height: AppUtils.scaleSize(context, 48),
                            padding: EdgeInsets.symmetric(
                                horizontal: AppUtils.scaleSize(context, 20)),
                            decoration: BoxDecoration(
                                color: contentBoxTwoColor,
                                borderRadius: BorderRadius.circular(30)),
                            child: TextFormField(
                              controller: dueDateController,
                              keyboardType: TextInputType.datetime,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              textAlign: TextAlign.start,
                              textAlignVertical: TextAlignVertical.center,
                              maxLength: 10,
                              cursorColor: primaryColor,
                              cursorHeight: AppUtils.scaleSize(context, 14),
                              cursorWidth: AppUtils.scaleSize(context, 1.2),
                              style: TextStyle(
                                  color: mainTextColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: AppUtils.scaleSize(context, 16)),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'YYYY.MM.DD',
                                hintStyle: TextStyle(
                                    color: beforeInputColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: AppUtils.scaleSize(context, 16)),
                                counterText: '',
                              ),
                              onChanged: (value) {
                                if (mounted) {
                                  setState(() {
                                    // TODO 자동완성 후, 지웠다가 다시 입력할때 자동완성 안됨
                                    String parsedDate;
                                    if (value.length == 8 &&
                                        _isNumeric(value)) {
                                      parsedDate = DateFormat('yyyy.MM.dd')
                                          .format(DateTime.parse(value));
                                    } else {
                                      parsedDate = value;
                                    }
                                    dueDateController.text = parsedDate;
                                    dueDate = parsedDate;
                                  });
                                }
                              },
                            )),
                        Column(
                            children: List.generate(babyCount, (index) {
                          return _buildBabyField(index);
                        })),
                        Padding(
                          padding: EdgeInsets.only(
                              top: AppUtils.scaleSize(context, 20),
                              bottom: AppUtils.scaleSize(context, 60)),
                          child: widget.babyProfileId! > -1
                              ? InkWell(
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
                                                .deleteBabyProfile(
                                                    widget.babyProfileId!);
                                            if (mounted) {
                                              Navigator.of(context).pop(true);
                                            }

                                            return Future.value();
                                          },
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
                                          fontSize:
                                              AppUtils.scaleSize(context, 14)),
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
                                          fontSize:
                                              AppUtils.scaleSize(context, 14)),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              if (_validateFields()) {
                if (widget.babyProfileId! > -1) {
                  await UserApiService().modifyBabyProfile(
                      widget.babyProfileId!,
                      dueDate.replaceAll('.', '-'),
                      babyProfileImageUrl,
                      babies);
                  if (mounted) {
                    await CompleteAlertModal.showDeleteCompleteDialog(
                        context, '프로필이', '변경');
                    Navigator.pop(context, true);
                  }
                } else {
                  await UserApiService().addBabyProfile(
                      dueDate.replaceAll('.', '-'),
                      babyProfileImageUrl,
                      babies);
                }

                if (mounted) {
                  Navigator.pop(context, true);
                }
              }
            },
            child: Container(
              width: screenWidth - AppUtils.scaleSize(context, 40),
              height: AppUtils.scaleSize(context, 56),
              margin: EdgeInsets.only(bottom: AppUtils.scaleSize(context, 20)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color:
                    _validateFields() ? primaryColor : const Color(0xffC9DFF9),
              ),
              child: Center(
                child: Text(
                  widget.babyProfileId! > -1 ? "수정하기" : "등록하기",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: AppUtils.scaleSize(context, 16),
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
