class PregnantBloosdugars {
  List<PregnantBloosdugar> bloodsugars;

  PregnantBloosdugars({required this.bloodsugars});
}

class PregnantBloosdugar {
  int id;
  String type;
  int level;

  PregnantBloosdugar(
      {required this.id, required this.type, required this.level});

  factory PregnantBloosdugar.fromJson(Map<String, dynamic> json) {
    return PregnantBloosdugar(
        id: json['id'] as int,
        type: json['type'] as String,
        level: json['level'] as int);
  }
}

class BloodsugarPerPeriod {
  String endDate;
  double averageLevel;

  BloodsugarPerPeriod({required this.endDate, required this.averageLevel});

  factory BloodsugarPerPeriod.fromJson(Map<String, dynamic> json) {
    return BloodsugarPerPeriod(
        endDate: json['endDate'] as String,
        averageLevel: json['averageLevel'] as double);
  }
}
