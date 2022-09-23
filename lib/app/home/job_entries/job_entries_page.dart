import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_null_safety/Services/database.dart';
import 'package:time_tracker_null_safety/app/home/job_entries/entry_list_item.dart';
import 'package:time_tracker_null_safety/app/home/job_entries/entry_page.dart';
import 'package:time_tracker_null_safety/app/home/jobs/edit_job_page.dart';
import 'package:time_tracker_null_safety/app/home/jobs/list_items_builder.dart';
import 'package:time_tracker_null_safety/app/home/models/entry.dart';
import 'package:time_tracker_null_safety/app/home/models/job.dart';
import 'package:time_tracker_null_safety/common_widgets/platform_exception_alert_dialog.dart';

class JobEntriesPage extends StatelessWidget {
  const JobEntriesPage({required this.database, required this.job});
  final Database database;
  final Job job;

  static Future<void> show(BuildContext context, Job job) async {
    final Database database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => JobEntriesPage(database: database, job: job),
      ),
    );
  }

  Future<void> _deleteEntry(BuildContext context, Entry entry) async {
    try {
      await database.deleteEntry(entry);
    } on FirebaseException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Job>(
        stream: database.jobStream(jobID: job.id),
        builder: (context, snapshot) {
          final job = snapshot.data;
          final jobName = job?.name ?? '';
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 2.0,
              title: Text(jobName),
              actions: <Widget>[
                IconButton(
                  onPressed: () =>
                      EditJobPage.show(context, job: job, database: database),
                  icon: Icon(Icons.edit, color: Colors.white),
                ),
                IconButton(
                  onPressed: () => EntryPage.show(
                      context: context, database: database, job: job),
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            body: _buildContent(context, job),
          );
        });
  }

  Widget _buildContent(BuildContext context, Job? job) {
    return StreamBuilder<List<Entry>>(
      stream: database.entriesStream(job: job),
      builder: (context, snapshot) {
        return ListItemsBuilder<Entry>(
          snapshot: snapshot,
          itemBuilder: (context, entry) {
            return DismissibleEntryListItem(
              key: Key('entry-${entry.id}'),
              entry: entry,
              job: job,
              onDismissed: () => _deleteEntry(context, entry),
              onTap: () => EntryPage.show(
                context: context,
                database: database,
                job: job,
                entry: entry,
              ),
            );
          },
        );
      },
    );
  }
}
