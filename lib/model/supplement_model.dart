class PregnantSupplements {
  List<PregnantSupplement> supplements;

  PregnantSupplements(this.supplements);
}

class PregnantSupplement {
  int supplementId;
  String supplementName;
  int targetCount;
  int realCount;
  List<Record> records;

  PregnantSupplement(
      {required this.supplementId,
      required this.supplementName,
      required this.targetCount,
      required this.realCount,
      required this.records});

  factory PregnantSupplement.fromJson(Map<String, dynamic> json) {
    return PregnantSupplement(
      supplementId: json['supplementId'] as int,
      supplementName: json['supplementName'],
      targetCount: json['targetCount'] as int,
      realCount: json['realCount'] as int,
      records: (json['records'] as List)
          .map((recordJson) => Record.fromJson(recordJson))
          .toList(),
    );
  }
}

class Record {
  final int id;
  final DateTime datetime;

  Record({required this.id, required this.datetime});

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      id: json['id'],
      datetime: DateTime.parse(json['datetime']),
    );
  }
}
