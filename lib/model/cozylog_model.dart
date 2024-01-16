class CozyLog {
  final int id;
  final int commentCount;
  final int scrapCount;
  final int imageCount;
  final String title;
  final String summary;
  final String date;
  final String? imageUrl;
  final String mode;


  CozyLog(
      {required this.id,
      required this.commentCount,
      required this.scrapCount,
      required this.imageCount,
      required this.title,
      required this.summary,
      required this.date,
      this.imageUrl,
      this.mode = 'PRIVATE'});
      this.imageUrl});
}
