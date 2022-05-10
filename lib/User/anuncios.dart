import 'package:asd_market/Service/Provider/media.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class AnunciosUser extends StatelessWidget {
  const AnunciosUser({
    Key? key,
    required this.anunciosU,
    required this.z,
  }) : super(key: key);

  final List anunciosU;
  final int z;

  @override
  Widget build(BuildContext context) {
    final media = Provider.of<Media>(context, listen: false);

    double ancho = media.ancho;

    switch (anunciosU[z]["Est"]) {
      case "Disponible":
        return ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          child: Container(
            width: ancho - 40,
            height: 130,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SizedBox(
                    width: 120,
                    height: 120,
                    child: Image.network(
                      "${anunciosU[z]["Fotos"][0]}",
                    ),
                  ),
                ),
                SizedBox(
                  width: ancho - 180,
                  height: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: ancho - 180,
                        child: Text(
                          "${anunciosU[z]["Titulo"]}",
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: ancho - 180,
                            child: Text(
                              "${anunciosU[z]["Est"]}",
                              textAlign: TextAlign.left,
                              maxLines: 2,
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: ancho - 180,
                            child: Text(
                              "${anunciosU[z]["Cat"]["Categ"]}",
                              textAlign: TextAlign.left,
                              maxLines: 2,
                              style: TextStyle(
                                color: Colors.grey.shade900,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
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
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: ancho - 220,
                              child: Text(
                                "\$ ${anunciosU[z]["Precio"]}",
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
