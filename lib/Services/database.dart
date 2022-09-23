import 'package:time_tracker_null_safety/Services/api_path.dart';
import 'package:time_tracker_null_safety/Services/firestore_service.dart';
import 'package:time_tracker_null_safety/app/home/models/entry.dart';
import 'package:time_tracker_null_safety/app/home/models/job.dart';

abstract class Database {
  Future<void> setJob(Job job);
  Stream<List<Job>> jobsStream();
  Future<void> deleteJob(Job job);

  Future<void> setEntry(Entry entry);
  Future<void> deleteEntry(Entry entry);
  Stream<List<Entry>> entriesStream({Job? job});
  Stream<Job> jobStream({required String? jobID});
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid});
  final String uid;

  final _service = FirestoreService.instance;

  @override
  Future<void> setJob(Job job) async => await _service.setData(
        data: job.toMap(),
        path: APIPath.job(uid, job.id),
      );

  // before having entries
  // @override
  // Future<void> deleteJob(Job job) async =>
  //     _service.deleteData(path: APIPath.job(uid, job.id));

  // after having entries
  @override
  Future<void> deleteJob(Job job) async {
    //delete where entry.jobID == job.jobID
    final allEntries = await entriesStream(job: job).first;
    for (Entry entry in allEntries) {
      if (entry.jobId == job.id) {
        await deleteEntry(entry);
      }
    }
    // delete job
    await _service.deleteData(path: APIPath.job(uid, job.id));
  }

  @override
  Stream<Job> jobStream({required String? jobID}) => _service.documentStream(
        path: APIPath.job(uid, jobID),
        builder: (data, documentID) => Job.fromMap(data!, documentID),
      );

  @override
  Stream<List<Job>> jobsStream() {
    return _service.collectionStream(
        path: APIPath.jobs(uid),
        builder: (data, documentID) => Job.fromMap(data, documentID));
    // version 2
    // return snapshots.map((snapshot) => snapshot.docs
    //     .map(
    //       (snapshot) => Job(
    //           name: snapshot.data()['name'],
    //           ratePerHour: snapshot.data()['ratePerHour']),
    //     )
    //     .toList());
    //
    //
    // version 1
    // snapshots.listen((event) {
    //   event.docs.forEach((element) {
    //     print(element.data());
    //   });
    // });
  }

  @override
  Future<void> setEntry(Entry entry) async => await _service.setData(
        path: APIPath.entry(uid, entry.id),
        data: entry.toMap(),
      );

  @override
  Future<void> deleteEntry(Entry entry) async =>
      await _service.deleteData(path: APIPath.entry(uid, entry.id));

  @override
  Stream<List<Entry>> entriesStream({Job? job}) =>
      _service.collectionStream<Entry>(
        path: APIPath.entries(uid),
        queryBuilder: job != null
            ? (query) => query.where('jobId', isEqualTo: job.id)
            : null,
        builder: (data, documentID) => Entry.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );
}
