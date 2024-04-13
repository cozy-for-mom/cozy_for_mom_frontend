class PregnantWeights {
  List<PregnantWeight> weights;

  PregnantWeights({required this.weights});
}

class PregnantWeight {
  String dateTime;
  double weight;

  PregnantWeight({required this.dateTime, required this.weight});

  factory PregnantWeight.fromJson(Map<String, dynamic> json) {
    return PregnantWeight(
      weight: json['weight'] as double,
      dateTime: json['endDate'] as String,
    );
  }
}
