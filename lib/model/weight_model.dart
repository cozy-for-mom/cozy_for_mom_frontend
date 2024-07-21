class PregnantWeights {
  List<PregnantWeight> weights;

  PregnantWeights({required this.weights});
}

class PregnantWeight {
  String endDate;
  double weight;

  PregnantWeight({required this.endDate, required this.weight});

  factory PregnantWeight.fromJson(Map<String, dynamic> json) {
    return PregnantWeight(
      endDate: json['endDate'] as String,
      weight: json['weight'] as double,
    );
  }
}
