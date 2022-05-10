import 'package:asd_market/Service/Auth/auth_service.dart';
import 'package:asd_market/Service/Formatos/formato_mayu_minu.dart';
import 'package:asd_market/Service/Provider/media.dart';
import 'package:asd_market/Service/Provider/user_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // ? CONTEXTO UNICO PARA LOGUEP Y REGISTRO DE USUARIOS
  // ? ESTADO 0 -> INGRESAR lOGUEO
  // ? ESTADO 1 -> RECUPERAR CONTRASEÑA
  // ? ESTADO 2 -> REGISTRO

  // * VARIABLES
  int est = 0;
  bool esperar = false;
  TextEditingController correo = TextEditingController()..text = "";
  TextEditingController pass = TextEditingController()..text = "";
  String men = "";
  bool menEr = false;

  // Initially password is obscure
  bool _obscureText = true;
  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  // ! ACCIÓN
  actividadPage() async {
    UsID userID = Provider.of<UsID>(context, listen: false);
    setState(() {
      esperar = true;
      menEr = false;
    });

    if (est == 0) {}

    switch (est) {
      case 0:
        if (pass.text.trim().length >= 6) {
          if (correo.text.trim().isNotEmpty) {
            userID.est = 1;
            await context
                .read<ElUser>()
                .inicioS(correo.text.trim(), pass.text.trim(), context)
                .then((valor) {
              if (valor[0] == 200) {
                Navigator.of(context).pop();
              } else {
                errores(valor[0]);
              }
            });
          } else {
            errores(2);
          }
        } else {
          errores(1);
        }
        break;

      case 1:
        if (correo.text.trim().isNotEmpty) {
          await context
              .read<ElUser>()
              .resetContra(correo.text.trim())
              .then((value) {
            errores(value);
          });
        } else {
          errores(2);
        }

        break;

      case 2:
        if (pass.text.trim().length >= 6) {
          if (correo.text.trim().isNotEmpty) {
            userID.est = 1;
            await context
                .read<ElUser>()
                .registro(correo.text.trim(), pass.text.trim(), context, userID)
                .then((valor) {
              if (valor[0] == 200) {
                Navigator.of(context).pop();
              } else {
                errores(valor[0]);
              }
            });
          } else {
            errores(2);
          }
        } else {
          errores(1);
        }
        break;
    }
  }

  errores(int er) {
    // ? ERRORES -
    switch (er) {
      case 1:
        men = "Upss! La contraseña debe tener al menos 6 caracteres.";
        break;
      case 2:
        men = "Verifiqué su correo electrónico";
        break;
      case 3:
        men = "Este correo ya esta en uso";
        break;
      case 4:
        men = "Correo invalido";
        break;
      case 5:
        men = "Contraseña incorrecta";
        break;
      case 6:
        men = "Correo invalido";
        break;
      case 7:
        men = "Usuario no existe";
        break;
      case 8:
        men = "Usuario inhabilitado";
        break;
      case 9:
        men = "Upss! Intentalo más tarde";
        break;
      case 10:
        men = "Bien! Revisa tu correo electrónico.";
        break;
    }
    // Si hay error -> mostramos mensaje de error
    setState(() {
      if (er == 0) {
        menEr = false;
      } else {
        menEr = true;
      }
      esperar = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final media = Provider.of<Media>(context, listen: false);

    double ancho = media.ancho;
    double altop = media.altop;

    double anchito = ancho - 70;

    return Scaffold(
      backgroundColor: Color(media.ama),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
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
                  child: Stack(
                    children: [
                      // CAJA PRINCIPAL
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: ancho,
                          height: altop,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: media.borde(15),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                width: ancho,
                                height: 65,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 60.0, right: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        est == 0
                                            ? "Iniciar Sesión"
                                            : est == 1
                                                ? "Recuperar Contraseña"
                                                : "Registro",
                                        style: TextStyle(
                                          color: Colors.grey[900],
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(
                                        Icons.account_circle,
                                        size: 30,
                                        color: Colors.grey[900],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // * Textico
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 8.0,
                                  bottom: 8.0,
                                ),
                                child: SizedBox(
                                  width: anchito,
                                  child: Text(
                                    "Ingresa tus datos:",
                                    style: TextStyle(
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ),
                              ),
                              // * Correo
                              SizedBox(
                                width: anchito,
                                child: TextField(
                                  controller: correo,
                                  autocorrect: true,
                                  cursorWidth: 2,
                                  keyboardType: TextInputType.emailAddress,
                                  inputFormatters: [
                                    Minuscula(),
                                    FilteringTextInputFormatter.deny(' '),
                                  ],
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.orange,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 16.0, horizontal: 15.0),
                                    labelStyle: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[700],
                                    ),
                                    hintText: "* Correo electrónico",
                                    hintStyle: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 15,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade700,
                                        style: BorderStyle.solid,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // * Contraseña
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 10.0,
                                ),
                                child: Visibility(
                                  visible: est == 0 || est == 2,
                                  child: SizedBox(
                                    width: anchito,
                                    child: TextField(
                                      controller: pass,
                                      autocorrect: true,
                                      cursorWidth: 2,
                                      keyboardType: TextInputType.text,
                                      obscureText: _obscureText,
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          onPressed: _toggle,
                                          icon: Icon(
                                            !_obscureText
                                                ? Icons.visibility_rounded
                                                : Icons.visibility_off_rounded,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.orange,
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 16.0,
                                                horizontal: 15.0),
                                        labelStyle: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[700],
                                        ),
                                        hintText: "* Contraseña",
                                        hintStyle: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 15,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade700,
                                            style: BorderStyle.solid,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // * Mensaje de error
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Visibility(
                                  visible: menEr,
                                  child: Text(
                                    men,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.red.shade900,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              // * Boton de Accion [Principal]
                              SizedBox(
                                width: anchito,
                                height: 45,
                                child: ElevatedButton(
                                  onPressed: () async => actividadPage(),
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    backgroundColor: MaterialStateProperty.all(
                                      Color(media.azul),
                                    ),
                                  ),
                                  child: !esperar
                                      ? Text(
                                          est == 0
                                              ? "Ingresar"
                                              : est == 1
                                                  ? "Recuperar"
                                                  : "Registrarme",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        )
                                      : const SizedBox(
                                          width: 25,
                                          height: 25,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                              // * Olvide mi contraseña
                              Visibility(
                                visible: est == 0 || est == 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: SizedBox(
                                    width: anchito,
                                    height: 45,
                                    child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          if (est == 0) {
                                            est = 1;
                                          } else if (est == 1) {
                                            est = 0;
                                          }
                                        });
                                      },
                                      child: Text(
                                        est == 0
                                            ? "Olvidé mi contraseña"
                                            : "Iniciar Sesión",
                                        style: TextStyle(
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // * Grupi
                              Visibility(
                                visible: est == 0 || est == 2,
                                child: Column(
                                  children: [
                                    // * Divisor
                                    SizedBox(
                                      width: anchito,
                                      child: const Divider(
                                        height: 30,
                                        color: Colors.white,
                                        thickness: 1.2,
                                      ),
                                    ),
                                    // * Textico Regis
                                    Text(
                                      est == 0
                                          ? "¿Aún no tienes una cuenta? Regístrate !"
                                          : "¿Ya tienes una cuenta?",
                                      style: TextStyle(
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                    // * Boton de Registrarse
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: SizedBox(
                                        width: anchito,
                                        height: 45,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              if (est == 0) {
                                                est = 2;
                                              } else if (est == 1) {
                                                est = 2;
                                              } else if (est == 2) {
                                                est = 0;
                                              }
                                            });
                                          },
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              Color(media.azul),
                                            ),
                                          ),
                                          child: Text(
                                            est == 0 || est == 1
                                                ? "Registrarme"
                                                : "Iniciar Sesión",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // BOTON ATRAS
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
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
                      // IMAGEN CHEVRE
                      Positioned(
                        bottom: 50,
                        child: SizedBox(
                          width: ancho,
                          height: 80,
                          child:
                              Image.asset("Assets/Images/Base/titulo_App.png"),
                        ),
                      )
                    ],
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
