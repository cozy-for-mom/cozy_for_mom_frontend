class CozyLog {
  final int id;
  final int commentCount;
  final int scrapCount;
  final int imageCount;
  final String title;
  final String summary;
  final String date;
  final String? imageUrl;
  final bool range;

  CozyLog(
      {required this.id,
      required this.commentCount,
      required this.scrapCount,
      required this.imageCount,
      required this.title,
      required this.summary,
      required this.date,
      this.imageUrl,
      this.range = false});
}
