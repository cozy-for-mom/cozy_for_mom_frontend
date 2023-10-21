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
