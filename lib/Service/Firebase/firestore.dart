import 'package:cloud_firestore/cloud_firestore.dart';

// REFERENCIAS CLOUD FIRESTORE
final fireUser = FirebaseFirestore.instance.collection('Users');
final fireStore = FirebaseFirestore.instance.collection('Store');
final firePeti = FirebaseFirestore.instance.collection('Peticiones');
final fireProductos = FirebaseFirestore.instance.collection('Productos');
