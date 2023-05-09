import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hiring_app/applications_module/bloc/job_applications_bloc.dart';
import 'package:hiring_app/applications_module/bloc/job_applications_list_event.dart';
import 'package:hiring_app/applications_module/bloc/job_applications_list_state.dart';
import 'package:hiring_app/applications_module/model/job_application.dart';
import 'package:hiring_app/applications_module/repo/job_applications_repo.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  final repositoryMock = JobApplicationsListRepoMock();
  final List<JobApplication> applications = [
    JobApplication(
      1,
      'Senior Backend engineer',
      'Mohamed',
      '12 days',
      '',
      'accepted',
      'senior level',
      '',
    )
  ];
  blocTest<JobApplicationsListBloc, JobApplicationsListState>(
    'emits JobApplicationsListError when JobApplicationsListInitalized is added - empty applications',
    build: () => JobApplicationsListBloc(repositoryMock),
    setUp: () {
      when(() => repositoryMock.stubJobApplicationsJSON())
          .thenAnswer((invocation) => Future.value());
      when(() => repositoryMock.retrieveJobApplications())
          .thenAnswer((invocation) => Future.value([]));
    },
    act: (bloc) => bloc.add(JobApplicationsListInitalized()),
    expect: () =>
        [JobApplicationsListError(errorMessage: "There's no applications")],
  );

  blocTest<JobApplicationsListBloc, JobApplicationsListState>(
      'emits JobApplicationsListLoaded when JobApplicationsListInitalized is added - filled applications',
      build: () => JobApplicationsListBloc(repositoryMock),
      setUp: () {
        when(() => repositoryMock.stubJobApplicationsJSON())
            .thenAnswer((invocation) => Future.value());
        when(() => repositoryMock.retrieveJobApplications()).thenAnswer(
            (invocation) => Future<List<JobApplication>>.value(applications));
      },
      act: (bloc) => bloc.add(JobApplicationsListInitalized()),
      expect: () => [
            JobApplicationsListLoaded(
              applications: applications,
              applicationStatuses: JobApplicationsListBloc.applicationStatuses,
            )
          ]);

  blocTest<JobApplicationsListBloc, JobApplicationsListState>(
    'when JobApplicationsListDeleteApplicationEvent is added - repo should delete application',
    build: () => JobApplicationsListBloc(repositoryMock),
    setUp: () {
      when(() => repositoryMock.deleteJobApplication(applicationId: 1))
          .thenAnswer((invocation) => anything);
    },
    act: (bloc) => bloc.add(
      JobApplicationsListDeleteApplicationEvent(applicationId: 1),
    ),
    verify: (bloc) => verify(
      () => repositoryMock.deleteJobApplication(applicationId: 1),
    ).called(1),
  );

  blocTest<JobApplicationsListBloc, JobApplicationsListState>(
    'when JobApplicationsListDeleteApplicationEvent is added - repo should delete application',
    build: () => JobApplicationsListBloc(repositoryMock),
    setUp: () {
      when(() => repositoryMock.stubJobApplicationsJSON())
          .thenAnswer((invocation) => Future.value());
      when(() => repositoryMock.retrieveJobApplications()).thenAnswer(
          (invocation) => Future<List<JobApplication>>.value(applications));
      when(() => repositoryMock.updateJobApplicationStatus(
          applicationId: 1, applicationStatus: 'Accepted')).thenAnswer(
        (invocation) => anything,
      );
    },
    act: (bloc) {
      bloc.add(JobApplicationsListInitalized());
      bloc.add(
        JobApplicationsListUpdateApplicationEvent(
          applicationId: 1,
          applicationStatus: 'Accepted',
        ),
      );
    },
    expect: () => [
      JobApplicationsListLoaded(
        applications: applications,
        applicationStatuses: JobApplicationsListBloc.applicationStatuses,
      )
    ],
    verify: (bloc) => verify(
      () => repositoryMock.updateJobApplicationStatus(
          applicationId: 1, applicationStatus: 'Accepted'),
    ).called(1),
  );
}

class JobApplicationsListRepoMock extends Mock implements JobApplicationsRepo {}
