class JobApplication {
  final int id;
  final String title;
  final String name;
  final String profileImage;
  final String timeAgo;
  final String experienceLevel;
  final String experienceLevelColor;
  String status;

  JobApplication(
    this.id,
    this.title,
    this.name,
    this.timeAgo,
    this.profileImage,
    this.status,
    this.experienceLevel,
    this.experienceLevelColor,
  );

  factory JobApplication.fromJson(Map<String, dynamic> json) => JobApplication(
        json['id'],
        json['title'],
        json['name'],
        json['timeAgo'],
        json['profileImage'],
        json['status'],
        json['experienceLevel'],
        json['experienceLevelColor'],
      );

  Map toJson() => {
        'id': id,
        'title': title,
        'name': name,
        'timeAgo': timeAgo,
        'profileImage': profileImage,
        'status': status,
        'experienceLevel': experienceLevel,
        'experienceLevelColor': experienceLevelColor,
      };
}
