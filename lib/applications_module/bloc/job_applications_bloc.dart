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
        } catch (exception) {
          emit(
            JobApplicationsListError(
              errorMessage: exception.toString(),
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

      final index = _applications
          .indexWhere((element) => element.id == event.applicationId);
      if (index.isNegative) {
        return;
      }
      final updatedApplication = _applications[index].copyWith(
        status: event.applicationStatus,
      );
      _applications[index] = updatedApplication;
      emit(JobApplicationsListUpdated(
        applications: _applications,
        applicationStatuses: applicationStatuses,
      ));
    });
  }
}
