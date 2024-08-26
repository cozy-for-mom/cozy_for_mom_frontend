import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/delete_modal.dart';
import 'package:cozy_for_mom_frontend/common/widget/month_calendar.dart';
import 'package:cozy_for_mom_frontend/common/widget/weekly_calendar.dart';
import 'package:cozy_for_mom_frontend/model/global_state.dart';
import 'package:cozy_for_mom_frontend/model/meal_model.dart';
import 'package:cozy_for_mom_frontend/screen/notification/alarm_setting.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:cozy_for_mom_frontend/service/mom/mom_meal_api_service.dart';
import 'package:cozy_for_mom_frontend/service/image_api.dart';
import 'package:provider/provider.dart';
import 'package:cozy_for_mom_frontend/common/widget/select_bottom_modal.dart';

class MealScreen extends StatefulWidget {
  const MealScreen({super.key});

  @override
  State<MealScreen> createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  late MealApiService momMealViewModel;
  late List<MealModel> pregnantMeals;
  late bool containsBreakfast, containsLunch, containsDinner;
  late String? breakfastImageUrl, lunchImageUrl, dinnerImageUrl;
  late int? breakfastId, lunchId, dinnerId;
  bool isBreakfastLoading = false;
  bool isLunchLoading = false;
  bool isDinnerLoading = false;

  @override
  Widget build(BuildContext context) {
    MealApiService momMealViewModel =
        Provider.of<MealApiService>(context, listen: true);
    ImageApiService imageApiService = ImageApiService();
    final globalData = Provider.of<MyDataModel>(context, listen: false);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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

    Future<dynamic> showSelectModal(int id, String mealType) {
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
                  await momMealViewModel.modifyMeals(
                      context,
                      id,
                      globalData.selectedDay,
                      mealType.substring(0, 2),
                      imageUrl);
                  setState(() {
                    breakfastImageUrl = imageUrl;
                  });
                } else {
                  print('No image selected.');
                }
              },
              tap2: () async {
                Navigator.pop(context);
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext buildContext) {
                    return DeleteModal(
                      text: '등록된 식단을 삭제하시겠습니까?\n이 과정은 복구할 수 없습니다.',
                      title: '식단이',
                      tapFunc: () async {
                        await momMealViewModel.deleteMeal(context, id);
                        setState(() {
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
        appBar: PreferredSize(
          preferredSize: const Size(400, 60),
          child: Padding(
                padding: EdgeInsets.only(top: AppUtils.scaleSize(context, 10), bottom: AppUtils.scaleSize(context, 8), right: AppUtils.scaleSize(context, 5)),
            child: Column(
              children: [
                SizedBox(
                  height: AppUtils.scaleSize(context, 50),
                ),
                Consumer<MyDataModel>(builder: (context, globalData, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
          icon:  Image(
            image: const AssetImage('assets/images/icons/back_ios.png'),
            width: AppUtils.scaleSize(context, 34),
            height: AppUtils.scaleSize(context, 34),
            color: mainTextColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
                       SizedBox(
                              width: AppUtils.scaleSize(context, 30),
                              height: AppUtils.scaleSize(context, 30),
                            ),
                            const Spacer(),
                      Row(
                        children: [
                          Text(
                            DateFormat('M.d E', 'ko_KR')
                                .format(globalData.selectedDate),
                            style: TextStyle(
                              color: mainTextColor,
                              fontWeight: FontWeight.w600,
                              fontSize: AppUtils.scaleSize(context, 20),
                            ),
                          ),
                          IconButton(
                            alignment: AlignmentDirectional.centerStart,
                            icon: const Icon(Icons.expand_more),
                            onPressed: () {
                              showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                elevation: 0.0,
                                context: context,
                                builder: (context) {
                                  return MonthCalendarModal(limitToday: true);
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                          icon: Image(
                              image: const AssetImage(
                                  'assets/images/icons/alert.png'),
                              height: AppUtils.scaleSize(context, 32),
                              width: AppUtils.scaleSize(context, 32)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AlarmSettingPage(
                                          type: CardType.supplement,
                                        )));
                          })
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
        body: Consumer<MyDataModel>(builder: (context, globalData, _) {
          return FutureBuilder(
              future:
                  momMealViewModel.getMeals(context, globalData.selectedDay),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  pregnantMeals = snapshot.data! as List<MealModel>;
                  containsBreakfast = pregnantMeals.any((meal) =>
                      meal.mealType ==
                      MealType.breakfast.korName.substring(0, 2));
                  containsLunch = pregnantMeals.any((meal) =>
                      meal.mealType == MealType.lunch.korName.substring(0, 2));
                  containsDinner = pregnantMeals.any((meal) =>
                      meal.mealType == MealType.dinner.korName.substring(0, 2));
                  breakfastImageUrl = containsBreakfast
                      ? pregnantMeals
                          .firstWhere((meal) =>
                              meal.mealType ==
                              MealType.breakfast.korName.substring(0, 2))
                          .imageUrl
                      : null;
                  lunchImageUrl = containsLunch
                      ? pregnantMeals
                          .firstWhere((meal) =>
                              meal.mealType ==
                              MealType.lunch.korName.substring(0, 2))
                          .imageUrl
                      : null;
                  dinnerImageUrl = containsDinner
                      ? pregnantMeals
                          .firstWhere((meal) =>
                              meal.mealType ==
                              MealType.dinner.korName.substring(0, 2))
                          .imageUrl
                      : null;
                  breakfastId = containsBreakfast
                      ? pregnantMeals
                          .firstWhere((meal) =>
                              meal.mealType ==
                              MealType.breakfast.korName.substring(0, 2))
                          .id
                      : -1;
                  lunchId = containsLunch
                      ? pregnantMeals
                          .firstWhere((meal) =>
                              meal.mealType ==
                              MealType.lunch.korName.substring(0, 2))
                          .id
                      : -1;
                  dinnerId = containsDinner
                      ? pregnantMeals
                          .firstWhere((meal) =>
                              meal.mealType ==
                              MealType.dinner.korName.substring(0, 2))
                          .id
                      : -1;
                }
                if (!snapshot.hasData) {
                  return const Center(
                      child: CircularProgressIndicator(
                    backgroundColor: primaryColor,
                    color: Colors.white,
                  ));
                }
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: WeeklyCalendar(),
                          ),
                          SizedBox(
                            height: AppUtils.scaleSize(context, 30),
                          ),
                          containsBreakfast // TODO List로 수정하면 좋을 듯 (배포하고 리팩토링하기)
                              ? InkWell(
                                  onTap: () {
                                    showSelectModal(breakfastId!,
                                        MealType.breakfast.korName);
                                  },
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        width: screenWidth -
                                            AppUtils.scaleSize(context, 40),
                                        height:
                                            AppUtils.scaleSize(context, 216),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image.network(
                                            breakfastImageUrl!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: AppUtils.scaleSize(context, 20),
                                        left: AppUtils.scaleSize(context, 20),
                                        child: Container(
                                          width:
                                              AppUtils.scaleSize(context, 58),
                                          height:
                                              AppUtils.scaleSize(context, 23),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white,
                                          ),
                                          child: Center(
                                            child: Text(
                                              MealType.breakfast.korName,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: AppUtils.scaleSize(
                                                    context, 12),
                                                color: primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ))
                              : InkWell(
                                  onTap: () async {
                                    final selectedImage =
                                        await showImageSelectModal();
                                    setState(() {
                                      isBreakfastLoading = true; // 로딩 시작
                                    });
                                    if (mounted &&selectedImage != null) {
                                      final imageUrl = await imageApiService
                                          .uploadImage(context, selectedImage);
                                      await momMealViewModel.recordMeals(
                                        context,
                                        globalData.selectedDate,
                                        MealType.breakfast.korName
                                            .substring(0, 2),
                                        imageUrl,
                                      );
                                      setState(() {
                                        breakfastImageUrl = imageUrl;
                                        isBreakfastLoading = false; // 로딩 완료
                                      });
                                    } else {
                                      print('No image selected.');
                                      setState(() {
                                        isBreakfastLoading = false; // 로딩 완료
                                      });
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                    ),
                                    child: Stack(
                                      children: [
                                        SizedBox(
                                          width: screenWidth -
                                              AppUtils.scaleSize(context, 40),
                                          height:
                                              AppUtils.scaleSize(context, 216),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: isBreakfastLoading
                                                    ? [
                                                        const Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                          backgroundColor:
                                                              primaryColor,
                                                          color: Colors.white,
                                                        ))
                                                      ]
                                                    : [
                                                        Image(
                                                          image:
                                                              const AssetImage(
                                                            "assets/images/icons/default_meal.png",
                                                          ),
                                                          height: AppUtils
                                                              .scaleSize(
                                                                  context, 43),
                                                          width: AppUtils
                                                              .scaleSize(
                                                                  context, 19),
                                                        ),
                                                        Text(
                                                          "클릭하여 식사를 기록해 보세요",
                                                          style: TextStyle(
                                                            color: const Color(
                                                                0xff9397A4),
                                                            fontSize: AppUtils
                                                                .scaleSize(
                                                                    context,
                                                                    14),
                                                          ),
                                                        )
                                                      ],
                                              )),
                                        ),
                                        Positioned(
                                          top: AppUtils.scaleSize(context, 20),
                                          left: AppUtils.scaleSize(context, 20),
                                          child: Container(
                                            width:
                                                AppUtils.scaleSize(context, 58),
                                            height:
                                                AppUtils.scaleSize(context, 23),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: const Color(0xffF7F7FA),
                                            ),
                                            child: Center(
                                              child: Text(
                                                MealType.breakfast.korName,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: AppUtils.scaleSize(
                                                      context, 12),
                                                  color:
                                                      const Color(0xff858998),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          SizedBox(
                            height: AppUtils.scaleSize(context, 15),
                          ),
                          containsLunch
                              ? InkWell(
                                  onTap: () {
                                    showSelectModal(
                                        lunchId!, MealType.lunch.korName);
                                  },
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        width: screenWidth -
                                            AppUtils.scaleSize(context, 40),
                                        height:
                                            AppUtils.scaleSize(context, 216),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image.network(
                                            lunchImageUrl!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: AppUtils.scaleSize(context, 20),
                                        left: AppUtils.scaleSize(context, 20),
                                        child: Container(
                                          width:
                                              AppUtils.scaleSize(context, 58),
                                          height:
                                              AppUtils.scaleSize(context, 23),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white,
                                          ),
                                          child: Center(
                                            child: Text(
                                              MealType.lunch.korName,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: AppUtils.scaleSize(
                                                    context, 12),
                                                color: primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ))
                              : InkWell(
                                  onTap: () async {
                                    final selectedImage =
                                        await showImageSelectModal();
                                    setState(() {
                                      isLunchLoading = true; // 로딩 시작
                                    });
                                    if (mounted && selectedImage != null) {
                                      final imageUrl = await imageApiService
                                          .uploadImage(context, selectedImage);
                                      await momMealViewModel.recordMeals(
                                        context,
                                        globalData.selectedDate,
                                        MealType.lunch.korName.substring(0, 2),
                                        imageUrl,
                                      );
                                      setState(() {
                                        containsLunch = !containsLunch;
                                        isLunchLoading = false; // 로딩 완료
                                      });
                                    } else {
                                      print('No image selected.');
                                      setState(() {
                                        isLunchLoading = false; // 로딩 완료
                                      });
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                    ),
                                    child: Stack(
                                      children: [
                                        SizedBox(
                                          width: screenWidth -
                                              AppUtils.scaleSize(context, 40),
                                          height:
                                              AppUtils.scaleSize(context, 216),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: isLunchLoading
                                                    ? [
                                                        const Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                          backgroundColor:
                                                              primaryColor,
                                                          color: Colors.white,
                                                        ))
                                                      ]
                                                    : [
                                                        Image(
                                                          image:
                                                              const AssetImage(
                                                            "assets/images/icons/default_meal.png",
                                                          ),
                                                          height: AppUtils
                                                              .scaleSize(
                                                                  context, 43),
                                                          width: AppUtils
                                                              .scaleSize(
                                                                  context, 19),
                                                        ),
                                                        Text(
                                                          "클릭하여 식사를 기록해 보세요",
                                                          style: TextStyle(
                                                            color: const Color(
                                                                0xff9397A4),
                                                            fontSize: AppUtils
                                                                .scaleSize(
                                                                    context,
                                                                    14),
                                                          ),
                                                        )
                                                      ],
                                              )),
                                        ),
                                        Positioned(
                                          top: AppUtils.scaleSize(context, 20),
                                          left: AppUtils.scaleSize(context, 20),
                                          child: Container(
                                            width:
                                                AppUtils.scaleSize(context, 58),
                                            height:
                                                AppUtils.scaleSize(context, 23),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: const Color(0xffF7F7FA),
                                            ),
                                            child: Center(
                                              child: Text(
                                                MealType.lunch.korName,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: AppUtils.scaleSize(
                                                      context, 12),
                                                  color:
                                                      const Color(0xff858998),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          SizedBox(
                            height: AppUtils.scaleSize(context, 15),
                          ),
                          containsDinner
                              ? InkWell(
                                  onTap: () {
                                    showSelectModal(
                                        dinnerId!, MealType.dinner.korName);
                                  },
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        width: screenWidth -
                                            AppUtils.scaleSize(context, 40),
                                        height:
                                            AppUtils.scaleSize(context, 216),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image.network(
                                            dinnerImageUrl!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: AppUtils.scaleSize(context, 20),
                                        left: AppUtils.scaleSize(context, 20),
                                        child: Container(
                                          width:
                                              AppUtils.scaleSize(context, 58),
                                          height:
                                              AppUtils.scaleSize(context, 23),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white,
                                          ),
                                          child: Center(
                                            child: Text(
                                              MealType.dinner.korName,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: AppUtils.scaleSize(
                                                    context, 12),
                                                color: primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ))
                              : InkWell(
                                  onTap: () async {
                                    final selectedImage =
                                        await showImageSelectModal();
                                    setState(() {
                                      isDinnerLoading = true; // 로딩 시작
                                    });
                                    if (mounted && selectedImage != null) {
                                      final imageUrl = await imageApiService
                                          .uploadImage(context, selectedImage);
                                      await momMealViewModel.recordMeals(
                                        context,
                                        globalData.selectedDate,
                                        MealType.dinner.korName.substring(0, 2),
                                        imageUrl,
                                      );
                                      setState(() {
                                        containsDinner = !containsDinner;
                                        isDinnerLoading = false; // 로딩 완료
                                      });
                                    } else {
                                      print('No image selected.');
                                      setState(() {
                                        isDinnerLoading = false; // 로딩 완료
                                      });
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                    ),
                                    child: Stack(
                                      children: [
                                        SizedBox(
                                          width: screenWidth -
                                              AppUtils.scaleSize(context, 40),
                                          height:
                                              AppUtils.scaleSize(context, 216),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: isDinnerLoading
                                                    ? [
                                                        const Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                          backgroundColor:
                                                              primaryColor,
                                                          color: Colors.white,
                                                        ))
                                                      ]
                                                    : [
                                                        Image(
                                                          image:
                                                              const AssetImage(
                                                            "assets/images/icons/default_meal.png",
                                                          ),
                                                          height: AppUtils
                                                              .scaleSize(
                                                                  context, 43),
                                                          width: AppUtils
                                                              .scaleSize(
                                                                  context, 19),
                                                        ),
                                                        Text(
                                                          "클릭하여 식사를 기록해 보세요",
                                                          style: TextStyle(
                                                            color: const Color(
                                                                0xff9397A4),
                                                            fontSize: AppUtils
                                                                .scaleSize(
                                                                    context,
                                                                    14),
                                                          ),
                                                        )
                                                      ],
                                              )),
                                        ),
                                        Positioned(
                                          top: AppUtils.scaleSize(context, 20),
                                          left: AppUtils.scaleSize(context, 20),
                                          child: Container(
                                            width:
                                                AppUtils.scaleSize(context, 58),
                                            height:
                                                AppUtils.scaleSize(context, 23),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: const Color(0xffF7F7FA),
                                            ),
                                            child: Center(
                                              child: Text(
                                                MealType.dinner.korName,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: AppUtils.scaleSize(
                                                      context, 12),
                                                  color:
                                                      const Color(0xff858998),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.05)
                    ],
                  ),
                );
              });
        }));
  }
}
