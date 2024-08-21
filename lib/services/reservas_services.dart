import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

//GET LIST THE RESERVATIONS
Future<List<Map<String, dynamic>>> getReservations() async {
  List<Map<String, dynamic>> data = [];
  CollectionReference collectionReference = FirebaseFirestore.instance.collection('reservations');

  QuerySnapshot queryReservations = await collectionReference.get();
  queryReservations.docs.forEach((document) {
    Map<String, dynamic> reservation = document.data() as Map<String, dynamic>;
    reservation['uid'] = document.id; // Agrega el ID del documento al mapa de datos
    data.add(reservation);
  });
  return data;
}
//READ RESERVATION 
Future<void> readReservation(String notes, DateTime startDate, String title, int totalAmount) async {
  await FirebaseFirestore.instance.collection('reservations').add({
    'notes': notes,
    'start_date': Timestamp.fromDate(startDate), // Convierte DateTime a Timestamp
    'title': title,
    'total_amount': totalAmount,
  });
}
//UPADATE RESERVATION
Future<void> updateReservation(String uid, String title, String notes, DateTime startTime, int totalAmount) async {
  await db.collection('reservations').doc(uid).set({
    'notes': notes,
    'start_date': Timestamp.fromDate(startTime), // Convierte DateTime a Timestamp
    'title': title,
    'total_amount': totalAmount,
  });
}

//DELETE RESERVATION
Future<void> deleteReservation(String uid) async {
  await db.collection('reservations').doc(uid).delete();
}