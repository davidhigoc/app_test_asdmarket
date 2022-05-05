import 'package:asd_market/InicioApp/inicio_auth.dart';
import 'package:asd_market/Service/Provider/media.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // NOTIFICACIONES BÁSICAS
        ChangeNotifierProvider(
          create: (_) => Media(),
        ),
      ],
      child: MaterialApp(
        title: 'ASD Market',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.lime,
        ),
        home: const IncioAuth(),
      ),
    );
  }
}
