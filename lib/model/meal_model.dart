class MealModel {
  DateTime dateTime;
  MealType mealType;
  String imageUrl;

  MealModel({
    required this.dateTime,
    required this.mealType,
    required this.imageUrl,
  });
}

enum MealType {
  breakfast("아침식사"),
  lunch("점심식사"),
  dinner("저녁식사");

  final String korName;
  const MealType(this.korName);
}
