import 'package:asd_market/Service/Firebase/firestore.dart';
import 'package:asd_market/Service/Firebase/storage.dart';
import 'package:asd_market/Service/Provider/media.dart';
import 'package:asd_market/Service/Provider/user_id.dart';
import 'package:asd_market/Service/Widgets/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class EditPerfil extends StatefulWidget {
  const EditPerfil({Key? key}) : super(key: key);

  @override
  State<EditPerfil> createState() => _PageUserState();
}

class _PageUserState extends State<EditPerfil> {
  // VARIABLES
  TextEditingController nombreC = TextEditingController()..text = "";
  TextEditingController telC = TextEditingController()..text = "";
  File? fotoUR;
  bool esperar = false;
  String men = "";
  bool menBAN = false;

  // FUNCIONES
  Future obtenerImagen() async {
    XFile? fotoUpload;
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    fotoUpload = pickedImage != null ? XFile(pickedImage.path) : null;
    if (fotoUpload != null) {
      recorte(fotoUpload);
    }
  }

  Future recorte(XFile imagen) async {
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
      setState(() {
        fotoUR = File(croppedFile.path);
      });
    }
  }

  Future guardarAcc() async {
    UsID userID = Provider.of<UsID>(context, listen: false);
    List laResp = [500, ""];

    setState(() {
      esperar = true;
      menBAN = false;
    });

    // ? 1. PRIMERO SUBIMOS FOTO DE USUARIO PARA ADQUIRIR SU URL
    // ? ESTO DE MANERA ORDENADA EN FIRE-STORAGE...
    // * Evaluamos si usuario cambio su foto de perfil
    if (fotoUR != null) {
      laResp = await fotoUploadFile(fotoUR!, userID.uPri!.data());
      if (laResp[0] == 200) {
        fotoUR = null;
        // ignore: avoid_print
        print("📷📤");
      }
    }
    // ? 2. ACTUALIZAMOS DOCUMENTO PUBLICO DEL USUARIO
    // ? SEGÚN LOS CAMBIOS QUE SE HAYAN DEFINIDO.
    fireUser
        .doc("Public")
        .collection("${userID.uPri!["Year"]}")
        .doc("${userID.uPri!["Asinu"]}")
        .update({
      "Foto": laResp[0] == 200 ? laResp[1] : userID.uPub!["Foto"],
      "Nombre":
          nombreC.text.isEmpty ? userID.uPub!["Nombre"] : nombreC.text.trim(),
      "Tel": telC.text.isEmpty ? userID.uPub!["Tel"] : telC.text.trim(),
    });

    setState(() {
      esperar = false;
    });
  }

  @override
  void initState() {
    UsID userID = Provider.of<UsID>(context, listen: false);
    if (userID.uPub!["Nombre"] != null) {
      nombreC.text = userID.uPub!["Nombre"];
    }
    if (userID.uPub!["Tel"] != null) {
      telC.text = userID.uPub!["Tel"];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final media = Provider.of<Media>(context, listen: false);
    UsID userID = Provider.of<UsID>(context);
    User? firebaseUser = Provider.of<User?>(context);

    double ancho = media.ancho;
    double altop = media.altop;

    if (firebaseUser == null || !userID.usuarioT) {}

    return Scaffold(
      backgroundColor: Color(media.ama),
      body: SafeArea(
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
                // Header
                SizedBox(
                  height: 61,
                  width: ancho,
                  child: Stack(
                    children: [
                      // BARRA HORIZONTAL
                      Positioned(
                        top: 8,
                        right: 0,
                        child: Container(
                          width: ancho - 70,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Color(media.azul),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 10.0,
                              right: 150.0,
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: ancho - (70 + 160),
                                  child: const Text(
                                    "Editar perfil",
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                // Foto user
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    child: Stack(
                      children: [
                        fotoUR == null
                            ? fotoURL(
                                ancho / 1.8,
                                userID.uPub!["Foto"],
                                media.azul,
                              )
                            : fotoFile(
                                ancho / 1.8,
                                fotoUR!,
                                media.azul,
                              ),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: () => obtenerImagen(),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.add_photo_alternate,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Correo
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                  child: SizedBox(
                    width: ancho - 50,
                    child: Text(
                      "${userID.uPub!["Correo"]}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                // Edición del nombre
                SizedBox(
                  width: ancho - 100,
                  child: TextField(
                    controller: nombreC,
                    autocorrect: true,
                    cursorWidth: 2,
                    keyboardType: TextInputType.text,
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
                      hintText: "* Nombre",
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
                // Edición telefono
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    bottom: 20.0,
                  ),
                  child: SizedBox(
                    width: ancho - 100,
                    child: TextField(
                      controller: telC,
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
                        hintText: "* Telefono (+57)",
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
                ),
                // Mensaje para errores
                SizedBox(
                  width: ancho - 100,
                  child: Text(
                    men,
                  ),
                ),
                // Boton de Guardar
                ElevatedButton(
                  onPressed: () => guardarAcc(),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Color(media.azul),
                    ),
                  ),
                  child: !esperar
                      ? const Text("Guardar")
                      : const SizedBox(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                ),
                // Info
                Padding(
                  padding: const EdgeInsets.only(
                    top: 30.0,
                    bottom: 20.0,
                  ),
                  child: SizedBox(
                    width: ancho - 100,
                    child: const Text(
                      "Solo aquellas personas que compren uno de tus productos podrán ver tú información de contacto.",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container fotoFile(double diametro, File image, dynamic color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            blurRadius: diametro / 3,
            color: Colors.black,
            spreadRadius: 1,
          )
        ],
      ),
      child: CircleAvatar(
        backgroundColor: Color(color),
        radius: (diametro / 2),
        child: CircleAvatar(
          radius: (diametro / 2) - 4,
          backgroundColor: Colors.white,
          backgroundImage: FileImage(image),
        ),
      ),
    );
  }
}
