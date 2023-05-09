import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiring_app/applications_module/bloc/job_applications_list_event.dart';
import 'package:hiring_app/applications_module/bloc/job_applications_list_state.dart';
import 'package:hiring_app/applications_module/model/job_application.dart';
import 'package:hiring_app/applications_module/repo/job_applications_repo.dart';

class JobApplicationsListBloc
    extends Bloc<JobApplicationsListEvent, JobApplicationsListState> {
  final JobApplicationsRepo _repo;
  List<JobApplication> _applications = [];

  static const List<String> applicationStatuses = [
    'Created',
    'Completed',
    'Accepted',
    'Rejected',
  ];

  JobApplicationsListBloc(this._repo) : super(JobApplicationsListInitial()) {
    on<JobApplicationsListInitalized>(
      (event, emit) async {
        try {
          await _repo.stubJobApplicationsJSON();
          _applications = await _repo.retrieveJobApplications();
          if (_applications.isEmpty) {
            emit(
              JobApplicationsListError(errorMessage: "There's no applications"),
            );
            return;
          }
          emit(JobApplicationsListLoaded(
            applications: _applications,
            applicationStatuses: applicationStatuses,
          ));
        } catch (e) {
          emit(
            JobApplicationsListError(
              errorMessage: e.toString(),
            ),
          );
        }
      },
    );

    on<JobApplicationsListDeleteApplicationEvent>((event, emit) async {
      _repo.deleteJobApplication(applicationId: event.applicationId);
    });

    on<JobApplicationsListUpdateApplicationEvent>((event, emit) async {
      _repo.updateJobApplicationStatus(
        applicationId: event.applicationId,
        applicationStatus: event.applicationStatus,
      );
      // TODO: Add updated state
      if (_applications.isEmpty) {
        return;
      }
      final index = _applications
          .indexWhere((element) => element.id == event.applicationId);
      if (index.isNegative) {
        return;
      }
      _applications[index].status = event.applicationStatus;
      emit(JobApplicationsListLoaded(
        applications: _applications,
        applicationStatuses: applicationStatuses,
      ));
    });
  }
}
