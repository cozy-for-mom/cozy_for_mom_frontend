class MealModel {
  int? id;
  DateTime dateTime;
  String mealType;
  String imageUrl;

  MealModel({
    this.id,
    required this.dateTime,
    required this.mealType,
    required this.imageUrl,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
        id: json['mealId'] as int,
        dateTime: DateTime.parse(json['dateTime']),
        mealType: json['mealType'] as String,
        imageUrl: json['mealImageUrl'] as String);
  }
}

enum MealType {
  breakfast("아침식사"),
  lunch("점심식사"),
  dinner("저녁식사");

  final String korName;
  const MealType(this.korName);
}
