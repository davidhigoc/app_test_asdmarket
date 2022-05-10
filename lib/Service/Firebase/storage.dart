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

Future<List> newAnunStorage(
    Map<String, dynamic>? user, int cons, List<File> imaList) async {
  int resp = 200;
  List<String?> urlS =
      List<String?>.filled(imaList.length, null, growable: true);

  for (var z = 0; z <= imaList.length - 1; z++) {
    await refAsinu
        .child("${user!["Asinu"]}")
        .child("Anun")
        .child("Anun$cons")
        .child("FotoA$z.jpg")
        .putFile(imaList[z])
        .then((p0) async {
      if (p0.state == TaskState.success) {
        await refAsinu
            .child("${user["Asinu"]}")
            .child("Anun")
            .child("Anun$cons")
            .child("FotoA$z.jpg")
            .getDownloadURL()
            .then((url) {
          urlS[z] = url;
        });
      }
    });
  }

  for (var item in urlS) {
    if (item == null) {
      resp = 500;
    }
  }
  if (resp == 200) {
    // ignore: avoid_print
    print("📸📤");
  }

  return [resp, urlS];
}
