import 'package:asd_market/RegisLogin/regis_login.dart';
import 'package:asd_market/Service/Auth/auth_service.dart';
import 'package:asd_market/Service/Provider/media.dart';
import 'package:asd_market/Service/Provider/user_id.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  // * FUNCIONES
  iniciales(UsID userID) {
    userID.permanencia(context);
  }

  @override
  void initState() {
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
            firebaseUser == null
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
                : SizedBox(
                    width: ancho,
                    height: 120,
                    child: Center(
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
                    ),
                  ),
            if (userID.uPri != null)
              Container(
                width: ancho,
                height: 200,
                color: Colors.white,
              ),
            // * PRODUCTOS - CATEGORIAS
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Container(
                width: ancho * 0.95,
                height: altop,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
