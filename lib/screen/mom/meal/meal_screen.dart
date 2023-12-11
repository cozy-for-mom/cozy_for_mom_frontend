import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/month_calendar.dart';
import 'package:cozy_for_mom_frontend/common/widget/weekly_calendar.dart';
import 'package:cozy_for_mom_frontend/model/meal_model.dart';
import 'package:cozy_for_mom_frontend/screen/mom/alarm/alarm_setting.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class MealScreen extends StatefulWidget {
  const MealScreen({super.key});

  @override
  State<MealScreen> createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now(); // 현재 날짜
    String formattedDate = DateFormat('M.d E', 'ko_KR').format(now);
    List<MealModel> meals = [
      MealModel(
          dateTime: DateTime.parse("2023-12-10T09:00:00"),
          mealType: MealType.breakfast,
          imageUrl:
              "https://t1.daumcdn.net/thumb/R720x0/?fname=http://t1.daumcdn.net/brunch/service/user/2a4t/image/w_yQeuiLSMJCqBEn7wiD__r07T4.jpg"),
      MealModel(
          dateTime: DateTime.parse("2023-12-10T13:00:00"),
          mealType: MealType.lunch,
          imageUrl:
              "https://homecuisine.co.kr/files/attach/images/140/568/068/1a35dcd464cc1c5520b7b4a8c4ed7532.JPG"),
    ];

    bool containsBreakfast =
        meals.any((meal) => meal.mealType == MealType.breakfast);
    bool containsLunch = meals.any((meal) => meal.mealType == MealType.lunch);
    bool containsDinner = meals.any((meal) => meal.mealType == MealType.dinner);

    var dinnerImageUrl = containsDinner
        ? meals
            .firstWhere((element) => element.mealType == MealType.dinner)
            .imageUrl
        : null;
    var lunchImageUrl = containsDinner
        ? meals
            .firstWhere((element) => element.mealType == MealType.lunch)
            .imageUrl
        : null;
    var breakfastImageUrl = containsDinner
        ? meals
            .firstWhere((element) => element.mealType == MealType.breakfast)
            .imageUrl
        : null;

    return Scaffold(
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
                          image: AssetImage('assets/images/icons/alert.png'),
                          height: 32,
                          width: 32),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AlarmSettingPage(
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
                            width: 350,
                            height: 216,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                meals
                                    .firstWhere(
                                      (meal) =>
                                          meal.mealType == MealType.breakfast,
                                    )
                                    .imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 20,
                            left: 20,
                            child: Container(
                              width: 70,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: Center(
                                  child: Text(
                                    MealType.breakfast.korName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
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
                        child: Stack(
                          children: [
                            SizedBox(
                              width: 350,
                              height: 216,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                width: 70,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: const Color(0xffF7F7FA),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Center(
                                    child: Text(
                                      MealType.dinner.korName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: Color(0xff858998),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                const SizedBox(
                  height: 20,
                ),
                containsLunch
                    ? Stack(
                        children: [
                          SizedBox(
                            width: 350,
                            height: 216,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                meals
                                    .firstWhere(
                                      (meal) => meal.mealType == MealType.lunch,
                                    )
                                    .imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                              top: 20,
                              left: 20,
                              child: Container(
                                width: 70,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Center(
                                    child: Text(
                                      MealType.lunch.korName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
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
                        child: Stack(
                          children: [
                            SizedBox(
                              width: 350,
                              height: 216,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                width: 70,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: const Color(0xffF7F7FA),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Center(
                                    child: Text(
                                      MealType.dinner.korName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: Color(0xff858998),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                const SizedBox(
                  height: 20,
                ),
                containsDinner
                    ? Stack(
                        children: [
                          SizedBox(
                            width: 350,
                            height: 216,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                meals
                                    .firstWhere(
                                      (meal) =>
                                          meal.mealType == MealType.dinner,
                                    )
                                    .imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 20,
                            left: 20,
                            child: Container(
                              width: 70,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: Center(
                                  child: Text(
                                    MealType.dinner.korName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
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
                        child: Stack(
                          children: [
                            SizedBox(
                              width: 350,
                              height: 216,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                width: 70,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: const Color(0xffF7F7FA),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Center(
                                    child: Text(
                                      MealType.dinner.korName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: Color(0xff858998),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
