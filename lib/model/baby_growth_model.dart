class BabyProfileGrowth {
  final int? id;
  final DateTime date;
  final String growthImageUrl;
  final String diary;
  final String title;
  final List<BabyGrowth>? babies;

  BabyProfileGrowth({
    required this.id,
    required this.date,
    required this.growthImageUrl,
    required this.diary,
    required this.title,
    this.babies,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(), // DateTime 객체를 ISO8601 문자열로 변환
      'growthImageUrl': growthImageUrl,
      'diary': diary,
      'title': title,
      'babies': babies
          ?.map((baby) => baby.toJson())
          .toList(), // BabyGrowth 객체 리스트를 맵 리스트로 변환
    };
  }

  factory BabyProfileGrowth.fromJson(Map<String, dynamic> json) {
    var list = json['babies'] as List?;
    List<BabyGrowth>? babyList =
        list?.map((i) => BabyGrowth.fromJson(i)).toList();

    return BabyProfileGrowth(
      id: json['id'],
      date: DateTime.parse(json['date']),
      growthImageUrl: json['imageUrl'],
      diary: json['content'],
      title: json['title'],
      babies: babyList,
    );
  }
}

class BabyGrowth {
  final int? id;
  final int babyId;
  final BabyGrowthInfo babyGrowthInfo;

  BabyGrowth({
    this.id,
    required this.babyId,
    required this.babyGrowthInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'babyId': babyId,
      'babyGrowthInfo': babyGrowthInfo.toJson(), // BabyGrowthInfo 객체를 JSON으로 변환
    };
  }

  // 기존의 fromJson 메서드는 유지
  factory BabyGrowth.fromJson(Map<String, dynamic> json) {
    return BabyGrowth(
      id: json['id'],
      babyId: json['babyId'],
      babyGrowthInfo: BabyGrowthInfo.fromJson(json['babyGrowthInfo']),
    );
  }
}

class BabyGrowthInfo {
  final double weight;
  final double headDiameter;
  final double headCircum;
  final double abdomenCircum;
  final double thighLength;

  BabyGrowthInfo({
    required this.weight,
    required this.headDiameter,
    required this.headCircum,
    required this.abdomenCircum,
    required this.thighLength,
  });

  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'headDiameter': headDiameter,
      'headCircum': headCircum,
      'abdomenCircum': abdomenCircum,
      'thighLength': thighLength,
    };
  }

  factory BabyGrowthInfo.fromJson(Map<String, dynamic> json) {
    return BabyGrowthInfo(
      weight: json['weight'].toDouble(),
      headDiameter: json['headDiameter'].toDouble(),
      headCircum: json['headCircum'].toDouble(),
      abdomenCircum: json['abdomenCircum'].toDouble(),
      thighLength: json['thighLength'].toDouble(),
    );
  }
}
