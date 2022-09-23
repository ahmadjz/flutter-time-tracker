import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_null_safety/Services/database.dart';
import 'package:time_tracker_null_safety/app/home/job_entries/job_entries_page.dart';
import 'package:time_tracker_null_safety/app/home/jobs/job_list_tile.dart';
import 'package:time_tracker_null_safety/app/home/jobs/list_items_builder.dart';
import 'package:time_tracker_null_safety/app/home/models/job.dart';
import 'package:time_tracker_null_safety/app/home/jobs/edit_job_page.dart';
import 'package:time_tracker_null_safety/common_widgets/platform_exception_alert_dialog.dart';

class JobsPage extends StatelessWidget {
  // Future<void> _createJob(BuildContext context) async {
  //   try {
  //     final database = Provider.of<Database>(context, listen: false);
  //     await database.createJob(Job(name: 'Blogging', ratePerHour: 10));
  //   } on FirebaseException catch (e) {
  //     PlatformExceptionAlertDialog(
  //       title: 'Operation failed',
  //       exception: e,
  //     ).show(context);
  //   }
  // }
  Future<void> _delete(BuildContext context, Job job) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteJob(job);
    } on FirebaseException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jobs',
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () => EditJobPage.show(context, database: database),
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Job>(
          //or you can use flutter_slideable package instaed of dismissible
          itemBuilder: (context, job) => Dismissible(
            key: Key('job-${job.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, job),
            child: JobListTile(
              job: job,
              onTap: () => JobEntriesPage.show(context, job),
            ),
          ),
          snapshot: snapshot,
        );
      },
    );
  }
}
