import 'package:asd_market/Service/Provider/user_id.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ElUser {
  // CONSTRUCTOR (derivado de otra clase SUP)
  late final FirebaseAuth _firebaseAuth;
  ElUser(this._firebaseAuth);

  // VARIABLES DE CLASE
  User? userFire;

  // FUNCIÓN Stream futuro
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Variables simples
  String error = '';
  int resp = 500;

  // ! FUNCIÓN DE REGISTRO DE USUARIO
  Future<List<dynamic>> registro(
      String? correo, String? pass, BuildContext context, UsID usID) async {
    resp = 500;
    // ? Creando usuario en Auth-Firebase
    await _firebaseAuth
        .createUserWithEmailAndPassword(email: correo!, password: pass!)
        .then((value) async {
      // ?  Esperamos el disparo del evento
      // ?  Este proceso puede demorar hasta 5 segundos
      // ?  RETORNA 200 - BUCLE INFINITO

      resp = await usID.nuevoUser(value.user, context);
    }).catchError((er) {
      // print(er.code.toString());
      error = er.code.toString();
      // ERRORES DE LOGUEO
      if (error == 'email-already-in-use') {
        resp = 3;
      } else if (error == 'invalid-email') {
        resp = 4;
      } else {
        resp = 5;
      }
    });
    return [resp];
  }

  // ! FUNCIÓN DE INICIO DE SESIÓN
  Future<List<dynamic>> inicioS(
      String? correo, String? pass, BuildContext context) async {
    var userID = Provider.of<UsID>(context, listen: false);

    resp = 500;
    await _firebaseAuth
        .signInWithEmailAndPassword(email: correo!, password: pass!)
        .then((us) {
      // ? SE CONSULTAN DOCUMENTOS DE USUARIO.
      userID.inicioDataId(us.user);
      resp = 200;
    }).catchError((er) {
      // print(er.code.toString());
      error = er.code.toString();
      // ERRORES DE LOGUEO
      if (error == 'wrong-password') {
        resp = 5;
      } else if (error == 'invalid-email') {
        resp = 6;
      } else if (error == 'user-not-found') {
        resp = 7;
      } else if (error == 'user-disabled') {
        resp = 8;
      } else {
        resp = 6;
      }
    });
    return [resp];
  }

  Future<int> resetContra(String? correo) async {
    resp = 500;

    await _firebaseAuth.sendPasswordResetEmail(email: correo!).then((valor) {
      resp = 10;
    }).catchError((e1) {
      // ignore: avoid_print
      print('Hubo un error ---> ${e1.code}');
      if (e1.code == "invalid-email") {
        resp = 6;
      } else if (e1.code == 'user-not-found') {
        resp = 7;
      } else if (e1.code == 'unknown') {
        resp = 9;
      }
    });

    return resp;
  }

  // ! SALIR
  void salir(BuildContext context) async {
    final firebaseUser = Provider.of<User?>(context, listen: false);
    var userID = Provider.of<UsID>(context, listen: false);

    if (firebaseUser != null) {
      Navigator.of(context).pop();
      await _firebaseAuth.signOut().whenComplete(() {
        userID.resetUsuario();
      });
    } else {}
  }
}
