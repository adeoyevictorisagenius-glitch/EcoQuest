class QuestModel {
  final String questId;
  final String title;
  final String description;
  final String mediaUrl;
  final String issueType;
  final String severity;
  final double latitude;
  final double longitude;

  QuestModel({
    required this.questId,
    required this.title,
    required this.description,
    required this.mediaUrl,
    required this.issueType,
    required this.severity,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'questId': questId,
      'title': title,
      'description': description,
      'mediaUrl': mediaUrl,
      'issueType': issueType,
      'severity': severity,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': DateTime.now(),
    };
  }
}