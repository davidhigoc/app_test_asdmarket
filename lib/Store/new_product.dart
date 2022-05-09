import 'package:asd_market/Service/Provider/media.dart';
import 'package:asd_market/Service/Provider/user_id.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class NewProduct extends StatefulWidget {
  const NewProduct({Key? key}) : super(key: key);

  @override
  State<NewProduct> createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  // VARIABLES
  Map? catSelec;
  TextEditingController tituloC = TextEditingController()..text = "";
  TextEditingController descripC = TextEditingController()..text = "";
  TextEditingController precioC = TextEditingController()..text = "";
  List<File?> images = [null, null, null];
  bool envio = true;

  Future listaCateg() async {}

  @override
  void initState() {
    super.initState();
  }

  rutasEst() {
    if (catSelec != null) {
      setState(() {
        catSelec = null;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = Provider.of<Media>(context, listen: false);
    UsID userID = Provider.of<UsID>(context);
    User? firebaseUser = Provider.of<User?>(context);

    double ancho = media.ancho;
    double altop = media.altop;

    return WillPopScope(
      onWillPop: () async {
        rutasEst();
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(media.ama),
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              width: ancho,
              height: altop,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(media.ama),
                    Color(media.verde),
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
                              child: Center(
                                child: SizedBox(
                                  width: ancho - 100,
                                  child: Text(
                                    catSelec == null
                                        ? "Nuevo anuncio"
                                        : "${catSelec!["Categ"]}",
                                    textAlign: TextAlign.left,
                                    maxLines: 2,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // BOTON ATRAS
                          Positioned(
                            top: 8,
                            child: GestureDetector(
                              onTap: () => rutasEst(),
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
                    // * SIN CATEGORIA
                    Visibility(
                      visible: catSelec == null,
                      child: Column(
                        children: [
                          // * Titulo [Selecciona categoria]
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 15.0, bottom: 10.0),
                            child: SizedBox(
                              width: ancho - 100,
                              child: Text(
                                "Selecciona la categoría",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(media.azul),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          // * Opciones
                          SizedBox(
                            width: ancho - 60,
                            child: Wrap(
                              spacing: 6,
                              children: [
                                for (var cat in media.categorias)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          catSelec = cat;
                                        });
                                      },
                                      child: Container(
                                        width: ((ancho - 60) / 2) - 3,
                                        height: 45,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
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
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: ((ancho - 60) / 2) - 3,
                                              child: Text(
                                                "${cat["Categ"]}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.grey.shade800,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    // * Titulo y descrición
                    Visibility(
                      visible: catSelec != null,
                      child: Column(
                        children: [
                          // Titulo [Titulo del producto]
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: SizedBox(
                              width: ancho - 40,
                              child: Text(
                                "Titulo del producto",
                                style: tituloAzul(media),
                              ),
                            ),
                          ),
                          // Descripción
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 4.0,
                              bottom: 4.0,
                            ),
                            child: SizedBox(
                              width: ancho - 40,
                              child: Text(
                                "Introduce un titulo llamativo de máximo de 60 caracteres.",
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          // TextField - Titulo
                          SizedBox(
                            width: ancho - 40,
                            height: 100,
                            child: TextField(
                              controller: tituloC,
                              autocorrect: true,
                              cursorWidth: 2,
                              keyboardType: TextInputType.multiline,
                              textCapitalization: TextCapitalization.sentences,
                              textAlign: TextAlign.left,
                              maxLength: 60,
                              maxLines: 2,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.orange,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 15.0),
                                labelStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[700],
                                ),
                                hintText:
                                    "* Espectacular lavadora marca Samsung modelo 2020 - excelente estado",
                                hintStyle: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 15,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade700,
                                    style: BorderStyle.solid,
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Titulo [Insertar imagenes]
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: SizedBox(
                              width: ancho - 40,
                              child: Text(
                                "Inserta las Imagenes",
                                style: tituloAzul(media),
                              ),
                            ),
                          ),
                          // Descripción
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 4.0,
                              bottom: 4.0,
                            ),
                            child: SizedBox(
                              width: ancho - 40,
                              child: Text(
                                "Incluye hasta 3 imágenes de buena calidad.",
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          // Add Imagenes
                          SizedBox(
                            width: ancho - 40,
                            child: Wrap(
                              spacing: 6.0,
                              children: [
                                for (var item in images)
                                  Container(
                                    width: ((ancho - 40) / 3) - 6,
                                    height: ((ancho - 40) / 3) - 6,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          offset: Offset(1, 1),
                                          blurRadius: 2,
                                        ),
                                        BoxShadow(
                                          color: Colors.black12,
                                          offset: Offset(-1, -1),
                                          blurRadius: 2,
                                        )
                                      ],
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          // Titulo [Insertar imagenes]
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: SizedBox(
                              width: ancho - 40,
                              child: Text(
                                "Descripción Detallada",
                                style: tituloAzul(media),
                              ),
                            ),
                          ),
                          // Descripción del producto
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 4.0,
                              bottom: 4.0,
                            ),
                            child: SizedBox(
                              width: ancho - 40,
                              child: Text(
                                "Introduce una descripción que venda mucho!",
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          // TextField - Descripción del producto
                          SizedBox(
                            width: ancho - 40,
                            height: 170,
                            child: TextField(
                              controller: descripC,
                              autocorrect: true,
                              cursorWidth: 2,
                              keyboardType: TextInputType.multiline,
                              textCapitalization: TextCapitalization.sentences,
                              textAlign: TextAlign.left,
                              maxLines: 15,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.orange,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 15.0),
                                labelStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[700],
                                ),
                                hintText:
                                    "* Excelente oportunidad, lavadora usada marca Samsung - tiene poco uso y deja la ropa como nueva, no ha presentado ninguna falla y aún cuenta con garantia, deja la ropa muy bien.",
                                hintStyle: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 15,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade700,
                                    style: BorderStyle.solid,
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Titulo [Precio]
                          Padding(
                            padding: const EdgeInsets.only(top: 25.0),
                            child: SizedBox(
                              width: ancho - 40,
                              child: Text(
                                "Precio",
                                style: tituloAzul(media),
                              ),
                            ),
                          ),
                          // Descripción precio
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 4.0,
                              bottom: 4.0,
                            ),
                            child: SizedBox(
                              width: ancho - 40,
                              child: Text(
                                "Establece un precio competitivo y acorde al producto .",
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          // TextField - Precio
                          SizedBox(
                            width: ancho - 40,
                            child: TextField(
                              controller: precioC,
                              autocorrect: true,
                              cursorWidth: 2,
                              keyboardType: TextInputType.phone,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.orange,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 15.0),
                                labelStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[700],
                                ),
                                hintText: "* \$ 250.000",
                                hintStyle: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 15,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade700,
                                    style: BorderStyle.solid,
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Titulo [Titulo del producto]
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: SizedBox(
                              width: ancho - 40,
                              child: Text(
                                "Envío",
                                style: tituloAzul(media),
                              ),
                            ),
                          ),
                          // Descripción
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 4.0,
                              bottom: 4.0,
                            ),
                            child: SizedBox(
                              width: ancho - 40,
                              child: Text(
                                "¿El precio incluye el costo de envío al cliente?",
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          // Envío selector
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: SizedBox(
                              width: ancho - 40,
                              height: 45,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Si
                                  SizedBox(
                                    width: ((ancho - 40) / 2) - 5,
                                    height: 45,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          envio = true;
                                        });
                                      },
                                      style: OutlinedButton.styleFrom(
                                        primary: Colors.white,
                                        backgroundColor: Colors.white,
                                        side: BorderSide(
                                            color: envio
                                                ? Color(media.azul)
                                                : Colors.white,
                                            width: 4),
                                      ),
                                      child: Text(
                                        "Si, incluye envío",
                                        style: TextStyle(
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // No
                                  SizedBox(
                                    width: ((ancho - 40) / 2) - 5,
                                    height: 45,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          envio = false;
                                        });
                                      },
                                      style: OutlinedButton.styleFrom(
                                        primary: Colors.white,
                                        backgroundColor: Colors.white,
                                        side: BorderSide(
                                            color: !envio
                                                ? Color(media.azul)
                                                : Colors.white,
                                            width: 4),
                                      ),
                                      child: Text(
                                        "No lo incluye",
                                        style: TextStyle(
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Boton de Crear
                          Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: SizedBox(
                              width: ((ancho - 40) / 2) - 5,
                              height: 45,
                              child: TextButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Color(media.azul),
                                  ),
                                ),
                                child: const Text(
                                  "Crear anuncio",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle tituloAzul(Media media) {
    return TextStyle(
      color: Color(media.azul),
      fontWeight: FontWeight.w800,
      fontSize: 18,
    );
  }
}
