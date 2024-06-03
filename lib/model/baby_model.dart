class BabyProfile {
  final int id;
  final String name;
  final String image;
  bool isProfileSelected = false; // 프로필 선택 상태를 저장

  BabyProfile(
      {required this.id,
      required this.name,
      required this.image,
      this.isProfileSelected = false});
}
