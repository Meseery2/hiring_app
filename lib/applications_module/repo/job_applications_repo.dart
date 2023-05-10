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
}

class JobApplicationsRepoImpl extends JobApplicationsRepo {
  @override
  Future<List<JobApplication>> retrieveJobApplications() async {
    await _stubJobApplicationsJSON();
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
    final updatedApplication =
        applications[index].copyWith(status: applicationStatus);
    applications[index] = updatedApplication;
    final data = json.encode(applications);
    _jsonFile.then((file) => file.writeAsStringSync(data));
  }

  Future<File> get _jsonFile async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/job_applications.json');
    return file;
  }

  Future<void> _stubJobApplicationsJSON() async {
    // Only sub json response on the first run
    final isStubbed = await _jsonFile.then((file) => file.exists());
    if (isStubbed) {
      return;
    }
    try {
      final String response =
          await rootBundle.loadString('assets/job_applications.json');
      _jsonFile.then((file) => file.writeAsStringSync(response));
    } catch (e) {
      rethrow;
    }
  }
}
