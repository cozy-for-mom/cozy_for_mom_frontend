class User {
  // TODO 마이페이지 응답 데이터로 수정 필요
  final String name;
  final String nickname;
  final String introduce;
  final String? imageUrl;
  final String birth;  // TODO 백엔드 수정 후, 생년월일 필드 삭제
  final String email;
  final BabyProfile babyProfile;
  final BabyProfile recentBabyProfile;
  final int dDay;

  User(
      {required this.name,
      required this.nickname,
      required this.introduce,
      this.imageUrl,
      required this.birth,
      required this.email,
      required this.babyProfile,
      required this.recentBabyProfile,
      required this.dDay});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      nickname: json['nickname'],
      introduce: json['introduce'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      birth: json['birth'],
      email: json['email'] ?? '',
      babyProfile: BabyProfile.fromJson(json['babyProfile']),
      recentBabyProfile: BabyProfile.fromJson(json['recentBabyProfile']),
      dDay: json['dDay'],
    );
  }
}

class Baby {
  final int babyId;
  final String babyName;

  Baby({required this.babyId, required this.babyName});

  factory Baby.fromJson(Map<String, dynamic> json) {
    return Baby(babyId: json['babyId'], babyName: json['name']);
  }
}

class BabyProfile {
  final int babyProfileId;
  final String? babyProfileImageUrl;
  final List<Baby> babies;

  BabyProfile(
      {required this.babyProfileId,
      this.babyProfileImageUrl = '',
      required this.babies});

  factory BabyProfile.fromJson(Map<String, dynamic> json) {
    return BabyProfile(
      babyProfileId: json['babyProfileId'],
      babyProfileImageUrl: json['babyProfileImageUrl'] ?? '',
      babies: (json['babies'] as List)
          .map((babyJson) => Baby.fromJson(babyJson))
          .toList(),
    );
  }
}
