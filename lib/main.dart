import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mariaivarsreservas/constant/constant.dart';
import 'package:mariaivarsreservas/provider/allProvider.dart';
import 'package:mariaivarsreservas/sharedPreferences/sharedPreferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'content/login/login.dart';

//Creado por Juan Ormaechea el 30/03/2024

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting(
      'es_ES', null); // Pasa el código de localización aquí

  // Inicializar las preferencias de datos
  await DataPreferences.cargarPreferencias();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = 'es_ES';
    return ChangeNotifierProvider(
        create: (context) => AllProvider(),
        builder: (context, child) {
          return MaterialApp(
            title: 'Sistema de reservas',
            locale: Locale('es', 'ES'), // Forzar idioma español
            supportedLocales: [
              const Locale('es', 'ES'), // Español
            ],
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              primarySwatch: Colors.blue,
            ),
            home: const MyHomePage(),
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final allProvider = Provider.of<AllProvider>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFd4e6d4),
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.

          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/logo/logo-web.png',
                height: 20,
              ),
              const SizedBox(
                width: 30,
              ),
              const Text(
                "Sistema de reservas",
                style: TextStyle(color: Colors.brown),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                'assets/img/wall.jpg',
                fit: BoxFit
                    .cover, // Asegúrate de usar BoxFit.cover para que la imagen cubra todo el espacio
              ),
            ),
            if (allProvider.selectDesign != 0 || Constant.selectVista != 0)
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Tooltip(
                    message: 'Cambiar vista',
                    child: IconButton(
                        icon: Icon(
                          Icons.change_circle_rounded,
                          color: const Color.fromARGB(255, 255, 0, 0),
                          size: 30,
                        ),
                        onPressed: () async {
                          if (allProvider.selectDesign == 0) {
                            allProvider.setSelectScreen(1);
                          } else {
                            allProvider.setSelectScreen(0);
                          }
                          Constant.selectVista = allProvider.selectDesign;
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setInt(
                              'selectVista', allProvider.selectDesign);
                        }),
                  ),
                ),
              ),
            Center(child: FadeIn(child: const LoginPage())),
          ],
        ));
  }
}
