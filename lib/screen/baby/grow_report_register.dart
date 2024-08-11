import 'package:cozy_for_mom_frontend/common/widget/delete_complite_alert.dart';
import 'package:cozy_for_mom_frontend/common/widget/delete_modal.dart';
import 'package:cozy_for_mom_frontend/common/widget/select_bottom_modal.dart';
import 'package:cozy_for_mom_frontend/model/baby_growth_model.dart';
import 'package:cozy_for_mom_frontend/screen/tab/baby/baby_growth_report_detail_screen.dart';
import 'package:cozy_for_mom_frontend/service/baby/baby_growth_api_service.dart';
import 'package:cozy_for_mom_frontend/service/image_api.dart';
import 'package:cozy_for_mom_frontend/service/user/user_local_storage_service.dart';
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
  late ValueNotifier<Baby?> selectedBaby;
  double _textFieldHeight = 50.0; // 초기 높이

  late BabyProfile babyProfile;
  List<Baby> babies = List.empty();
  String? growthImageUrl;
  bool isImageLoading = false;

  final babyInfoType = ["체중", "머리 직경", "머리 둘레", "복부 둘레", "허벅지 길이"];
  final babyInfoUnit = ["g", "cm", "cm", "cm", "cm"];
  double calculateHeight(String text) {
    return 50.0 + text.length.toDouble() / 1.2;
  }

  @override
  void initState() {
    super.initState();
    initializeBabyInfo();
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
    final babyGrowthApiService = BabyGrowthApiService();

    bool isRegisterButtonEnabled() {
      return titleController.text.isNotEmpty ||
          diaryController.text.isNotEmpty ||
          infoControllersByBabies.values.any(
              (element) => element.any((element) => element.text.isNotEmpty));
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
                if (selectedImage != null) {
                  final imageUrl =
                      await imageApiService.uploadImage(selectedImage);
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
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: const Text(
          "성장 보고서",
          style: TextStyle(
            color: mainTextColor,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
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
                        padding: const EdgeInsets.only(
                            top: 20, left: 10, bottom: 32),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: babies.map((baby) {
                            return CustomProfileButton(
                              text: baby.name,
                              imagePath: baby.image,
                              offBackColor: const Color(0xffF0F0F5),
                              isSelected: activeBaby == baby,
                              onPressed: () {
                                selectedBaby.value = baby;
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          width: screenWidth,
                          height: 52,
                          child: TextFormField(
                            controller: titleController,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                            cursorColor: primaryColor,
                            cursorHeight: 21,
                            cursorWidth: 1.5,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "제목을 입력해주세요",
                              hintStyle: TextStyle(
                                color: Color(0xff9397A4), // offButtonTextColor
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
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
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          width: screenWidth,
                          height: 1.5,
                          color: bottomLineColor,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: screenWidth,
                            height: 216,
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
                                          if (selectedImage != null) {
                                            final imageUrl =
                                                await imageApiService
                                                    .uploadImage(selectedImage);
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
                        padding: const EdgeInsets.symmetric(horizontal: 21),
                        child: SizedBox(
                          width: screenWidth,
                          height: _textFieldHeight,
                          child: TextFormField(
                            controller: diaryController,
                            textAlignVertical: TextAlignVertical.top,
                            textAlign: TextAlign.start,
                            maxLines: null,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            cursorColor: primaryColor,
                            cursorHeight: 17,
                            cursorWidth: 1.5,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                              hintText: "내용을 입력하세요.",
                              hintStyle: TextStyle(
                                color: Color(0xff9397A4), // offButtonTextColor
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            onChanged: (text) {
                              setState(() {
                                // 텍스트의 길이에 따라 높이를 조절
                                _textFieldHeight = calculateHeight(text);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 15),
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
                              const Padding(
                                  padding: EdgeInsets.only(bottom: 30)),
                              InfoInputForm(
                                title: type,
                                hint: "0 $unit",
                                suffix: unit,
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
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 120),
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: InkWell(
                onTap: () async {
                  final reportId =
                      await babyGrowthApiService.registerBabyProfileGrowth(
                    BabyProfileGrowth(
                      id: null, // TODO 이게 다이어리 id인가?
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
                              weight: parseDouble(infoControllers[0].text),
                              headDiameter:
                                  parseDouble(infoControllers[1].text),
                              headCircum: parseDouble(infoControllers[2].text),
                              abdomenCircum:
                                  parseDouble(infoControllers[3].text),
                              thighLength: parseDouble(infoControllers[4].text),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  );
                  if (mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BabyGrowthReportDetailScreen(
                          babyProfileGrowthId: reportId,
                          babyProfileImageUrl: babyProfile.image,
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  width: screenWidth,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isRegisterButtonEnabled()
                        ? primaryColor
                        : const Color(0xffC9DFF9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "등록하기",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
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
