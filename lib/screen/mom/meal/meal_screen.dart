import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/month_calendar.dart';
import 'package:cozy_for_mom_frontend/common/widget/weekly_calendar.dart';
import 'package:cozy_for_mom_frontend/model/global_state.dart';
import 'package:cozy_for_mom_frontend/model/meal_model.dart';
import 'package:cozy_for_mom_frontend/screen/mom/alarm/alarm_setting.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:cozy_for_mom_frontend/service/mom/mom_meal_api_service.dart';
import 'package:cozy_for_mom_frontend/service/image_api.dart';
import 'package:provider/provider.dart';
import 'package:cozy_for_mom_frontend/common/widget/select_bottom_modal.dart';
import 'package:cozy_for_mom_frontend/common/widget/delete_modal.dart';

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

  @override
  Widget build(BuildContext context) {
    MealApiService momMealViewModel =
        Provider.of<MealApiService>(context, listen: true);
    ImageApiService imageApiService = ImageApiService();
    final globalData = Provider.of<MyDataModel>(context, listen: false);
    DateFormat dateFormat = DateFormat('aa hh:mm');
    DateTime now = DateTime.now(); // 현재 날짜
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
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
                final selectedImage =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (selectedImage != null) {
                  final imageUrl =
                      await imageApiService.uploadImage(selectedImage);
                  await momMealViewModel.modifyMeals(id, globalData.selectedDay,
                      mealType.substring(0, 2), imageUrl);
                  setState(() {});
                } else {
                  print('No image selected.');
                }
              },
              tap2: () async {
                // 삭제 작업 수행
                await momMealViewModel.deleteWeight(id);
                Navigator.pop(context);
                // 상태 업데이트
                setState(() {});
              },
            );
          });
    }

    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size(400, 60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Consumer<MyDataModel>(builder: (context, globalData, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Row(
                        children: [
                          Text(
                            DateFormat('M.d E', 'ko_KR')
                                .format(globalData.selectedDate),
                            style: const TextStyle(
                              color: mainTextColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
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
                                  return const MonthCalendarModal();
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      IconButton(
                          icon: const Image(
                              image:
                                  AssetImage('assets/images/icons/alert.png'),
                              height: 32,
                              width: 32),
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
              future: momMealViewModel.getMeals(globalData.selectedDay),
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
                          const WeeklyCalendar(),
                          const SizedBox(
                            height: 20,
                          ),
                          containsBreakfast // TODO List로 수정하면 좋을 듯
                              ? InkWell(
                                  onTap: () {
                                    showSelectModal(breakfastId!,
                                        MealType.breakfast.korName);
                                  },
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        width: screenWidth - 40,
                                        height: 216,
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
                                        top: 20,
                                        left: 20,
                                        child: Container(
                                          width: 58,
                                          height: 23,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white,
                                          ),
                                          child: Center(
                                            child: Text(
                                              MealType.breakfast.korName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                color: primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 20,
                                        left: 20,
                                        child: Text(
                                          dateFormat.format(pregnantMeals
                                              .firstWhere((meal) =>
                                                  meal.mealType ==
                                                  MealType.breakfast.korName
                                                      .substring(0, 2))
                                              .dateTime),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ))
                              : InkWell(
                                  onTap: () async {
                                    final selectedImage = await ImagePicker()
                                        .pickImage(source: ImageSource.gallery);
                                    if (selectedImage != null) {
                                      final imageUrl = await imageApiService
                                          .uploadImage(selectedImage);
                                      await momMealViewModel.recordMeals(
                                        globalData.selectedDate,
                                        MealType.breakfast.korName
                                            .substring(0, 2),
                                        imageUrl,
                                      );
                                      setState(() {
                                        breakfastImageUrl = imageUrl;
                                      });
                                    } else {
                                      print('No image selected.');
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
                                          width: screenWidth - 40,
                                          height: 216,
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: const Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image(
                                                    image: AssetImage(
                                                      "assets/images/icons/default_meal.png",
                                                    ),
                                                    height: 43,
                                                    width: 19,
                                                  ),
                                                  Text(
                                                    "클릭하여 식사를 기록해 보세요",
                                                    style: TextStyle(
                                                      color: Color(0xff9397A4),
                                                      fontSize: 14,
                                                    ),
                                                  )
                                                ],
                                              )),
                                        ),
                                        Positioned(
                                          top: 20,
                                          left: 20,
                                          child: Container(
                                            width: 58,
                                            height: 23,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: const Color(0xffF7F7FA),
                                            ),
                                            child: Center(
                                              child: Text(
                                                MealType.breakfast.korName,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  color: Color(0xff858998),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          const SizedBox(
                            height: 20,
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
                                        width: screenWidth - 40,
                                        height: 216,
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
                                        top: 20,
                                        left: 20,
                                        child: Container(
                                          width: 58,
                                          height: 23,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white,
                                          ),
                                          child: Center(
                                            child: Text(
                                              MealType.lunch.korName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                color: primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 20,
                                        left: 20,
                                        child: Text(
                                          dateFormat.format(pregnantMeals
                                              .firstWhere((meal) =>
                                                  meal.mealType ==
                                                  MealType.lunch.korName
                                                      .substring(0, 2))
                                              .dateTime),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ))
                              : InkWell(
                                  onTap: () async {
                                    final selectedImage = await ImagePicker()
                                        .pickImage(source: ImageSource.gallery);
                                    if (selectedImage != null) {
                                      final imageUrl = await imageApiService
                                          .uploadImage(selectedImage);
                                      await momMealViewModel.recordMeals(
                                        globalData.selectedDate,
                                        MealType.lunch.korName.substring(0, 2),
                                        imageUrl,
                                      );
                                      setState(() {
                                        containsLunch = !containsLunch;
                                      });
                                    } else {
                                      print('No image selected.');
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
                                          width: screenWidth - 40,
                                          height: 216,
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: const Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image(
                                                    image: AssetImage(
                                                      "assets/images/icons/default_meal.png",
                                                    ),
                                                    height: 43,
                                                    width: 19,
                                                  ),
                                                  Text(
                                                    "클릭하여 식사를 기록해 보세요",
                                                    style: TextStyle(
                                                      color: Color(0xff9397A4),
                                                      fontSize: 14,
                                                    ),
                                                  )
                                                ],
                                              )),
                                        ),
                                        Positioned(
                                          top: 20,
                                          left: 20,
                                          child: Container(
                                            width: 58,
                                            height: 23,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: const Color(0xffF7F7FA),
                                            ),
                                            child: Center(
                                              child: Text(
                                                MealType.lunch.korName,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  color: Color(0xff858998),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          const SizedBox(
                            height: 20,
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
                                        width: screenWidth - 40,
                                        height: 216,
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
                                        top: 20,
                                        left: 20,
                                        child: Container(
                                          width: 58,
                                          height: 23,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white,
                                          ),
                                          child: Center(
                                            child: Text(
                                              MealType.dinner.korName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                color: primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 20,
                                        left: 20,
                                        child: Text(
                                          dateFormat.format(pregnantMeals
                                              .firstWhere((meal) =>
                                                  meal.mealType ==
                                                  MealType.dinner.korName
                                                      .substring(0, 2))
                                              .dateTime),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ))
                              : InkWell(
                                  onTap: () async {
                                    final selectedImage = await ImagePicker()
                                        .pickImage(source: ImageSource.gallery);
                                    if (selectedImage != null) {
                                      final imageUrl = await imageApiService
                                          .uploadImage(selectedImage);
                                      await momMealViewModel.recordMeals(
                                        globalData.selectedDate,
                                        MealType.dinner.korName.substring(0, 2),
                                        imageUrl,
                                      );
                                      setState(() {
                                        containsDinner = !containsDinner;
                                      });
                                    } else {
                                      print('No image selected.');
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
                                          width: screenWidth - 40,
                                          height: 216,
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: const Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image(
                                                    image: AssetImage(
                                                      "assets/images/icons/default_meal.png",
                                                    ),
                                                    height: 43,
                                                    width: 19,
                                                  ),
                                                  Text(
                                                    "클릭하여 식사를 기록해 보세요",
                                                    style: TextStyle(
                                                      color: Color(0xff9397A4),
                                                      fontSize: 14,
                                                    ),
                                                  )
                                                ],
                                              )),
                                        ),
                                        Positioned(
                                          top: 20,
                                          left: 20,
                                          child: Container(
                                            width: 58,
                                            height: 23,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: const Color(0xffF7F7FA),
                                            ),
                                            child: Center(
                                              child: Text(
                                                MealType.dinner.korName,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  color: Color(0xff858998),
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
