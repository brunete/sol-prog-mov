import 'package:cloud_firestore/cloud_firestore.dart';

class Visit {
  String? id;
  VisitStatus status;
  DateTime date;
  String description;

  Visit.withoutId(
      {required this.status, required this.date, required this.description});
  Visit.withId(
      {required this.id,
      required this.status,
      required this.date,
      required this.description});

  Map<String, dynamic> toFirestore() {
    return {
      'status': status.toString().split('.').last,
      'date': Timestamp.fromDate(date),
      'description': description,
    };
  }

  factory Visit.fromFirestore(DocumentSnapshot doc) {
    var docId = doc.id;
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Visit.withId(
      id: docId,
      status: VisitStatus.values.firstWhere(
        (e) => e.toString() == 'VisitStatus.${data['status']}',
      ),
      date: (data['date'] as Timestamp).toDate(),
      description: data['description'],
    );
  }
}

enum VisitStatus {
  approved,
  pending,
  rejected,
}
