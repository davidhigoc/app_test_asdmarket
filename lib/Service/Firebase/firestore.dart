import 'package:cloud_firestore/cloud_firestore.dart';

// REFERENCIAS CLOUD FIRESTORE
final fireUser = FirebaseFirestore.instance.collection('Users');
final fireStore = FirebaseFirestore.instance.collection('Store');
final firePeti = FirebaseFirestore.instance.collection('Peticiones');
final fireProductos = FirebaseFirestore.instance.collection('Productos');

// Get - Contador de App
Future<Map> getContador() async {
  Map<String, dynamic> elCon = {};
  await fireStore.doc("Contador").get().then((con) {
    elCon = con.data() as Map<String, dynamic>;
    // ignore: avoid_print
    print("🔢🏁");
  });
  return elCon;
}
