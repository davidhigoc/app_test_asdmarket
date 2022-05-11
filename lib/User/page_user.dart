import 'package:asd_market/Service/Auth/auth_service.dart';
import 'package:asd_market/Service/Firebase/firestore.dart';
import 'package:asd_market/Service/Provider/media.dart';
import 'package:asd_market/Service/Provider/user_id.dart';
import 'package:asd_market/Service/Widgets/widget.dart';
import 'package:asd_market/User/anuncios.dart';
import 'package:asd_market/User/edit_profile.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class PageUser extends StatefulWidget {
  const PageUser({Key? key}) : super(key: key);

  @override
  State<PageUser> createState() => _PageUserState();
}

class _PageUserState extends State<PageUser> {
  // VARIABLES
  bool est = true;
  List? anunciosU;
  bool config = false;

  // FUNCIONES
  Future consultas() async {
    UsID userID = Provider.of<UsID>(context, listen: false);
    fireUser
        .doc("Public")
        .collection("${userID.uPri!["Year"]}")
        .doc("${userID.uPri!["Asinu"]}")
        .collection("Anun")
        .orderBy('Fecha', descending: true)
        .get()
        .then((anun) {
      if (anun.size > 0) {
        List listatem = [];
        for (var element in anun.docs) {
          listatem.add(element.data());
        }
        setState(() {
          anunciosU = listatem;
        });
      } else {
        setState(() {
          anunciosU = [];
        });
      }
      {}
    });
  }

  @override
  void initState() {
    consultas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final media = Provider.of<Media>(context, listen: false);
    UsID userID = Provider.of<UsID>(context);

    double ancho = media.ancho;
    double altop = media.altop;

    return Scaffold(
      backgroundColor: Color(media.ama),
      body: userID.usuarioT
          ? SafeArea(
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
                        height: 150,
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
                                        child: Text(
                                          userID.uPub!["Nombre"] != null
                                              ? "${userID.uPub!["Nombre"]}"
                                              : "Editar perfil",
                                          maxLines: 2,
                                          style: const TextStyle(
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
                            // FOTO USER, REPUTACION Y VENTAS
                            SizedBox(
                              width: ancho,
                              height: 150,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 60.0,
                                      left: 10.0,
                                      bottom: 10.0,
                                    ),
                                    child: SizedBox(
                                      width: ancho - 160,
                                      // color: Colors.black,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: (ancho - 160) * 0.6,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  "Reputación",
                                                  style: TextStyle(
                                                    color: Colors.grey.shade800,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                reputacion(
                                                    ((ancho - 160) * 0.6),
                                                    userID.uPub!["Rep"]
                                                        .toDouble())
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: (ancho - 160) * 0.35,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  "Ventas",
                                                  style: TextStyle(
                                                    color: Colors.grey.shade800,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                ventasU((ancho - 160) * 0.4,
                                                    userID.uPub!["Ventas"])
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: fotoURL(
                                      130,
                                      userID.uPub!["Foto"],
                                      media.azul,
                                      true,
                                    ),
                                  ),
                                ],
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
                            // BOTON EDITAR PERFIL
                            Positioned(
                                top: 15.0,
                                right: 15.0,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const EditPerfil(),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 20.0,
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ),
                      // Anuncios y Notificaciones [CUADRO AZUL]
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: ancho,
                          decoration: BoxDecoration(
                            color: Color(media.azul),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            boxShadow: const [
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
                              // SELECTOR DE ESTADOS
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SizedBox(
                                  width: ancho - 40,
                                  height: 45,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // MIS ANUNCIOS
                                      SizedBox(
                                        width: ((ancho - 40) / 2) - 5,
                                        height: 45,
                                        child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              est = true;
                                            });
                                          },
                                          style: ButtonStyle(
                                            backgroundColor: est == true
                                                ? MaterialStateProperty.all(
                                                    Color(media.azul),
                                                  )
                                                : MaterialStateProperty.all(
                                                    Colors.white,
                                                  ),
                                          ),
                                          child: Text(
                                            "Mis anuncios",
                                            style: TextStyle(
                                              color: est
                                                  ? Colors.white
                                                  : Colors.grey.shade800,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // NOTIFICACIONES
                                      SizedBox(
                                        width: ((ancho - 40) / 2) - 5,
                                        height: 45,
                                        child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              est = false;
                                            });
                                          },
                                          style: ButtonStyle(
                                            backgroundColor: est == false
                                                ? MaterialStateProperty.all(
                                                    Color(media.azul),
                                                  )
                                                : MaterialStateProperty.all(
                                                    Colors.white,
                                                  ),
                                          ),
                                          child: Text(
                                            "Notificaciones",
                                            style: TextStyle(
                                              color: !est
                                                  ? Colors.white
                                                  : Colors.grey.shade800,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              /* // TEXTO
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            width: ancho - 40,
                            child: const Text(
                              "Más recientes:",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ), */
                              //  ANUNCIOS
                              if (est)
                                SizedBox(
                                  child: anunciosU != null
                                      ? anunciosU!.isNotEmpty
                                          ? Wrap(
                                              children: [
                                                for (var z = 0;
                                                    z <= anunciosU!.length - 1;
                                                    z++)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 10.0),
                                                    child: GestureDetector(
                                                      onTap: () {},
                                                      child: AnunciosUser(
                                                        anunciosU: anunciosU!,
                                                        z: z,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            )
                                          : SizedBox(
                                              width: ancho,
                                              height: 50,
                                              child: const Center(
                                                child: Text(
                                                  "Aún no has creado anuncios",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )
                                      : SizedBox(
                                          width: ancho,
                                          height: 50,
                                          child: const Center(
                                            child: SizedBox(
                                              width: 25,
                                              height: 25,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                              //  NOTIFICACIONES
                              //
                            ],
                          ),
                        ),
                      ),
                      // Configuracion
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                          bottom: 20.0,
                        ),
                        child: Container(
                          width: ancho,
                          decoration: BoxDecoration(
                            color: Color(media.azul),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            boxShadow: const [
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
                              SizedBox(
                                width: ancho,
                                height: 45,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      config = !config;
                                    });
                                  },
                                  icon: !config
                                      ? const Icon(
                                          Icons.expand_more,
                                          color: Colors.white,
                                        )
                                      : const Icon(
                                          Icons.expand_less,
                                          color: Colors.white,
                                        ),
                                ),
                              ),
                              // Boton cerrar sesion
                              Visibility(
                                visible: config,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SizedBox(
                                    width: (ancho - 60),
                                    height: 40,
                                    child: TextButton(
                                      onPressed: () async {
                                        context.read<ElUser>().salir(context);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          Colors.white,
                                        ),
                                      ),
                                      child: Text(
                                        "Cerrar Sesión",
                                        style: TextStyle(
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                    ),
                                  ),
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
            )
          : const SizedBox(),
    );
  }
}
