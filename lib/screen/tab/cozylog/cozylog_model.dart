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

class CozyLogSearchResponse {
  final List<CozyLogSearchResult> results;
  final int totalElements;

  CozyLogSearchResponse({
    required this.results,
    required this.totalElements,
  });
}

class CozyLogSearchResult {
  final int id;
  final String title;
  final String summary;
  final String date;
  final int commentCount;
  final int scrapCount;
  final String? imageUrl;
  final int imageCount;

  CozyLogSearchResult({
    required this.id,
    required this.title,
    required this.summary,
    required this.date,
    required this.commentCount,
    required this.scrapCount,
    required this.imageUrl,
    required this.imageCount,
  });
}

enum CozyLogSearchSortType {
  comment("댓글순"),
  time("최신순");

  final String name;
  const CozyLogSearchSortType(this.name);
}