import 'dart:async';

import 'package:asd_market/RegisLogin/regis_login.dart';
import 'package:asd_market/Service/Firebase/firestore.dart';
import 'package:asd_market/Service/Provider/media.dart';
import 'package:asd_market/Service/Provider/user_id.dart';
import 'package:asd_market/Service/Widgets/widget.dart';
import 'package:asd_market/User/page_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class Product extends StatefulWidget {
  const Product({Key? key, required this.pro, required this.my})
      : super(key: key);

  final Map pro;
  final bool my;

  @override
  State<Product> createState() => _StoreState();
}

class _StoreState extends State<Product> {
  // VARIABLES
  Map? proCompleto;
  Map? vendedor;
  String categoria = "";
  int fotoSelec = 0;
  bool des = false;
  bool esperar = false;
  // SUSCRIPCIONES
  StreamSubscription? suscripcion;

  Future consulPro(Map previo) async {
    fireUser
        .doc("Public")
        .collection("${previo["RutaU"]["Year"]}")
        .doc("${previo["RutaU"]["Asinu"]}")
        .collection("Anun")
        .doc("${previo["Doc"]}")
        .get()
        .then((prod) async {
      if (prod.exists) {
        setState(() {
          proCompleto = prod.data();
          categoria = proCompleto!["Cat"]["Categ"];
        });
        // ? 2. CONSULTAMOS
        await fireUser
            .doc("Public")
            .collection("${previo["RutaU"]["Year"]}")
            .doc("${previo["RutaU"]["Asinu"]}")
            .get()
            .then((ven) {
          if (ven.exists) {
            setState(() {
              vendedor = ven.data();
            });
          }
        });
      } else {
        setState(() {
          proCompleto = {};
        });
      }
    });
  }

  Future comprar() async {
    UsID userID = Provider.of<UsID>(context, listen: false);

    if (proCompleto != null && vendedor != null) {
      DateTime date = DateTime.now();
      setState(() {
        esperar = true;
      });
      Stream<DocumentSnapshot<Map<String, dynamic>>>? peticion;
      // ? 1. LEVANTAMOS UN EVENTO COMO PETICIÓN PARA REALIZAR COMPRA.
      await firePeti
          .doc("${date.month}")
          .collection("${date.year}")
          .doc("${date.day}")
          .collection("Compra")
          .add({
        "Tr": false,
        "Est": "SP",
        "Doc": proCompleto!["Doc"],
        "RutaUVen": proCompleto!["RutaU"],
        "RutaUCom": userID.uPri!.data(),
        "FechaCom": DateTime.now(),
      }).then((devolucion) async {
        // ? 2. SE REALIZA UNA SUSCRIPCIÓN PARA ESPERAR UNA RESPUESTA DEL SERVIDOR
        peticion = devolucion.parent.doc(devolucion.id).snapshots();
        // ? 3. SALTAMOS A OTRA FUNCIÓN PARA REALIZAR EL STREAMING
        petiPremios(peticion!);
      }).catchError((er) {
        // ignore: avoid_print
        print("Error escribiendo la peticion de compra. er: $er");
      });
    } else {
      // ignore: avoid_print
      print("Sin información para realizar la compra...");
    }
  }

  petiPremios(Stream<DocumentSnapshot<Map<String, dynamic>>> peticion) {
    suscripcion = peticion.listen((event) {
      // ignore: avoid_print
      print(event.data());
      if (event["Tr"]) {
        // ignore: avoid_print
        print("💎 Function OK -> Cancelando suscripción");
        if (event["Est"] == "OK") {
          setState(() {
            esperar = false;
          });
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const PageUser(),
            ),
          );
        } else if (event["Est"] == "USP") {}
        suscripcion!.cancel();
      } else {
        // ignore: avoid_print
        print("⏳⏳⏳ Esperando petición...");
      }
    });
  }

  @override
  void initState() {
    if (widget.my) {
      proCompleto = widget.pro;
    } else {
      consulPro(widget.pro);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final media = Provider.of<Media>(context, listen: false);
    UsID userID = Provider.of<UsID>(context);

    double ancho = media.ancho;
    double altop = media.altop;

    return Scaffold(
      backgroundColor: Color(media.verde),
      body: SafeArea(
        child: Container(
          width: ancho,
          height: altop,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(media.verde),
                Colors.grey.shade200,
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // * Header
                SizedBox(
                  height: 61,
                  width: ancho,
                  child: Stack(
                    children: [
                      // BARRA HORIZONTAL
                      Positioned(
                        top: 8,
                        right: 10,
                        child: Container(
                          width: ancho - 80,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Color(media.azul),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 10.0,
                              right: 10.0,
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: ancho - 130,
                                  child: Text(
                                    categoria,
                                    textAlign: TextAlign.left,
                                    maxLines: 2,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (proCompleto == null)
                                  const SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // BOTON ATRAS
                      Positioned(
                        top: 8,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 60,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Color(media.azul),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // SI EL PRODUCTO POR ALGUNA RAZÓN NO EXISTE

                if (proCompleto == {})
                  SizedBox(
                    width: ancho,
                    height: altop - 61,
                    child: Center(
                      child: Text(
                        "Upss! Este producto no está disponible",
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                // Producto
                if (proCompleto != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 5.0,
                      left: 10.0,
                      right: 10.0,
                      bottom: 10.0,
                    ),
                    child: Container(
                      width: ancho,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(3, 3),
                            blurRadius: 5,
                          ),
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(-3, -3),
                            blurRadius: 5,
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          // * Foto seleccionada del producto
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6.0),
                              child: SizedBox(
                                width: ancho - 40,
                                height: ancho - 40,
                                child: Image.network(
                                  proCompleto!["Fotos"][fotoSelec],
                                ),
                              ),
                            ),
                          ),
                          // * Fotos totales miniatura
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (var z = 0;
                                    z <= proCompleto!["Fotos"].length - 1;
                                    z++)
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            fotoSelec = z;
                                          });
                                        },
                                        child: SizedBox(
                                          width: 70,
                                          height: 70,
                                          child: Image.network(
                                            proCompleto!["Fotos"][z],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ),
                          // * Titulo del producto
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 15.0,
                              bottom: 15.0,
                            ),
                            child: SizedBox(
                              width: ancho - 60,
                              child: Text(
                                "${proCompleto!["Titulo"]}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          // * Envío
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 5.0,
                            ),
                            child: SizedBox(
                              width: ancho - 60,
                              child: Text(
                                proCompleto!["Envio"]
                                    ? "Envío Gratis"
                                    : "Acuerdas el envío con el vendedor",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: proCompleto!["Envio"]
                                      ? Colors.green
                                      : Colors.grey.shade800,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          // * Precio
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 5.0,
                              bottom: 5.0,
                            ),
                            child: SizedBox(
                              width: ancho - 60,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "\$ ${proCompleto!["Precio"]}",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Color(media.azul),
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${proCompleto!["Est"]}",
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // * Divisor
                          const Divider(
                            thickness: 1.5,
                            height: 30,
                          ),
                          // * Boton de comprar
                          Container(
                            child: proCompleto!["RutaU"]["Asinu"] !=
                                    userID.uPri!["Asinu"]
                                ? userID.usuarioT
                                    ? SizedBox(
                                        width: ancho - 50,
                                        height: 45,
                                        child: ElevatedButton(
                                          onPressed: !esperar
                                              ? () {
                                                  comprar();
                                                }
                                              : null,
                                          /* onLongPress: () {
                                  print("${userID.uPri!.data()}");
                                }, */
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                            ),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              Color(media.azul),
                                            ),
                                          ),
                                          child: !esperar
                                              ? const Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Text(
                                                    "Comprar",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(
                                                  width: 25,
                                                  height: 25,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                        ),
                                      )
                                    : SizedBox(
                                        width: ancho - 50,
                                        height: 45,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const Login(),
                                              ),
                                            )
                                                .then((value) {
                                              setState(() {});
                                            });
                                          },
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                            ),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              Color(media.azul),
                                            ),
                                          ),
                                          child: !esperar
                                              ? const Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Text(
                                                    "Iniciar Sesión",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(
                                                  width: 25,
                                                  height: 25,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                        ),
                                      )
                                : const SizedBox(),
                          ),
                          // * Boton de Descripción
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 15.0, bottom: 15.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  des = !des;
                                });
                              },
                              child: Container(
                                width: ancho - 20,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Color(media.verde),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(2, 2),
                                      blurRadius: 1,
                                    ),
                                    BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(-2, -2),
                                      blurRadius: 1,
                                    )
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 30.0,
                                    right: 30.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Descripción",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(
                                        child: !des
                                            ? const Icon(
                                                Icons.expand_more,
                                                color: Colors.white,
                                              )
                                            : const Icon(
                                                Icons.expand_less,
                                                color: Colors.white,
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // * Descripción
                          Visibility(
                            visible: des,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: SizedBox(
                                width: ancho - 40,
                                child: Text(
                                  "${proCompleto!["Descrip"]}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                if (vendedor != null)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: ancho,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(3, 3),
                            blurRadius: 5,
                          ),
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(-3, -3),
                            blurRadius: 5,
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          // Vista titutlo de Vendedor
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 15.0, bottom: 5.0),
                            child: Container(
                              width: ancho - 20,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color(media.verde),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(2, 2),
                                    blurRadius: 1,
                                  ),
                                  BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(-2, -2),
                                    blurRadius: 1,
                                  )
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 30.0,
                                  right: 30.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      "Vendedor",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Info Vendedor
                          SizedBox(
                            width: ancho - 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: (ancho - 20) * 0.58,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: (ancho - 20) * 0.58,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    "Ventas",
                                                    textAlign: TextAlign.center,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade800,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  ventasU(
                                                      50, vendedor!["Ventas"])
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 15.0,
                                                bottom: 5.0,
                                              ),
                                              child: SizedBox(
                                                width: ancho,
                                                child: Text(
                                                  "Reputación: (${vendedor!["Rep"]})",
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    color: Colors.grey.shade800,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            reputacion(150, vendedor!["Rep"])
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: (ancho - 20) * 0.38,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          width: (ancho - 20) * 0.38,
                                          child: Text(
                                            vendedor!["Nombre"] != null
                                                ? "${vendedor!["Nombre"]}"
                                                : "Sin nombre",
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            style: TextStyle(
                                              color: Colors.grey.shade800,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 15.0),
                                        child: fotoURL(
                                            ((ancho - 20) * 0.38) - 20,
                                            vendedor!["Foto"],
                                            media.azul,
                                            false),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
