class Job {
  Job({required this.name, required this.ratePerHour, required this.id});
  final String? id;
  final String? name;
  final int? ratePerHour;

  factory Job.fromMap(Map<String, dynamic> data, String documentID) {
    final String name = data['name'];
    final int ratePerHour = data['ratePerHour'];
    return Job(name: name, ratePerHour: ratePerHour, id: documentID);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ratePerHour': ratePerHour,
    };
  }
}
