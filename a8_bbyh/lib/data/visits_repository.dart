import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:a8_bbyh/models/visit.dart';

class VisitsRepository implements IVisitsRepository {
  final CollectionReference visitsCollection =
      FirebaseFirestore.instance.collection('visits');

  static VisitsRepository? _instance;

  static VisitsRepository getInstance() {
    return _instance ??= VisitsRepository();
  }

  @override
  Future<List<Visit>> readVisits() async {
    QuerySnapshot querySnapshot = await visitsCollection.get();
    return querySnapshot.docs.map((doc) => Visit.fromFirestore(doc)).toList();
  }

  @override
  Future<void> createVisit(Visit visit) async {
    await visitsCollection.add(visit.toFirestore());
  }

  @override
  Future<void> updateVisit(Visit visit) async {
    DocumentReference documentReference = visitsCollection.doc(visit.id);
    await documentReference.update(visit.toFirestore());
  }

  @override
  Future<void> deleteVisit(Visit visit) async {
    DocumentReference documentReference = visitsCollection.doc(visit.id);
    await documentReference.delete();
  }
}

abstract class IVisitsRepository {
  createVisit(Visit visit);
  readVisits();
  updateVisit(Visit visit);
  deleteVisit(Visit visit);
}
