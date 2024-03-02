import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/month_calendar.dart';
import 'package:cozy_for_mom_frontend/common/widget/weekly_calendar.dart';
import 'package:cozy_for_mom_frontend/model/meal_model.dart';
import 'package:cozy_for_mom_frontend/screen/mom/alarm/alarm_setting.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:cozy_for_mom_frontend/service/mom_meal_api_service.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    MealApiService momMealViewModel =
        Provider.of<MealApiService>(context, listen: true);
    DateFormat dateFormat = DateFormat('aa hh:mm');
    DateTime now = DateTime.now(); // 현재 날짜
    String formattedDate = DateFormat('M.d E', 'ko_KR').format(now);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return FutureBuilder(
        future: momMealViewModel.getMeals(now),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            pregnantMeals = snapshot.data! as List<MealModel>;
            containsBreakfast = pregnantMeals.any(
                (meal) => meal.mealType == MealType.breakfast.engUpperCase);
            containsLunch = pregnantMeals
                .any((meal) => meal.mealType == MealType.lunch.engUpperCase);
            containsDinner = pregnantMeals
                .any((meal) => meal.mealType == MealType.dinner.engUpperCase);
            breakfastImageUrl = containsBreakfast
                ? pregnantMeals
                    .firstWhere((meal) =>
                        meal.mealType == MealType.breakfast.engUpperCase)
                    .imageUrl
                : null;
            lunchImageUrl = containsLunch
                ? pregnantMeals
                    .firstWhere(
                        (meal) => meal.mealType == MealType.lunch.engUpperCase)
                    .imageUrl
                : null;
            dinnerImageUrl = containsDinner
                ? pregnantMeals
                    .firstWhere(
                        (meal) => meal.mealType == MealType.dinner.engUpperCase)
                    .imageUrl
                : null;
          }
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent, // 로딩화면(circle)
            ));
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
                    Row(
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
                              formattedDate,
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
                                  backgroundColor: contentBoxTwoColor
                                      .withOpacity(0.0), // 팝업창 자체 색 : 투명
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
                    ),
                  ],
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      const WeeklyCalendar(),
                      const SizedBox(
                        height: 20,
                      ),
                      containsBreakfast // TODO List로 수정하면 좋을 듯
                          ? Stack(
                              children: [
                                SizedBox(
                                  width: screenWidth - 40,
                                  height: 216,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      pregnantMeals
                                          .firstWhere((meal) =>
                                              meal.mealType ==
                                              MealType.breakfast.engUpperCase)
                                          .imageUrl,
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
                                      borderRadius: BorderRadius.circular(8),
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
                                            MealType.breakfast.engUpperCase)
                                        .dateTime),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : InkWell(
                              onTap: () async {
                                final selectedImage = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);
                                setState(() {
                                  breakfastImageUrl = selectedImage?.path;
                                });
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
                          ? Stack(
                              children: [
                                SizedBox(
                                  width: screenWidth - 40,
                                  height: 216,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      pregnantMeals
                                          .firstWhere((meal) =>
                                              meal.mealType ==
                                              MealType.lunch.engUpperCase)
                                          .imageUrl,
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
                                      borderRadius: BorderRadius.circular(8),
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
                                            MealType.lunch.engUpperCase)
                                        .dateTime),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : InkWell(
                              // TODO 서버에 요청하여 imageUrl get 해야함
                              onTap: () async {
                                final selectedImage = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);
                                setState(() {
                                  lunchImageUrl = selectedImage?.path;
                                });
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
                          ? Stack(
                              children: [
                                SizedBox(
                                  width: screenWidth - 40,
                                  height: 216,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      pregnantMeals
                                          .firstWhere((meal) =>
                                              meal.mealType ==
                                              MealType.dinner.engUpperCase)
                                          .imageUrl,
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
                                      borderRadius: BorderRadius.circular(8),
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
                                            MealType.dinner.engUpperCase)
                                        .dateTime),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : InkWell(
                              // TODO 서버에 요청하여 imageUrl get 해야함
                              onTap: () async {
                                final selectedImage = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);
                                setState(() {
                                  dinnerImageUrl = selectedImage?.path;
                                });
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
            ),
          );
        });
  }
}
