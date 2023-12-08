import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:a8_bbyh/models/visit.dart';

class VisitsRepository {
  final CollectionReference visitsCollection =
      FirebaseFirestore.instance.collection('visits');

  static VisitsRepository? _instance;

  static VisitsRepository getInstance() {
    return _instance ??= VisitsRepository();
  }

  Future<List<Visit>> getVisits() async {
    QuerySnapshot querySnapshot = await visitsCollection.get();
    return querySnapshot.docs.map((doc) => Visit.fromFirestore(doc)).toList();
  }

  Future<void> newVisit(Visit visit) async {
    await visitsCollection.add(visit.toFirestore());
  }

  Future<void> editVisit(Visit visit) async {
    DocumentReference documentReference = visitsCollection.doc(visit.id);
    await documentReference.update(visit.toFirestore());
  }

  Future<void> deleteVisit(Visit visit) async {
    DocumentReference documentReference = visitsCollection.doc(visit.id);
    await documentReference.delete();
  }
}
