import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data);
  }

  Future<void> deleteData({required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('delete $path');
    await reference.delete();
  }

  // before entries
  // Stream<List<T>> collectionStream1<T>(
  //     {required String path,
  //     required T builder(Map<String, dynamic> data, String documentID)}) {
  //   final reference = FirebaseFirestore.instance.collection(path);
  //   final snapshots = reference.snapshots();
  //   return snapshots.map((snapshot) => snapshot.docs
  //       .map(
  //         (snapshot) => builder(
  //           snapshot.data(),
  //           snapshot.id,
  //         ),
  //       )
  //       .toList());
  // }

  //after entries
  Stream<List<T>> collectionStream<T>(
      {required String path,
      required T builder(Map<String, dynamic> data, String documentID),
      Query<Map<String, dynamic>> queryBuilder(
          Query<Map<String, dynamic>> query)?,
      int sort(T lhs, T rhs)?}) {
    Query<Map<String, dynamic>>? query =
        FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final Stream<QuerySnapshot<Map<String, dynamic>>> snapshots =
        query.snapshots();

    return snapshots.map(
      (snapshot) {
        final result = snapshot.docs
            .map((snapshot) {
              final snapid = snapshot.id;
              final snapdata = snapshot.data();
              return builder(
                snapdata,
                snapid,
              );
            })
            .where((value) => value != null)
            .toList();
        if (sort != null) {
          result.sort(sort);
        }
        return result;
      },
    );
  }

  Stream<T> documentStream<T>({
    required String path,
    required T builder(Map<String, dynamic>? data, String documentID),
  }) {
    final DocumentReference<Map<String, dynamic>> reference =
        FirebaseFirestore.instance.doc(path);
    final Stream<DocumentSnapshot<Map<String, dynamic>>> snapshots =
        reference.snapshots();
    return snapshots.map((snapshot) => builder(
          snapshot.data(),
          snapshot.id,
        ));
  }
}
