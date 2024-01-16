class BabyProfile {
  final int babyId;
  final String name;
  final String image;
  bool isProfileSelected = false; // 프로필 선택 상태를 저장

  BabyProfile(
      {required this.babyId,
      required this.name,
      required this.image,
      this.isProfileSelected = false});
}

class BabyGrow {
  final double weight;
  final double headDiameter;
  final double headCircumference;
  final double abdomenCircumference;
  final double thighLength;

  BabyGrow(
      {required this.weight,
      required this.headDiameter,
      required this.headCircumference,
      required this.abdomenCircumference,
      required this.thighLength});
}
