import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:hiring_app/applications_module/model/job_application.dart';
import 'package:path_provider/path_provider.dart';

abstract class JobApplicationsRepo {
  Future<List<JobApplication>> retrieveJobApplications();
  void deleteJobApplication({required int applicationId});
  void updateJobApplicationStatus({
    required int applicationId,
    required String applicationStatus,
  });
  Future<void> stubJobApplicationsJSON();
}

class JobApplicationsRepoImpl implements JobApplicationsRepo {
  @override
  Future<List<JobApplication>> retrieveJobApplications() async {
    final response = await _jsonFile.then((file) => file.readAsString());
    final data = await json.decode(response);

    final applications = List<JobApplication>.from(
      data.map(
        (data) => JobApplication.fromJson(data),
      ),
    );
    return applications;
  }

  @override
  void deleteJobApplication({required int applicationId}) async {
    final applications = await retrieveJobApplications();
    applications.retainWhere((application) => application.id != applicationId);
    final data = json.encode(applications);
    _jsonFile.then((file) => file.writeAsStringSync(data));
  }

  @override
  void updateJobApplicationStatus({
    required int applicationId,
    required String applicationStatus,
  }) async {
    final applications = await retrieveJobApplications();
    final index =
        applications.indexWhere((element) => element.id == applicationId);
    applications[index].status = applicationStatus;
    final data = json.encode(applications);
    _jsonFile.then((file) => file.writeAsStringSync(data));
  }

  Future<File> get _jsonFile async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/job_applications.json');
    return file;
  }

  @override
  Future<void> stubJobApplicationsJSON() async {
    // Only sub json response on the first run
    final isStubbed = await _jsonFile.then((file) => file.exists());
    if (isStubbed) {
      return;
    }
    final String response =
        await rootBundle.loadString('assets/job_applications.json');
    _jsonFile.then((file) => file.writeAsStringSync(response));
  }
}
