import 'package:asd_market/Service/Provider/media.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  // VARIABLES
  int est = 0;

  @override
  Widget build(BuildContext context) {
    final media = Provider.of<Media>(context, listen: false);

    double ancho = media.ancho;
    double altop = media.altop;

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
          child: Column(
            children: [
              // Intrucciones
              SizedBox(
                width: ancho,
                height: altop - 80,
                child: Stack(
                  children: [
                    // Cuadro Blanco
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 30.0,
                        right: 30.0,
                        top: 60.0,
                      ),
                      child: Container(
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
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 30.0,
                              right: 30.0,
                            ),
                            child: SizedBox(
                              // width: ancho - 140,
                              child: Image.asset(
                                "Assets/Images/Base/Intro_${est + 1}.png",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Techo
                    SizedBox(
                      width: ancho,
                      child: Image.asset(
                        "Assets/Images/Base/techo.png",
                      ),
                    ),
                    // Icono de tienda
                    Positioned(
                      top: 60,
                      child: SizedBox(
                        width: ancho,
                        height: 80,
                        child: Image.asset("Assets/Images/Base/Icon1.png"),
                      ),
                    ),
                    //
                  ],
                ),
              ),
              // Bienvenida
              SizedBox(
                width: ancho,
                height: 80,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (est == 2) {
                          media.dbSave(GetStorage(), "Intro", true);
                        } else {
                          est++;
                        }
                      });
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
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        est == 0
                            ? "Siguiente"
                            : est == 1
                                ? "Siguiente"
                                : "Te damos la bienvenida",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
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
    );
  }
}
