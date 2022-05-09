import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'dart:io';

// REFERENCIAS FIREBASE STORAGE
final refAsinu = FirebaseStorage.instance.ref().child("Users").child("uPub");

Future<List> fotoUploadFile(File fotoP, Map<String, dynamic>? user) async {
  int resp = 500;
  String urlFoto = "";
  // ? 1. Se sube la imagen... Esperamos respuesta...
  await refAsinu
      .child("${user!["Asinu"]}")
      .child("FotoP.jpg")
      .putFile(fotoP)
      .then((p0) async {
    // Cuando la Imagen se carga correctamente.
    if (p0.state == TaskState.success) {
      await refAsinu
          .child("${user["Asinu"]}")
          .child("FotoP.jpg")
          .getDownloadURL()
          .then((value) {
        urlFoto = value;
        resp = 200;
      });
    } else if (p0.state == TaskState.canceled || p0.state == TaskState.error) {
      resp = 1;
    } else {
      resp = 2;
    }
  });
  return [resp, urlFoto];
  // StorageUploadTask tarea = await refAsinu.child("${user["Asinu"]}").putFile(fotoP);
}
