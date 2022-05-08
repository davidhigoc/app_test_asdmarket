import 'package:asd_market/RegisLogin/regis_login.dart';
import 'package:asd_market/Service/Firebase/firestore.dart';
import 'package:asd_market/Service/Provider/media.dart';
import 'package:asd_market/Service/Provider/user_id.dart';
import 'package:asd_market/Service/Widgets/widget.dart';
import 'package:asd_market/User/page_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // * VARIABLES GLOBALES
  User? firebaseUser;
  DocumentSnapshot? conIni;
  List<Map> categorias = [];

  // * FUNCIONES
  iniciales(UsID userID) {
    userID.permanencia(context);
  }

  Future contenidoP() async {
    await Future.delayed(const Duration(milliseconds: 800));
    conIni = await fireStore.doc("Info").get();
    // print(conIni);
    fireProductos.get().then((prod) {
      if (prod.size > 0) {
        categorias = [];
        for (var item in prod.docs) {
          // print(item.data());
          categorias.add(item.data());
        }
        setState(() {
          categorias;
        });
      }
    });
  }

  @override
  void initState() {
    contenidoP();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final media = Provider.of<Media>(context, listen: false);
    UsID userID = Provider.of<UsID>(context);
    firebaseUser = Provider.of<User?>(context);
    iniciales(userID);

    double ancho = media.ancho;
    double altop = media.altop;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // * BOTON INICIAR SESIÓN
            firebaseUser == null || !userID.usuarioT
                ? SizedBox(
                    width: ancho,
                    height: 60,
                    child: Center(
                      child: SizedBox(
                        width: ancho * 0.85,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const Login(),
                              ),
                            );
                          },
                          onLongPress: () => contenidoP(),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                              Color(media.azul),
                            ),
                          ),
                          child: const Text(
                            "Iniciar Sesión",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: Container(
                          width: ancho,
                          height: 50,
                          color: Color(media.azul),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 175.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: ancho - (175 + 60),
                                  child: Text(
                                    userID.uPub!["Nombre"] != null
                                        ? "${userID.uPub!["Nombre"]}"
                                        : "Bienvenido/a",
                                    maxLines: 2,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const PageUser(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors
                                            .white, //                   <--- border color
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.account_circle,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Foto de usuario
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, bottom: 10.0, left: 25, right: 10.0),
                            child:
                                fotoURL(130, userID.uPub!["Foto"], media.azul),
                          ),
                          // Boton de vender
                          SizedBox(
                            width: ancho - 175,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  backgroundColor: MaterialStateProperty.all(
                                    Color(media.azul),
                                  ),
                                ),
                                child: const Text(
                                  "Vender",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
            // * PRODUCTOS - CATEGORIAS
            Padding(
              padding: const EdgeInsets.only(top: 25.0, bottom: 15.0),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      top: 40.0,
                      bottom: 10.0,
                    ),
                    width: ancho - 20,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      /* gradient: RadialGradient(
                      radius: 4.0,
                      colors: [
                        Color(media.azul),
                        Color(media.morado),
                      ],
                    ), */
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
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
                    child: Center(
                      child: categorias.isNotEmpty
                          ? Wrap(
                              spacing: 10.0,
                              children: [
                                for (var cat in categorias)
                                  if (cat["Hab"])
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 15.0),
                                      child: Container(
                                        width: ((ancho - 20) / 2) - 20,
                                        height: (((ancho - 20) / 2) - 20) + 50,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          boxShadow: [
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
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: SizedBox(
                                                width: ancho,
                                                child:
                                                    Image.network(cat["Image"]),
                                              ),
                                            ),
                                            SizedBox(
                                              width: ancho,
                                              height: 50,
                                              child: Center(
                                                child: Text(
                                                  cat["Categ"],
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
                              ],
                            )
                          : SizedBox(
                              width: ancho,
                              height: altop,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 50.0),
                                    child: SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: CircularProgressIndicator(
                                          color: Color(media.verde)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                    ),
                  ),
                  Positioned(
                    top: -25,
                    child: SizedBox(
                      width: ancho,
                      height: 50,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(13.0),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            boxShadow: [
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
                          child: Text(
                            conIni != null ? "${conIni!["msn"]}" : "",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



/* child: Center(
  child: SizedBox(
    width: ancho * 0.85,
    height: 40,
    child: ElevatedButton(
      onPressed: () {
        context.read<ElUser>().salir(context);
      },
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(
          Color(media.azul),
        ),
      ),
      child: const Text(
        "Cerrar Sesión",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  ),
), */