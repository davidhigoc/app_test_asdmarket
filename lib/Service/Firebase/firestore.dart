import 'package:asd_market/Service/Provider/user_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

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

// Eliminar anuncios
Future eliminarAnuncios(BuildContext context, String doc) async {
  UsID userID = Provider.of<UsID>(context, listen: false);
  fireUser
      .doc("Public")
      .collection("${userID.uPri!["Year"]}")
      .doc("${userID.uPri!["Asinu"]}")
      .collection("Anun")
      .doc(doc)
      .delete();
}
