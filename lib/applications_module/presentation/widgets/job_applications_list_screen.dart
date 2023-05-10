import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiring_app/applications_module/bloc/job_applications_bloc.dart';
import 'package:hiring_app/applications_module/bloc/job_applications_list_event.dart';
import 'package:hiring_app/applications_module/bloc/job_applications_list_state.dart';
import 'package:hiring_app/applications_module/model/job_application.dart';
import 'package:hiring_app/applications_module/repo/job_applications_repo.dart';

class JobApplicationsListScreen extends StatefulWidget {
  const JobApplicationsListScreen({Key? key}) : super(key: key);

  @override
  JobApplicationsListScreenState createState() =>
      JobApplicationsListScreenState();
}

class JobApplicationsListScreenState extends State<JobApplicationsListScreen> {
  late JobApplicationsListBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = JobApplicationsListBloc(JobApplicationsRepoImpl());
    _bloc.add(JobApplicationsListInitalized());
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      BlocBuilder<JobApplicationsListBloc, JobApplicationsListState>(
        key: const Key('job_applications_list'),
        builder: _onStateBuilder,
        bloc: _bloc,
      );

  Widget _onStateBuilder(
    BuildContext context,
    JobApplicationsListState state,
  ) {
    if (state is JobApplicationsListLoaded) {
      return _onStateLoadedWidget(state: state);
    } else if (state is JobApplicationsListUpdated) {
      return _onStateUpdatedWidget(state: state);
    } else if (state is JobApplicationsListError) {
      return _onStateErrorWidget(state: state);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _onStateLoadedWidget({
    required JobApplicationsListLoaded state,
  }) =>
      _buildApplicationsList(
        applications: state.applications,
        applicationStatuses: state.applicationStatuses,
      );

// TODO: differentiate between loaded/updated states
  Widget _onStateUpdatedWidget({
    required JobApplicationsListUpdated state,
  }) =>
      _buildApplicationsList(
        applications: state.applications,
        applicationStatuses: state.applicationStatuses,
      );

  Scaffold _buildApplicationsList({
    required List<JobApplication> applications,
    required List<String> applicationStatuses,
  }) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: const Text('Applications'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: applications.length,
        itemBuilder: (context, position) => Dismissible(
          key: Key(applications[position].toString()),
          background: _slideRightBackground(),
          secondaryBackground: _slideLeftBackground(),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Delete"),
                ),
              );
              _bloc.add(
                JobApplicationsListDeleteApplicationEvent(
                  applicationId: applications[position].id,
                ),
              );
            }
          },
          child: jobApplicationnComponent(
            application: applications[position],
            applicationStatuses: applicationStatuses,
          ),
        ),
      ),
    );
  }

// TODO: Add error state widget
  Widget _onStateErrorWidget({
    required JobApplicationsListError state,
  }) =>
      const SizedBox.shrink();

  Widget jobApplicationnComponent({
    required JobApplication application,
    required List<String> applicationStatuses,
  }) =>
      Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(application.profileImage),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(application.name,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(application.title,
                                style: TextStyle(color: Colors.grey[500])),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                PopupMenuButton(
                  itemBuilder: (context) {
                    final values = applicationStatuses.map(
                      (status) {
                        return PopupMenuItem(
                          value: status,
                          child: Text(status),
                        );
                      },
                    ).toList();
                    return values;
                  },
                  onSelected: (String value) {
                    _actionPopUpItemSelected(
                      applicationId: application.id,
                      statusValue: value,
                    );
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 15,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        application.status,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 15,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color(
                          int.parse(
                            "0xff${application.experienceLevelColor}",
                          ),
                        ).withAlpha(20),
                      ),
                      child: Text(
                        application.experienceLevel,
                        style: TextStyle(
                          color: Color(
                            int.parse(
                                "0xff${application.experienceLevelColor}"),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  application.timeAgo,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 12,
                  ),
                )
              ],
            )
          ],
        ),
      );

  Widget _slideRightBackground() => Container(
        color: Colors.green,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const <Widget>[
              SizedBox(
                width: 20,
              ),
              Icon(
                Icons.edit,
                color: Colors.white,
              ),
              Text(
                "Edit",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      );

  Widget _slideLeftBackground() => Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.edit),
                color: Colors.white,
                onPressed: () {
                  setState(() {});
                },
              ),
              const Text(
                "Delete",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
        ),
      );

  void _actionPopUpItemSelected({
    required int applicationId,
    required String statusValue,
  }) =>
      _bloc.add(
        JobApplicationsListUpdateApplicationEvent(
          applicationId: applicationId,
          applicationStatus: statusValue,
        ),
      );
}
