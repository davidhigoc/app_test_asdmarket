import 'package:flutter/material.dart';

// FOTO DE USUARIOS [STANDARD]
Container fotoURL(double diametro, String url, dynamic color, bool sombra) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      boxShadow: sombra
          ? [
              BoxShadow(
                blurRadius: diametro / 3,
                color: Colors.grey.shade700,
                spreadRadius: 1,
              ),
            ]
          : null,
    ),
    child: CircleAvatar(
      backgroundColor: Color(color),
      radius: (diametro / 2),
      child: CircleAvatar(
        radius: (diametro / 2) - 4,
        backgroundColor: Colors.white,
        backgroundImage: NetworkImage(url),
      ),
    ),
  );
}

// REPUTACIÓN ESTRELLAS
SizedBox reputacion(double anchoT, double puntaje) {
  return SizedBox(
    child: Stack(
      children: [
        Container(
          width: anchoT,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
          ),
        ),
        Container(
          width: (anchoT * puntaje) / 5.0,
          height: 30,
          decoration: const BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
        ),
        SizedBox(
          width: anchoT,
          height: 30,
          child: Image.asset(
            "Assets/Images/Base/Estrellas.png",
            fit: BoxFit.fill,
          ),
        ),
      ],
    ),
  );
}

Container ventasU(double anchoT, int ventas) {
  return Container(
    width: anchoT,
    height: 30,
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(
        Radius.circular(2),
      ),
    ),
    child: Center(
      child: Text(
        "$ventas",
        style: TextStyle(
          color: Colors.grey.shade800,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
