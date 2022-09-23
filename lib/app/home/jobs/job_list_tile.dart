import 'package:flutter/material.dart';
import 'package:time_tracker_null_safety/app/home/models/job.dart';

class JobListTile extends StatelessWidget {
  final Job job;
  final VoidCallback onTap;

  const JobListTile({required this.job, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(job.name!),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
