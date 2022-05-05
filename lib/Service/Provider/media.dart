import 'package:flutter/material.dart';

class Media with ChangeNotifier {
  // ! DB
  // ? INICIALIZACIÓN

  // ! VARIABLES
  // Finals Publico
  final int verde = 0xff8AB102;
  final int ama = 0xffE9D839; // 005070
  final int azul = 0xff005070;

  // Changes Publico
  double ancho = 0.0;
  double alto = 0.0;
  double altop = 0.0;
  double top = 0.0;

  // * FUNCIONES GLOBALES
  // Fundamentos iniciales del context
  iniciales({
    required double anchoX,
    required double altoX,
    required double altopX,
    required double topX,
  }) {
    ancho = anchoX;
    alto = altoX;
    altop = altopX;
    top = topX;
  }

  // ! * bordes
  BoxDecoration bordeYSombra() {
    return const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
      boxShadow: [
        BoxShadow(color: Colors.black12, offset: Offset(1, 1), blurRadius: 3),
        BoxShadow(
          color: Colors.black12,
          offset: Offset(-1, -1),
          blurRadius: 3,
        )
      ],
    );
  }

  BorderRadius borde(double borde) {
    return BorderRadius.all(Radius.circular(borde));
  }

  List<BoxShadow> get sombra2_3 {
    return [
      const BoxShadow(
        color: Colors.black12,
        offset: Offset(2, 2),
        blurRadius: 3,
      ),
      const BoxShadow(
        color: Colors.black12,
        offset: Offset(-2, -2),
        blurRadius: 3,
      )
    ];
  }
}
