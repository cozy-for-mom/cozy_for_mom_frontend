class Supplements {
  List<PregnantSupplement> supplement;

  Supplements(this.supplement);
}

class PregnantSupplement {
  String supplementName;
  int targetCount;
  int realCount;
  List<DateTime> takeTimes;

  PregnantSupplement(
      {required this.supplementName,
      required this.targetCount,
      required this.realCount,
      required this.takeTimes});
}
