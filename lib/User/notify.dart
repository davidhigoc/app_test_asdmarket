import 'package:asd_market/Service/Firebase/firestore.dart';
import 'package:asd_market/Service/Provider/media.dart';
import 'package:asd_market/Service/Widgets/widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class NotifyUser extends StatefulWidget {
  const NotifyUser({
    Key? key,
    required this.notify,
    required this.z,
  }) : super(key: key);

  final List notify;
  final int z;

  @override
  State<NotifyUser> createState() => _NotifyUserState();
}

class _NotifyUserState extends State<NotifyUser> {
  // VARIABLES
  Map? otraPerson;

  // FUNCIONES
  consultas() async {
    Map person = {};
    if (widget.notify[widget.z]["Est"] == "Venta") {
      // print(widget.notify[widget.z]["RutaUCom"]);
      person = widget.notify[widget.z]["RutaUCom"];
    } else if (widget.notify[widget.z]["Est"] == "Compra") {
      // print(widget.notify[widget.z]["RutaUVen]);
      person = widget.notify[widget.z]["RutaUVen"];
    }
    await fireUser
        .doc("Public")
        .collection("${person["Year"]}")
        .doc("${person["Asinu"]}")
        .get()
        .then((per) {
      if (per.exists) {
        setState(() {
          otraPerson = per.data();
        });
      } else {
        setState(() {
          otraPerson = {};
        });
      }
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

    double ancho = media.ancho;

    switch (widget.notify[widget.z]["Est"]) {
      case "Venta":
        return ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          child: Container(
            width: ancho - 40,
            height: 190,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            child: Column(
              children: [
                // notificación
                SizedBox(
                  width: ancho - 40,
                  height: 90,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: Image.network(
                            "${widget.notify[widget.z]["Foto"]}",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          width: ancho - 150,
                          height: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: ancho - 150,
                                child: Text(
                                  "${widget.notify[widget.z]["Titulo"]}",
                                  textAlign: TextAlign.left,
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    width: ancho - 140,
                                    child: const Text(
                                      "Vendiste!",
                                      textAlign: TextAlign.left,
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              /* SizedBox(
                                width: ancho - 180,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Color(media.azul),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(4),
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
                                      child: const Center(
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: ancho - 220,
                                      child: Text(
                                        "\$ ${widget.notify[widget.z]["Precio"]}",
                                        textAlign: TextAlign.right,
                                        maxLines: 2,
                                        style: TextStyle(
                                          color: Colors.grey.shade900,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ), */
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Info otraPerson [NULL]
                if (otraPerson == null)
                  SizedBox(
                    width: ancho - 40,
                    height: 90,
                    child: Center(
                      child: SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(
                          color: Color(media.azul),
                        ),
                      ),
                    ),
                  ),
                // Info otraPerson [DATA]
                if (otraPerson != null)
                  SizedBox(
                    width: ancho - 40,
                    height: 90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: (ancho - 40) - 110,
                          height: 80,
                          child: Column(
                            children: [
                              SizedBox(
                                width: (ancho - 40) - 110,
                                child: Text(
                                  "Comprador:",
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: SizedBox(
                                  width: (ancho - 40) - 110,
                                  child: Text(
                                    otraPerson!["Nombre"] != null
                                        ? "${otraPerson!["Nombre"]}"
                                        : "Sin Nombre",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Colors.grey.shade800,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: (ancho - 40) - 110,
                                child: Text(
                                  otraPerson!["Tel"] != null
                                      ? "Tel: ${otraPerson!["Tel"]}"
                                      : "${otraPerson!["Correo"]}",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: Center(
                            child: fotoURL(
                                80, otraPerson!["Foto"], media.azul, false),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );

      case "Compra":
        return ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          child: Container(
            width: ancho - 40,
            height: 190,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            child: Column(
              children: [
                // notificación
                SizedBox(
                  width: ancho - 40,
                  height: 90,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: Image.network(
                            "${widget.notify[widget.z]["Foto"]}",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          width: ancho - 150,
                          height: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: ancho - 150,
                                child: Text(
                                  "${widget.notify[widget.z]["Titulo"]}",
                                  textAlign: TextAlign.left,
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    width: ancho - 140,
                                    child: const Text(
                                      "Compraste!",
                                      textAlign: TextAlign.left,
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Info otraPerson [NULL]
                if (otraPerson == null)
                  SizedBox(
                    width: ancho - 40,
                    height: 90,
                    child: Center(
                      child: SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(
                          color: Color(media.azul),
                        ),
                      ),
                    ),
                  ),
                // Info otraPerson [DATA]
                if (otraPerson != null)
                  SizedBox(
                    width: ancho - 40,
                    height: 90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: (ancho - 40) - 110,
                          height: 80,
                          child: Column(
                            children: [
                              SizedBox(
                                width: (ancho - 40) - 110,
                                child: Text(
                                  "Vendedor:",
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: SizedBox(
                                  width: (ancho - 40) - 110,
                                  child: Text(
                                    otraPerson!["Nombre"] != null
                                        ? "${otraPerson!["Nombre"]}"
                                        : "Sin Nombre",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Colors.grey.shade800,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: (ancho - 40) - 110,
                                child: Text(
                                  otraPerson!["Tel"] != null
                                      ? "Tel: ${otraPerson!["Tel"]}"
                                      : "${otraPerson!["Correo"]}",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: Center(
                            child: fotoURL(
                                80, otraPerson!["Foto"], media.azul, false),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );

      default:
        return const SizedBox();
    }
  }
}
