class CozyLog {
  final int cozyLogId;
  final CozyLogWriter writer;
  final String title;
  final String content;
  final List<CozyLogImage> imageList;
  final CozyLogModeType mode;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int scrapCount;
  final int viewCount;
  final bool isScrapped;

  CozyLog({
    required this.cozyLogId,
    required this.writer,
    required this.title,
    required this.content,
    required this.imageList,
    required this.mode,
    required this.createdAt,
    required this.updatedAt,
    required this.scrapCount,
    required this.viewCount,
    required this.isScrapped,
  });
}

enum CozyLogModeType { public, private }

class CozyLogImage {
  final String imageUrl;
  final String description;

  CozyLogImage({
    required this.imageUrl,
    required this.description,
  });
}

class CozyLogWriter {
  final int id;
  final String nickname;
  final String? imageUrl;

  CozyLogWriter({
    required this.id,
    required this.nickname,
    required this.imageUrl,
  });
}
