import 'dart:convert';

class UserInfo {
  final String? oauthType;
  final String name;
  final String nickname;
  final String birth;
  final String email;
  final String? deviceToken;

  UserInfo({
    this.oauthType,
    required this.name,
    required this.nickname,
    required this.birth,
    required this.email,
    this.deviceToken,
  });
  Map<String, dynamic> toJson() => {
        'oauthType': oauthType,
        'name': name,
        'nickname': nickname,
        'birth': birth,
        'email': email,
        'deviceToken': deviceToken,
      };
}

class Baby {
  final String name;
  final String gender;
  Baby({required this.name, required this.gender});
  Map<String, dynamic> toJson() => {
        'name': name,
        'gender': gender,
      };
  factory Baby.fromJson(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    return Baby(
      name: json['name'],
      gender: json['gender'],
    );
  }
}

class BabyInfo {
  final String dueAt;
  final String lastPeriodAt;
  final List<Baby> babies;
  BabyInfo(
      {required this.dueAt, required this.lastPeriodAt, required this.babies});
  Map<String, dynamic> toJson() => {
        'dueAt': dueAt,
        'lastPeriodAt': lastPeriodAt,
        'babies': babies.map((baby) => baby.toJson()).toList(),
      };
}
