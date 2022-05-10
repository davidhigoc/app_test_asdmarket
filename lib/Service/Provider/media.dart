import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class Media with ChangeNotifier {
  // ! DB
  // ? INICIALIZACIÓN
  GetStorage dbInit(String dbEsp) {
    // ignore: avoid_print
    print("Iniciando DB -> $dbEsp");
    GetStorage initDB = GetStorage(dbEsp);
    return initDB;
  }

  dbSave(GetStorage contenedor, String clave, dynamic valor) {
    final init = contenedor;
    init.write(clave, valor);
    notifyListeners();
  }

  // ! VARIABLES
  // Finals Publico
  final int verde = 0xff8AB102;
  final int ama = 0xffE9D839; // 005070
  final int azul = 0xff005070;

  // dimensiones basicas
  double ancho = 0.0;
  double alto = 0.0;
  double altop = 0.0;
  double top = 0.0;

  // categorias [Logica - Store]
  List categorias = [];

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
