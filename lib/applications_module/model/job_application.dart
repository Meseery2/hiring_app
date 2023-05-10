import 'package:equatable/equatable.dart';

class JobApplication extends Equatable {
  final int id;
  final String title;
  final String name;
  final String profileImage;
  final String timeAgo;
  final String experienceLevel;
  final String experienceLevelColor;
  final String status;

  const JobApplication(
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

  @override
  List<Object?> get props => [
        id,
        title,
        name,
        profileImage,
        timeAgo,
        experienceLevel,
        experienceLevelColor,
        status,
      ];

  JobApplication copyWith({
    int? id,
    String? title,
    String? name,
    String? profileImage,
    String? timeAgo,
    String? experienceLevel,
    String? experienceLevelColor,
    String? status,
  }) =>
      JobApplication(
        id ?? this.id,
        title ?? this.title,
        name ?? this.name,
        timeAgo ?? this.timeAgo,
        profileImage ?? this.profileImage,
        status ?? this.status,
        experienceLevel ?? this.experienceLevel,
        experienceLevelColor ?? this.experienceLevelColor,
      );
}
