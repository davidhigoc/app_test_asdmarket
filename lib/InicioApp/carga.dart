import 'package:asd_market/Service/Provider/media.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Carga extends StatefulWidget {
  const Carga({Key? key}) : super(key: key);

  @override
  _ProcesoB createState() => _ProcesoB();
}

class _ProcesoB extends State<Carga> {
  // * VARIABLES

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide'); // Cierra teclado
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Providers
    final media = Provider.of<Media>(context);

    double ancho = media.ancho;
    double alto = media.alto;

    return Container(
      width: ancho,
      height: alto,
      color: Color(media.ama),
      child: SafeArea(
        child: Container(
          width: ancho,
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
          child: Center(
            child: Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage("Assets/Images/Base/Icon2.png"),
                  fit: BoxFit.cover,
                  // scale: 0.2,
                ),
              ),
              child: SizedBox(
                child: CircularProgressIndicator(
                  color: Color(media.azul),
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
