import 'dart:async';
import 'package:asd_market/Service/Firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class UsID with ChangeNotifier {
  // ! VARIABLES PRINCIPALES [RUTA - User]
  User? _userAuth;
  int est = 0;
  Map? rutaUser;
  // ! Documentos usuario
  DocumentSnapshot<Map<String, dynamic>>? uPri;
  DocumentSnapshot<Map<String, dynamic>>? uPub;
  // ! Suscripción de usuario [Documento Publico]
  StreamSubscription? streamUPub;

  get usuarioT {
    if (uPri != null && uPub != null) {
      return true;
    } else {
      return false;
    }
  }

  permanencia(BuildContext context) {
    // ? ESTA FUNCIÓN ES MUY IMPORTANTE POR QUE PERMITE QUE ESTA CLASE NO MUERA
    // ? PROVIDER LO MANTIENE VIVO GRACIAS A SUS NOTIFYS
    _userAuth = Provider.of<User?>(context);
    if (_userAuth != null && est == 0) {
      inicioDataId(_userAuth);
    } else {
      if (_userAuth == null) {
        // ignore: avoid_print
        print("❌");
      }
    }
  }

  inicioDataId(User? us) async {
    _userAuth = us;
    // ? 1. SE CONSULTA DOCUMENTO PRIVADO
    await fireUser
        .doc("Private")
        .collection("IDs")
        .doc(us!.uid)
        .get()
        .then((value) async {
      uPri = value;
      est = 1;
      // print(uPri!.data());
      final Stream<DocumentSnapshot<Map<String, dynamic>>> intanciaPub =
          FirebaseFirestore.instance
              .collection("Users")
              .doc("Public")
              .collection("${uPri!["Year"]}")
              .doc(uPri!["Asinu"])
              .snapshots();
      // ? 2. SI SE ENCUENTRA EL DOCUMENTO, SE STREAMEA EL DOCUMENTO PUBLICO
      streamPub(intanciaPub);
    });
  }

  // Funciones
  Future<int> nuevoUser(User? newUser, BuildContext context) async {
    _userAuth = Provider.of<User?>(context, listen: false);
    await Future.delayed(const Duration(seconds: 4, milliseconds: 500));
    DateTime tiempo = DateTime.now();
    while (uPri == null) {
      // ignore: avoid_print
      print("Esperando...");
      // ? 1. SE CONSULTA DOCUMENTO PRIVADO
      await fireUser
          .doc("Private")
          .collection("IDs")
          .doc(newUser!.uid)
          .get()
          .then((value) async {
        if (value.exists) {
          uPri = value;
          // print(uPri!.data());
          final Stream<DocumentSnapshot<Map<String, dynamic>>> intanciaPub =
              FirebaseFirestore.instance
                  .collection("Users")
                  .doc("Public")
                  .collection("${tiempo.year}")
                  .doc(uPri!["Asinu"])
                  .snapshots();
          await Future.delayed(const Duration(milliseconds: 500));
          // ? 2. SI SE ENCUENTRA EL DOCUMENTO, SE STREAMEA EL DOCUMENTO PUBLICO
          streamPub(intanciaPub);
        } else {
          // ignore: avoid_print
          print("No se encontro uPri");
        }
      });
      await Future.delayed(const Duration(seconds: 2));
    }
    return 200;
  }

  Future streamPub(
      Stream<DocumentSnapshot<Map<String, dynamic>>> intanciaPub) async {
    int con = 0;
    est = 2;
    // ignore: avoid_print
    print(" *** 🚀");
    streamUPub = intanciaPub.listen((event) {
      uPub = event;
      // print(uPub!.data());
      con++;
      // ignore: avoid_print
      print(" *** 📡$con");
      notifyListeners();
    });
  }

  resetUsuario() {
    if (usuarioT) {
      streamUPub!.cancel();
      uPri = null;
      uPub = null;
      _userAuth = null;
      est = 0;
      // ignore: avoid_print
      print(" *** Reset Usuario...");
      notifyListeners();
    }
  }
}
