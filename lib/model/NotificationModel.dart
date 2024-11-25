class NotificationModel {
  final int notifyId;
  final int userFrom;
  final int notifyFor;
  final String notifyType;
  final String? description;
  final String notifiedTime;
  final int? postId;
  final bool isView;

  NotificationModel({
    required this.notifyId,
    required this.userFrom,
    required this.notifyFor,
    required this.notifyType,
    this.description,
    required this.notifiedTime,
    this.postId,
    required this.isView,
  });

  // Method to convert JSON data to a NotificationModel object
  static NotificationModel fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notifyId: json['notifyid'],
      userFrom: json['userfrom'],
      notifyFor: json['notifyfor'],
      notifyType: json['notifytype'],
      description: json['description'],
      notifiedTime: json['notifiedtime'],
      postId: json['postid'],
      isView: json['isView'] == "yes",
    );
  }
}
