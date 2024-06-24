class CozyLog {
  final int id;
  final int commentCount;
  final int scrapCount;
  final int imageCount;
  final String title;
  final String summary;
  final String date;
  final List<CozyLogImage> images;
  final String mode;

  CozyLog({
    required this.id,
    required this.commentCount,
    required this.scrapCount,
    required this.imageCount,
    required this.title,
    required this.summary,
    required this.date,
    required this.images,
    this.mode = 'PRIVATE',
  });
}

class CozyLogImage {
  final int? imageId;
  final String imageUrl;
  final String description;

  CozyLogImage({
    required this.imageId,
    required this.imageUrl,
    required this.description,
  });
}
