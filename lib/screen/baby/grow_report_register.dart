import 'package:cozy_for_mom_frontend/common/widget/delete_modal.dart';
import 'package:cozy_for_mom_frontend/common/widget/select_bottom_modal.dart';
import 'package:cozy_for_mom_frontend/model/baby_growth_model.dart';
import 'package:cozy_for_mom_frontend/screen/tab/baby/baby_growth_report_detail_screen.dart';
import 'package:cozy_for_mom_frontend/service/baby/baby_growth_api_service.dart';
import 'package:cozy_for_mom_frontend/service/image_api.dart';
import 'package:cozy_for_mom_frontend/service/user/user_local_storage_service.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/model/baby_model.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/custom_profile_button.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/custom_text_button.dart';
import 'package:cozy_for_mom_frontend/common/widget/info_input_form.dart';
import 'package:image_picker/image_picker.dart';

class GrowReportRegister extends StatefulWidget {
  final BabyProfileGrowth? babyProfileGrowth;
  const GrowReportRegister({
    super.key,
    required this.babyProfileGrowth,
  });

  @override
  State<GrowReportRegister> createState() => _GrowReportRegisterState();
}

class _GrowReportRegisterState extends State<GrowReportRegister> {
  late UserLocalStorageService userLocalStorageService;
  late ImageApiService imageApiService;
  late int? babyProfileId;
  Color bottomLineColor = mainLineColor;

  TextEditingController titleController = TextEditingController();
  TextEditingController diaryController = TextEditingController();
  Map<Baby, List<TextEditingController>> infoControllersByBabies = {};
  ValueNotifier<Baby?> selectedBaby = ValueNotifier<Baby?>(null);

  late double _textFieldHeight = 50;
  late BabyProfile babyProfile;
  List<Baby> babies = List.empty();
  String? growthImageUrl;
  bool isImageLoading = false;

  final babyInfoType = ["체중", "머리 직경", "머리 둘레", "복부 둘레", "허벅지 길이"];
  final babyInfoUnit = ["g", "cm", "cm", "cm", "cm"];
  double calculateHeight(BuildContext context, String text, double width) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
          text: text,
          style: TextStyle(fontSize: AppUtils.scaleSize(context, 16))),
      maxLines: null,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: width);
    return AppUtils.scaleSize(
        context, 22 + textPainter.height.toDouble() * 1.2);
  }

  @override
  void initState() {
    super.initState();
    initializeBabyInfo();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenWidth = MediaQuery.of(context).size.width;
      _textFieldHeight = calculateHeight(context, diaryController.text,
          screenWidth - AppUtils.scaleSize(context, 50)); // 초기 높이

      setState(() {});
    });
  }

  Future<void> initializeBabyInfo() async {
    if (widget.babyProfileGrowth != null) {
      growthImageUrl = widget.babyProfileGrowth!.growthImageUrl;
      titleController =
          TextEditingController(text: widget.babyProfileGrowth!.title);
      diaryController =
          TextEditingController(text: widget.babyProfileGrowth!.diary);
    }
    userLocalStorageService = await UserLocalStorageService.getInstance();
    babyProfileId = await userLocalStorageService.getBabyProfileId();

    final babyIds = await userLocalStorageService.getBabyIds();
    final babyNames = await userLocalStorageService.getBabyNames();
    final babyProfileImageUrl =
        await userLocalStorageService.getBabyProfileImageUrl();
    babyProfile = BabyProfile(
        id: babyProfileId!,
        name: babyNames!.join("/"),
        image: babyProfileImageUrl!);

    final babySize = babyIds!.length;
    babies = List<Baby>.generate(
        babySize,
        (index) => Baby(
            id: babyIds[index],
            name: babyNames[index],
            image: babyProfileImageUrl));

    // Initialize selectedBaby and infoControllersByBabies here
    selectedBaby = ValueNotifier<Baby?>(babies[0]);

    if (widget.babyProfileGrowth != null) {
      infoControllersByBabies = {
        for (int i = 0; i < babies.length; i++)
          babies[i]: List.generate(5, (index) {
            var babyGrowthInfo =
                widget.babyProfileGrowth!.babies![i].babyGrowthInfo;
            switch (index) {
              case 0:
                return TextEditingController(
                    text: babyGrowthInfo.weight.toString());
              case 1:
                return TextEditingController(
                    text: babyGrowthInfo.headDiameter.toString());
              case 2:
                return TextEditingController(
                    text: babyGrowthInfo.headCircum.toString());
              case 3:
                return TextEditingController(
                    text: babyGrowthInfo.abdomenCircum.toString());
              case 4:
                return TextEditingController(
                    text: babyGrowthInfo.thighLength.toString());
              default:
                return TextEditingController();
            }
          })
      };
    } else {
      infoControllersByBabies = {
        for (var e in babies)
          e: List.generate(
              babyInfoType.length, (index) => TextEditingController())
      };
    }

    setState(() {});
    imageApiService = ImageApiService();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;
    final babyGrowthApiService = BabyGrowthApiService();
    var id = widget.babyProfileGrowth?.id;

    bool isRegisterButtonEnabled() {
      return titleController.text.isNotEmpty && diaryController.text.isNotEmpty;
    }

    Future<XFile?> showImageSelectModal() async {
      XFile? selectedImage;

      // 사용자 선택에 따라 모달을 닫고, 이미지 선택
      String? choice = await showModalBottomSheet<String>(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (BuildContext context) {
            return SelectBottomModal(
              selec1: '사진 촬영하기',
              selec2: '앨범에서 가져오기',
              tap1: () {
                Navigator.pop(context, 'camera');
              },
              tap2: () {
                Navigator.pop(context, 'gallery');
              },
            );
          });

      // 모달이 닫힌 후, 선택에 따라 이미지를 선택
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
                if (mounted && selectedImage != null) {
                  final imageUrl =
                      await imageApiService.uploadImage(context, selectedImage);
                  setState(() {
                    growthImageUrl = imageUrl;
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
                          growthImageUrl = null;
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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Text(
          "성장 보고서",
          style: TextStyle(
            color: mainTextColor,
            fontWeight: FontWeight.w600,
            fontSize: AppUtils.scaleSize(context, 20),
          ),
        ),
        leading: IconButton(
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(children: [
          Positioned.fill(
            child: ValueListenableBuilder<Baby?>(
              valueListenable: selectedBaby,
              builder: (context, activeBaby, child) {
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: AppUtils.scaleSize(context, 20),
                            left: AppUtils.scaleSize(context, 10),
                            bottom: AppUtils.scaleSize(context, 32)),
                        child: SizedBox(
                          height: AppUtils.scaleSize(context, 111),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: babies.length,
                            itemBuilder: (context, index) {
                              var baby = babies[index];
                              return CustomProfileButton(
                                text: baby.name,
                                imagePath: baby.image,
                                offBackColor: const Color(0xffF0F0F5),
                                isSelected: activeBaby == baby,
                                onPressed: () {
                                  selectedBaby.value = baby;
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppUtils.scaleSize(context, 20)),
                        child: SizedBox(
                          width: screenWidth,
                          child: TextFormField(
                            controller: titleController,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: AppUtils.scaleSize(context, 20),
                            ),
                            cursorColor: primaryColor,
                            cursorHeight: AppUtils.scaleSize(context, 21),
                            cursorWidth: AppUtils.scaleSize(context, 1.5),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "제목을 입력해주세요",
                              hintStyle: TextStyle(
                                color: const Color(
                                    0xff9397A4), // offButtonTextColor
                                fontWeight: FontWeight.w500,
                                fontSize: AppUtils.scaleSize(
                                    context, AppUtils.scaleSize(context, 20)),
                              ),
                            ),
                            onChanged: (text) {
                              setState(() {
                                bottomLineColor = text.isNotEmpty
                                    ? primaryColor
                                    : mainLineColor;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppUtils.scaleSize(context, 20)),
                        child: Container(
                          width: screenWidth,
                          height: AppUtils.scaleSize(context, 1.5),
                          color: bottomLineColor,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppUtils.scaleSize(context, 18),
                            vertical: AppUtils.scaleSize(context, 20)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: screenWidth,
                            height: AppUtils.scaleSize(context, 216),
                            decoration: const BoxDecoration(
                              color: offButtonColor,
                            ),
                            child: growthImageUrl != null
                                ? InkWell(
                                    onTap: () {
                                      showSelectModal();
                                    },
                                    child: Image.network(
                                      growthImageUrl!,
                                      fit: BoxFit.cover,
                                    ))
                                : isImageLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                        backgroundColor: primaryColor,
                                        color: Colors.white,
                                      ))
                                    : CustomTextButton(
                                        text: '사진을 등록해보세요!',
                                        textColor: const Color(0xff9397A4),
                                        textWeight: FontWeight.w500,
                                        imagePath:
                                            'assets/images/icons/photo_register.png',
                                        imageWidth: 45.6,
                                        imageHeight: 36.9,
                                        onPressed: () async {
                                          final selectedImage =
                                              await ImagePicker().pickImage(
                                                  source: ImageSource.gallery);
                                          setState(() {
                                            isImageLoading = true;
                                          });
                                          if (mounted &&
                                              selectedImage != null) {
                                            final imageUrl =
                                                await imageApiService
                                                    .uploadImage(
                                                        context, selectedImage);
                                            setState(() {
                                              growthImageUrl = imageUrl;
                                              isImageLoading = false;
                                            });
                                          } else {
                                            print('No image selected.');
                                            setState(() {
                                              isImageLoading = false;
                                            });
                                          }
                                        },
                                      ),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppUtils.scaleSize(context, 21)),
                        child: SizedBox(
                          width: screenWidth,
                          height: _textFieldHeight,
                          child: TextFormField(
                            controller: diaryController,
                            textAlignVertical: TextAlignVertical.top,
                            textAlign: TextAlign.start,
                            maxLines: null,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: AppUtils.scaleSize(context, 16),
                            ),
                            cursorColor: primaryColor,
                            cursorHeight: AppUtils.scaleSize(context, 17),
                            cursorWidth: AppUtils.scaleSize(context, 1.5),
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                              hintText: "내용을 입력하세요.",
                              hintStyle: TextStyle(
                                color: const Color(
                                    0xff9397A4), // offButtonTextColor
                                fontWeight: FontWeight.w500,
                                fontSize: AppUtils.scaleSize(context, 16),
                              ),
                            ),
                            onChanged: (text) {
                              setState(() {
                                // 텍스트의 길이에 따라 높이를 조절
                                _textFieldHeight = calculateHeight(
                                    context,
                                    text,
                                    screenWidth -
                                        AppUtils.scaleSize(context, 50));
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: AppUtils.scaleSize(context, 20),
                            right: AppUtils.scaleSize(context, 20),
                            top: AppUtils.scaleSize(context, 15)),
                        child: Container(
                          width: screenWidth,
                          height: 1,
                          color: mainLineColor,
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          final type = babyInfoType[index];
                          final unit = babyInfoUnit[index];
                          final controller =
                              infoControllersByBabies[selectedBaby.value]
                                  ?[index];
                          return Column(
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                      bottom: AppUtils.scaleSize(context, 30))),
                              InfoInputForm(
                                title: type,
                                hint: "0 $unit",
                                unit: unit,
                                controller: controller,
                                onChanged: () {
                                  setState(() {});
                                },
                              ),
                            ],
                          );
                        },
                        childCount: babyInfoType.length,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(height: AppUtils.scaleSize(context, 120)),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(height: keyboardPadding),
                    ),
                  ],
                );
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter, // 그라데이션 시작점
                  end: Alignment.topCenter, // 그라데이션 끝점
                  colors: [
                    Colors.white, // 시작 색상
                    Colors.white.withOpacity(0.0), // 끝 색상
                  ],
                ),
              ),
              padding: EdgeInsets.only(
                  top: AppUtils.scaleSize(context, 20),
                  bottom: AppUtils.scaleSize(context, 34)),
              child: InkWell(
                onTap: () {
                  if (isRegisterButtonEnabled()) {
                    babyGrowthApiService
                        .registerBabyProfileGrowth(
                          context,
                          BabyProfileGrowth(
                            id: id,
                            babyProfileId: babyProfileId!,
                            date: DateTime.now(),
                            growthImageUrl: growthImageUrl,
                            diary: diaryController.text,
                            title: titleController.text,
                            babies: babies.map(
                              (baby) {
                                final infoControllers =
                                    infoControllersByBabies[baby] ?? [];
                                return BabyGrowth(
                                  name: baby.name,
                                  babyId: baby.id,
                                  babyGrowthInfo: BabyGrowthInfo(
                                    weight:
                                        parseDouble(infoControllers[0].text),
                                    headDiameter:
                                        parseDouble(infoControllers[1].text),
                                    headCircum:
                                        parseDouble(infoControllers[2].text),
                                    abdomenCircum:
                                        parseDouble(infoControllers[3].text),
                                    thighLength:
                                        parseDouble(infoControllers[4].text),
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        )
                        .then(
                          (reportId) => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BabyGrowthReportDetailScreen(
                                  babyProfileGrowthId: reportId!,
                                ),
                              ),
                            ).then((value) {
                              if (value == true) {
                                Navigator.pop(context,
                                    true); // true를 반환하여 목록 화면에서 업데이트를 트리거
                              }
                            })
                          },
                        );
                  }
                },
                child: Container(
                  height: AppUtils.scaleSize(context, 56),
                  margin: EdgeInsets.symmetric(
                      horizontal: AppUtils.scaleSize(context, 20)),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isRegisterButtonEnabled()
                        ? primaryColor
                        : const Color(0xffC9DFF9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.babyProfileGrowth == null ? "등록하기" : "수정하기",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: AppUtils.scaleSize(context, 16),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class Baby {
  final int id;
  final String name;
  final String image;
  bool isProfileSelected = false; // 프로필 선택 상태를 저장

  Baby(
      {required this.id,
      required this.name,
      required this.image,
      this.isProfileSelected = false});
}

double parseDouble(String value, {double defaultValue = 0.0}) {
  try {
    return double.parse(value);
  } catch (e) {
    return defaultValue;
  }
}
