import 'dart:math';

import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/delete_modal.dart';
import 'package:cozy_for_mom_frontend/common/widget/month_calendar.dart';
import 'package:cozy_for_mom_frontend/common/widget/weekly_calendar.dart';
import 'package:cozy_for_mom_frontend/model/global_state.dart';
import 'package:cozy_for_mom_frontend/model/meal_model.dart';
import 'package:cozy_for_mom_frontend/screen/notification/alarm_setting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final isTablet = screenWidth > 600;
    final paddingValue = isTablet ? 30.w : 20.w;

    Future<XFile?> showImageSelectModal() async {
      XFile? selectedImage;

      // 사용자 선택에 따라 모달을 닫고, 이미지 선택
      String? choice = await showModalBottomSheet<String>(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
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
          elevation: 0.0,
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
                        setState(() {});

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
          preferredSize: Size(screenWidth, isTablet? 42.w : 60.w),
          child: Padding(
            padding: EdgeInsets.only(top: paddingValue - 20.w,
                    bottom: paddingValue - 20.w,
                    right: 8.w),
            child: Column(
              children: [
                SizedBox(
                  height: isTablet ? 0.w : 50.w,
                ),
                Consumer<MyDataModel>(builder: (context, globalData, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Image(
                          image: const AssetImage(
                              'assets/images/icons/back_ios.png'),
                          width: min(34.w, 44),
                          height: min(34.w, 44),
                          color: mainTextColor,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      SizedBox(
                        width: min(30.w, 40),
                        height: min(30.w, 40),
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
                              fontSize: min(18.sp, 28),
                            ),
                          ),
                          IconButton(
                            alignment: AlignmentDirectional.centerStart,
                            icon: const Icon(Icons.expand_more),
                            onPressed: () {
                              showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                elevation: 0.0,
                                context: context,
                                builder: (context) {
                                  return Wrap(children : [MonthCalendarModal(limitToday: true)]);
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
                              height: min(32.w, 42),
                              width: min(32.w, 42)),
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
                return Column(
                  children: [
                   Padding(
                      padding: EdgeInsets.symmetric(horizontal: paddingValue, vertical: 8.w),
                      child: const WeeklyCalendar(),
                    ),
                    SizedBox(height: 15.h),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            
                            containsBreakfast // TODO List로 수정하면 좋을 듯 (배포하고 리팩토링하기)
                                ? InkWell(
                                    onTap: () {
                                      showSelectModal(breakfastId!,
                                          MealType.breakfast.korName);
                                    },
                                    child: Stack(
                                      children: [
                                        SizedBox(
                                          width: screenWidth - 2 * paddingValue,
                                          height: 216.w,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20.w),
                                            child: Image.network(
                                              breakfastImageUrl!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 20.h,
                                          left: 20.w,
                                          child: Container(
                                            width: 58.w,
                                            height: 23.w,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.w),
                                              color: Colors.white,
                                            ),
                                            child: Center(
                                              child: Text(
                                                MealType.breakfast.korName,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: min(12.sp, 22),
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
                                      if (mounted && selectedImage != null) {
                                        final imageUrl =
                                            await imageApiService.uploadImage(
                                                context, selectedImage);
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
                                        borderRadius: BorderRadius.circular(20.w),
                                        color: Colors.white,
                                      ),
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            width: screenWidth - 2 * paddingValue,
                                            height: 216.w,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20.w),
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
                                                            height: min(43.w, 86),
                                                            width: min(19.w, 38),
                                                          ),
                                                          Text(
                                                            "클릭하여 식사를 기록해 보세요",
                                                            style: TextStyle(
                                                              color: const Color(
                                                                  0xff9397A4),
                                                              fontSize: min(14.sp, 24),
                                                            ),
                                                          )
                                                        ],
                                                )),
                                          ),
                                          Positioned(
                                            top: 20.h,
                                            left: 20.w,
                                            child: Container(
                                              width: 58.w,
                                              height: 23.w,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.w),
                                                color: const Color(0xffF7F7FA),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  MealType.breakfast.korName,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: min(12.sp, 22),
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
                              height: 15.w,
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
                                          width: screenWidth - 2 * paddingValue,
                                          height: 216.w,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20.w),
                                            child: Image.network(
                                              lunchImageUrl!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 20.h,
                                          left: 20.w,
                                          child: Container(
                                            width: 58.w,
                                            height: 23.w,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.w),
                                              color: Colors.white,
                                            ),
                                            child: Center(
                                              child: Text(
                                                MealType.lunch.korName,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: min(12.sp, 22),
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
                                        final imageUrl =
                                            await imageApiService.uploadImage(
                                                context, selectedImage);
                                        await momMealViewModel.recordMeals(
                                          context,
                                          globalData.selectedDate,
                                          MealType.lunch.korName
                                              .substring(0, 2),
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
                                        borderRadius: BorderRadius.circular(20.w),
                                        color: Colors.white,
                                      ),
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            width: screenWidth - 2 * paddingValue,
                                            height: 216.w,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20.w),
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
                                                            height: min(43.w, 86),
                                                            width: min(19.w, 38),
                                                          ),
                                                          Text(
                                                            "클릭하여 식사를 기록해 보세요",
                                                            style: TextStyle(
                                                              color: const Color(
                                                                  0xff9397A4),
                                                              fontSize: min(14.sp, 24),
                                                            ),
                                                          )
                                                        ],
                                                )),
                                          ),
                                          Positioned(
                                            top: 20.h,
                                            left: 20.w,
                                            child: Container(
                                              width: 58.w,
                                              height: 23.w,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.w),
                                                color: const Color(0xffF7F7FA),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  MealType.lunch.korName,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: min(12.sp, 22),
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
                              height: 15.w,
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
                                          width: screenWidth - 2 * paddingValue,
                                          height: 216.w,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20.w),
                                            child: Image.network(
                                              dinnerImageUrl!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 20.h,
                                          left: 20.w,
                                          child: Container(
                                            width: 58.w,
                                            height: 23.w,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.w),
                                              color: Colors.white,
                                            ),
                                            child: Center(
                                              child: Text(
                                                MealType.dinner.korName,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: min(12.sp, 22),
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
                                        final imageUrl =
                                            await imageApiService.uploadImage(
                                                context, selectedImage);
                                        await momMealViewModel.recordMeals(
                                          context,
                                          globalData.selectedDate,
                                          MealType.dinner.korName
                                              .substring(0, 2),
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
                                        borderRadius: BorderRadius.circular(20.w),
                                        color: Colors.white,
                                      ),
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            width: screenWidth - 2 * paddingValue,
                                            height: 216.w,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20.w),
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
                                                            height: min(43.w, 86),
                                                            width: min(19.w, 38),
                                                          ),
                                                          Text(
                                                            "클릭하여 식사를 기록해 보세요",
                                                            style: TextStyle(
                                                              color: const Color(
                                                                  0xff9397A4),
                                                              fontSize: min(14.sp, 24),
                                                            ),
                                                          )
                                                        ],
                                                )),
                                          ),
                                          Positioned(
                                            top: 20.h,
                                            left: 20.w,
                                            child: Container(
                                              width: 58.w,
                                              height: 23.w,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.w),
                                                color: const Color(0xffF7F7FA),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  MealType.dinner.korName,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: min(12.sp, 22),
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
                                SizedBox(height: 60.w),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              });
        }));
  }
}
