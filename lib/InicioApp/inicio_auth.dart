import 'package:asd_market/InicioApp/carga.dart';
import 'package:asd_market/InicioApp/home.dart';
import 'package:asd_market/Service/Provider/media.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class IncioAuth extends StatefulWidget {
  const IncioAuth({Key? key}) : super(key: key);

  @override
  State<IncioAuth> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<IncioAuth> {
  // * VARIABLES
  bool cargaBAN = true;

  // * FUNCIONES
  carga() async {
    await Future.delayed(const Duration(seconds: 7));
    setState(() {
      cargaBAN = false;
    });
    await Future.delayed(const Duration(seconds: 3));
  }

  @override
  void initState() {
    carga();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final media = Provider.of<Media>(context, listen: false);
    // Construimos iniciales de contexto
    media.iniciales(
        anchoX: (MediaQuery.of(context).size.width),
        altoX: (MediaQuery.of(context).size.height),
        altopX: (MediaQuery.of(context).size.height) -
            (MediaQuery.of(context).padding.top),
        topX: (MediaQuery.of(context).padding.top));

    // final firebaseUser = Provider.of<User?>(context);

    // final usuarioIDsCarpeta = Provider.of<UsuarioIDs>(context);

    // final init = GetStorage();

    // print(firebaseUser);

    // ? INICIALIZAR INTRO
    // init.remove('Intro');

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(media.ama),
        body: SizedBox(
          width: media.ancho,
          height: media.alto,
          child: Stack(
            children: [
              // * Home App (Principal)
              SizedBox(
                width: media.ancho,
                height: media.alto,
                child: const Home(),
              ),
              // * Carga
              if (cargaBAN) const Carga(),
              // * Intro
              /* if (init.read("Intro") == null)
                SizedBox( 
                  width: media.ancho,
                  height: media.alto,
                  child: const Intro(),
                ), */
            ],
          ),
        ),
      ),
    );
  }
}
