class PregnantSupplements {
  List<PregnantSupplement> supplement;

  PregnantSupplements(this.supplement);
}

class PregnantSupplement {
  int? supplementId;
  String supplementName;
  int targetCount;
  int realCount;
  List<DateTime> dateTimes;

  PregnantSupplement(
      {this.supplementId,
      required this.supplementName,
      required this.targetCount,
      required this.realCount,
      required this.dateTimes});

  factory PregnantSupplement.fromJson(Map<String, dynamic> json) {
    return PregnantSupplement(
      supplementId: json['supplementId'] as int,
      supplementName: json['supplementName'],
      targetCount: json['targetCount'] as int,
      realCount: json['realCount'] as int,
      dateTimes: List<DateTime>.from(
          json['datetimes'].map((dateTime) => DateTime.parse(dateTime))),
    );
  }
}
