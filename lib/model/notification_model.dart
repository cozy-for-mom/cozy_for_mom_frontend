class NotificationModel {
  final int id;
  final bool isActive;
  final String type;
  final String title;
  final String notifyAt;
  final List<String> targetTimeAt;
  final List<String> daysOfWeek;

  NotificationModel({
    this.id = 0,
    required this.isActive,
    required this.type,
    required this.title,
    required this.notifyAt,
    required this.targetTimeAt,
    required this.daysOfWeek,
  });

  // JSON에서 객체로 변환하는 팩토리 생성자
  factory NotificationModel.fromJson(Map<String, dynamic> json, String type) {
    return NotificationModel(
      id: json['id'],
      isActive: json['isActive'],
      type: type,
      title: json['title'],
      notifyAt: json['notifyAt'],
      targetTimeAt: List<String>.from(json['targetTimeAt']),
      daysOfWeek: List<String>.from(json['daysOfWeek']),
    );
  }
}
