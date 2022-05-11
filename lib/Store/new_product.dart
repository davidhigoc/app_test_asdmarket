import 'package:asd_market/Service/Firebase/storage.dart';
import 'package:asd_market/Service/Provider/media.dart';
import 'package:asd_market/Service/Firebase/firestore.dart';
import 'package:asd_market/Service/Provider/user_id.dart';
import 'package:asd_market/User/page_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
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
  String men = "";
  bool menBAN = false;
  bool esperar = false;
  bool anuNuevo = true;

  // FUNCIONES
  Future<File?> addImages() async {
    XFile? fotoUpload;
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    fotoUpload = pickedImage != null ? XFile(pickedImage.path) : null;
    if (fotoUpload != null) {
      return await recorte(fotoUpload);
    } else {
      return null;
    }
  }

  Future<File?> recorte(XFile imagen) async {
    final media = Provider.of<Media>(context, listen: false);
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imagen.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        /* CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9 */
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Foto de pefil',
          toolbarColor: Color(media.verde),
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
          showCropGrid: true,
        ),
        IOSUiSettings(
          title: 'Foto de pefil',
        ),
      ],
    );
    if (croppedFile != null) {
      return File(croppedFile.path);
    } else {
      return null;
    }
  }

  Future crearAnuncio() async {
    UsID userID = Provider.of<UsID>(context, listen: false);
    List<File> imagesToUp = [];

    setState(() {
      esperar = true;
    });

    // ? 1. Compilamos imagenes para subir
    for (var item in images) {
      if (item != null) {
        imagesToUp.add(item);
      }
    }
    // ? --
    if (imagesToUp.isNotEmpty) {
      // ? 2. Validamos información completa en formulario
      if (tituloC.text.isNotEmpty) {
        if (descripC.text.isNotEmpty) {
          if (precioC.text.isNotEmpty) {
            // ? 3. SE DESPLIEGA NUEVO ANUNCIO.. [REPO User]
            if (anuNuevo) {
              // ? 4. SE SOLICITA CONSECUTIVO PARA EVITAR DUPLICIDDAD [AnunCre]
              Map con = await getContador();
              if (con != {}) {
                // ? 5. SE SUBEN LAS IMAGENES PARA OBTENER LAS URLs
                int conseAnun = con["AnunCre"] + 1;
                List laResp = await newAnunStorage(
                    userID.uPri!.data(), conseAnun, imagesToUp);
                if (laResp[0] == 200) {
                  // ? 6. SE CREA DOCUMENTO EN LA DIRECCIÓN DEL USUARIO
                  fireUser
                      .doc("Public")
                      .collection("${userID.uPri!["Year"]}")
                      .doc("${userID.uPri!["Asinu"]}")
                      .collection("Anun")
                      .doc("Anun$conseAnun")
                      .set({
                    "Cat": {
                      "Categ": catSelec!["Categ"],
                      "Ref": catSelec!["Ref"],
                    },
                    "Titulo": tituloC.text.trim(),
                    "Descrip": descripC.text.trim(),
                    "Precio": precioC.text.trim(),
                    "Envio": envio,
                    "RutaU": userID.uPri!.data(),
                    "Fecha": DateTime.now(),
                    "Est": "Disponible",
                    "Fotos": laResp[1],
                    "Doc": "Anun$conseAnun",
                  }).then((vali) async {
                    await Future.delayed(const Duration(milliseconds: 500));
                    // ignore: avoid_print
                    print("📃📌");
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PageUser(),
                      ),
                    );
                  }).catchError((er) {
                    errores(5);
                  });
                }
              } else {
                errores(5);
              }
            }
          } else {
            errores(4);
          }
        } else {
          errores(3);
        }
      } else {
        errores(2);
      }
    } else {
      errores(1);
    }
  }

  errores(int er) {
    switch (er) {
      case 1:
        men = "Debes incluir al menos una imagen en tú anuncio.";
        menBAN = true;
        break;

      case 2:
        men = "Debes incluir un titulo para tú anuncio";
        menBAN = true;
        break;

      case 3:
        men = "Debes incluir una descripción para tú anuncio";
        menBAN = true;
        break;

      case 4:
        men = "Debes incluir el precio.";
        menBAN = true;
        break;

      case 5:
        men =
            "Upss! no se puede crear anuncios en este momento, por favor intentalo más tarde.. ";
        menBAN = true;
        break;
    }

    setState(() {
      esperar = false;
    });
  }

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

    if (firebaseUser == null || !userID.usuarioT) {
      Navigator.of(context).pop();
    }

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
                                "Introduce un titulo llamativo de máximo de 80 caracteres.",
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
                              maxLength: 80,
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
                          // Add Imagenes **************************************
                          SizedBox(
                            width: ancho - 40,
                            child: Wrap(
                              spacing: 6.0,
                              children: [
                                for (var z = 0; z <= images.length - 1; z++)
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      // Cuadros blancos add - image
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 20.0,
                                        ),
                                        child: GestureDetector(
                                          onTap: () async {
                                            images[z] = await addImages();
                                            setState(() {});
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                            child: Container(
                                              width: ((ancho - 40) / 3) - 6,
                                              height: ((ancho - 40) / 3) - 6,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
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
                                              child: images[z] == null
                                                  ? Center(
                                                      child: Icon(
                                                        Icons.add,
                                                        color: Colors
                                                            .grey.shade800,
                                                      ),
                                                    )
                                                  : Image.file(images[z]!),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Borrar
                                      Positioned(
                                        bottom: 0,
                                        child: Visibility(
                                          visible: images[z] != null,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                images[z] = null;
                                              });
                                            },
                                            child: SizedBox(
                                              width: ((ancho - 40) / 3) - 6,
                                              child: Center(
                                                child: SizedBox(
                                                  width: 40,
                                                  height: 40,
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.grey.shade200,
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: Color(media.azul),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          // Titulo
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0),
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
                          // ERRORES
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Visibility(
                              visible: menBAN,
                              child: SizedBox(
                                width: ancho - 60,
                                child: Text(
                                  men,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Boton de Crear
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SizedBox(
                              width: ((ancho - 40) / 2) - 5,
                              height: 45,
                              child: TextButton(
                                onPressed: !esperar
                                    ? () {
                                        crearAnuncio();
                                      }
                                    : null,
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Color(media.azul),
                                  ),
                                ),
                                child: !esperar
                                    ? const Text(
                                        "Crear anuncio",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      )
                                    : const SizedBox(
                                        width: 25,
                                        height: 25,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // *
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
