abstract class JobApplicationsListEvent {}

class JobApplicationsListInitalized extends JobApplicationsListEvent {}

class JobApplicationsListDeleteApplicationEvent
    extends JobApplicationsListEvent {
  final int applicationId;

  JobApplicationsListDeleteApplicationEvent({
    required this.applicationId,
  });
}

class JobApplicationsListUpdateApplicationEvent
    extends JobApplicationsListEvent {
  final int applicationId;
  final String applicationStatus;

  JobApplicationsListUpdateApplicationEvent({
    required this.applicationId,
    required this.applicationStatus,
  });
}
