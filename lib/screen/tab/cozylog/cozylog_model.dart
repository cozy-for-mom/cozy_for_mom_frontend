class CozyLog {
  final int? cozyLogId;
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

  factory CozyLog.fromJson(Map<String, dynamic> json) {
    late CozyLogModeType mode;
    if (json['mode'] == 'PUBLIC') {
      mode = CozyLogModeType.public;
    } else {
      mode = CozyLogModeType.private;
    }
    List<dynamic> imageList = json['imageList'];
    return CozyLog(
      cozyLogId: json['id'],
      writer: CozyLogWriter.fromJson(json['writer']),
      imageList:
          imageList.map((image) => CozyLogImage.fromJson(image)).toList(),
      title: json['title'],
      content: json['content'],
      mode: mode,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      scrapCount: json['scrapCount'],
      viewCount: json['viewCount'],
      isScrapped: json['scraped'],
    );
  }
}

class CozyLogForList {
  final int cozyLogId;
  final String title;
  final String summary;
  final CozyLogModeType mode;
  final DateTime date; // 생성일? 수정일?
  final int commentCount;
  final int scrapCount;
  final int imageCount;
  final String imageUrl;

  CozyLogForList({
    required this.cozyLogId,
    required this.title,
    required this.summary,
    required this.mode,
    required this.date,
    required this.commentCount,
    required this.scrapCount,
    required this.imageCount,
    required this.imageUrl,
  });

  factory CozyLogForList.fromJson(Map<String, dynamic> json) {
    late CozyLogModeType mode;
    if (json['mode'] == 'PUBLIC') {
      mode = CozyLogModeType.public;
    } else {
      mode = CozyLogModeType.private;
    }
    return CozyLogForList(
      cozyLogId: json['id'],
      date: DateTime.parse(json['date']),
      title: json['title'],
      summary: json['summary'],
      mode: mode,
      commentCount: json['commentCount'],
      scrapCount: json['scrapCount'],
      imageCount: json['imageCount'],
      imageUrl: json['imageUrl'],
    );
  }
}

enum CozyLogModeType { public, private }

class CozyLogImage {
  final int imageId;
  final String imageUrl;
  final String description;

  CozyLogImage({
    required this.imageId,
    required this.imageUrl,
    required this.description,
  });

  factory CozyLogImage.fromJson(Map<String, dynamic> json) {
    return CozyLogImage(
      imageId: json['imageId'],
      imageUrl: json['imageUrl'],
      description: json['description'],
    );
  }
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

  factory CozyLogWriter.fromJson(Map<String, dynamic> json) {
    return CozyLogWriter(
      id: json['id'],
      nickname: json['nickname'],
      imageUrl: json['imageUrl'],
    );
  }
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
