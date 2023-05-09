import 'package:equatable/equatable.dart';
import 'package:hiring_app/applications_module/model/job_application.dart';

abstract class JobApplicationsListState extends Equatable {}

class JobApplicationsListInitial extends JobApplicationsListState {
  @override
  List<Object?> get props => [];
}

class JobApplicationsListLoaded extends JobApplicationsListState {
  final List<JobApplication> applications;
  final List<String> applicationStatuses;

  JobApplicationsListLoaded({
    required this.applications,
    required this.applicationStatuses,
  });

  @override
  List<Object?> get props => [
        applications,
        applicationStatuses,
      ];
}

class JobApplicationsListError extends JobApplicationsListState {
  final String errorMessage;

  JobApplicationsListError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
