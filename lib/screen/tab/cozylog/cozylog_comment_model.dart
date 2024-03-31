class CozyLogComment {
  final int commentId;
  final int? parentId;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int writerId;
  final String writerNickname;
  final String? writerImageUrl;
  final List<CozyLogComment>? subComments;

  CozyLogComment({
    required this.commentId,
    required this.parentId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.writerId,
    required this.writerNickname,
    required this.writerImageUrl,
    required this.subComments,
  });

  factory CozyLogComment.fromJson(Map<String, dynamic> json) {
    List<dynamic> subComments = json['childComment'];
    return CozyLogComment(
      commentId: json['commentId'],
      parentId: json['parentId'],
      content: json['comment'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      writerId: json['writerId'],
      writerNickname: json['writerNickname'],
      writerImageUrl: json['writerImageUrl'],
      subComments: subComments
          .map((comment) => CozyLogComment.fromJson(comment))
          .toList(),
    );
  }
}
