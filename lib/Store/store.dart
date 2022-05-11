import 'package:asd_market/Service/Firebase/firestore.dart';
import 'package:asd_market/Service/Provider/media.dart';
import 'package:asd_market/Store/product.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class Store extends StatefulWidget {
  const Store({Key? key, required this.cat}) : super(key: key);

  final Map cat;

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
  // VARIABLES
  List? productos;

  // FUNCIONES
  Future products() async {
    await fireProductos
        .doc("${widget.cat["Ref"]}")
        .collection("${DateTime.now().year}")
        .get()
        .then((pro) {
      if (pro.size > 0) {
        List listatem = [];
        for (var element in pro.docs) {
          listatem.add(element.data());
        }
        setState(() {
          productos = listatem;
        });
      } else {
        setState(() {
          productos = [];
        });
      }
    });
  }

  @override
  void initState() {
    products();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final media = Provider.of<Media>(context, listen: false);

    double ancho = media.ancho;
    double altop = media.altop;

    return Scaffold(
      backgroundColor: Color(media.verde),
      body: SafeArea(
        child: Container(
          width: ancho,
          height: altop,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(media.verde),
                Colors.grey.shade200,
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // * Header
                SizedBox(
                  height: 61,
                  width: ancho,
                  child: Stack(
                    children: [
                      // BARRA HORIZONTAL
                      Positioned(
                        top: 8,
                        right: 10,
                        child: Container(
                          width: ancho - 80,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Color(media.azul),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 10.0,
                              right: 10.0,
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: ancho - 130,
                                  child: Text(
                                    "${widget.cat["Categ"]}",
                                    textAlign: TextAlign.left,
                                    maxLines: 2,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (productos == null)
                                  const SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                              ],
                            ),
                          ),
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
                    ],
                  ),
                ),
                // Anuncios = productos para vender segpun categoria
                SizedBox(
                  width: ancho - 20,
                  child: productos != null
                      ? productos!.isNotEmpty
                          ? Wrap(
                              spacing: 6.0,
                              children: [
                                for (var z = 0; z <= productos!.length - 1; z++)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 6.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => Product(
                                                pro: productos![z], my: false),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: ((ancho - 20) / 2) - 3,
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
                                        child: Column(
                                          children: [
                                            // Imagen
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(6.0),
                                                child: Container(
                                                  width: ((ancho - 20) / 2) - 3,
                                                  height:
                                                      ((ancho - 20) / 2) - 3,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(8),
                                                    ),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          "${productos![z]["Foto"]}"),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Grupo Inferior
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 5.0,
                                                left: 5.0,
                                                right: 5.0,
                                                bottom: 10.0,
                                              ),
                                              child: Column(
                                                children: [
                                                  // Envio
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: 30,
                                                        height: 30,
                                                        child: Center(
                                                          child: Icon(
                                                            Icons.place,
                                                            color: productos![z]
                                                                    ["Envio"]
                                                                ? Colors.green
                                                                : Colors.grey
                                                                    .shade800,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        child: Text(
                                                          productos![z]["Envio"]
                                                              ? "Envío Gratis"
                                                              : "Sin envío",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: productos![z]
                                                                    ["Envio"]
                                                                ? Colors.green
                                                                : Colors.grey
                                                                    .shade800,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  // Titulo
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: SizedBox(
                                                      width:
                                                          ((ancho - 20) / 2) -
                                                              3,
                                                      height: 30,
                                                      child: Center(
                                                        child: Text(
                                                          "${productos![z]["Titulo"]}",
                                                          textAlign:
                                                              TextAlign.center,
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey.shade800,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  // Precio
                                                  SizedBox(
                                                    width:
                                                        ((ancho - 20) / 2) - 3,
                                                    height: 30,
                                                    child: Center(
                                                      child: Text(
                                                        "\$ ${productos![z]["Precio"]}",
                                                        textAlign:
                                                            TextAlign.center,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color:
                                                              Color(media.azul),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            )
                          : SizedBox(
                              width: ancho,
                              height: altop - 61,
                              child: Center(
                                child: Text(
                                  "Upss! No hay productos en esta categoría",
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                      : const SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
