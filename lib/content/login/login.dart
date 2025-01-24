import 'package:flutter/material.dart';
import 'package:mariaivarsreservas/content/newDesign/CalendarTableView.dart';
import 'package:mariaivarsreservas/provider/allProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/constant.dart';
import '../../widgets/customNotificationError.dart';
import '../oldDesign/searchFromDate.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadRememberedLogin();

    //_startColorChangeTimer();
  }

  Future<void> _loadRememberedLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool rememberMe = prefs.getBool('remember_me') ?? false;
    if (rememberMe) {
      String? username = prefs.getString('username');
      String? password = prefs.getString('password');
      Constant.selectVista = prefs.getInt('selectVista') ??0;
      //  Constant.alreadyInit = true;
      if (username != null && password != null) {
        _usernameController.text = username;
        _passwordController.text = password;
      }
      setState(() {
        _rememberMe = rememberMe;
      });
    }
  }
  //const Color.fromARGB(255, 138, 170, 102),

  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Aquí puedes añadir la lógica de autenticación
    if ((username == 'campingbenigembla' || username == 'RecepcionCamping') &&
        (password == 'Albert-3897.1970' || password == 'edrfghuj987654QQ')) {
      if (_rememberMe) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('remember_me', true);
        await prefs.setString('username', username);
        await prefs.setString('password', password);
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('remember_me', false);
        await prefs.remove('username');
        await prefs.remove('password');
      }
      Constant.alreadyInit = true;
      setState(() {});
    } else if (username == "" ||
        (username != 'campingbenigembla' || username != 'campingbenigembla')) {
      showCustomNotificationERROR(context, "usuario incorrecto");
    } else if (password == "" ||
        (password == '87654tgbhjk98u7y6' || password == 'edrfghuj987654QQ')) {
      showCustomNotificationERROR(context, "contraseña incorrecta");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final allProvider = Provider.of<AllProvider>(context);
    return Constant.alreadyInit == true &&
            (allProvider.selectDesign == 0 || Constant.selectVista == 0)
        // ? SearchFromDate()
        ? CalendarTableView()
        : Constant.alreadyInit == true &&
                (allProvider.selectDesign != 0 || Constant.selectVista != 0)
            ? SearchFromDate()
            : Center(
                child: SizedBox(
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.7,
                  child: Card(
                    elevation: 10,
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: 150,
                                child: Image.asset(
                                  'assets/logo/logo-web.png',
                                ) // Reemplaza con tu imagen
                                ),
                            const SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.3),
                                    Colors.white.withOpacity(0.3)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              width: screenWidth * 0.3,
                              child: TextField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 0.0),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.person,
                                    color: Colors.brown,
                                  ),
                                  labelText: 'Usuario',
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.3),
                                    Colors.white.withOpacity(0.3)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              width: screenWidth * 0.3,
                              child: TextField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.lock,
                                    color: Colors.brown,
                                  ),
                                  labelText: 'Contraseña',
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 0.0),
                                  ),
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: IconButton(
                                      color: Colors.brown,
                                      icon: const Icon(Icons.visibility),
                                      onPressed: () {},
                                    ),
                                  ),
                                ),
                                obscureText: true,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Theme(
                                    data: ThemeData(
                                      checkboxTheme: CheckboxThemeData(
                                        fillColor:
                                            MaterialStateProperty.resolveWith(
                                                (Set<MaterialState> states) {
                                          if (states.contains(
                                              MaterialState.selected)) {
                                            return Colors
                                                .orange; // Color cuando está seleccionado
                                          }
                                          return Colors
                                              .white; // Color cuando no está seleccionado
                                        }),
                                        checkColor:
                                            MaterialStateProperty.resolveWith(
                                                (Set<MaterialState> states) {
                                          if (states.contains(
                                              MaterialState.selected)) {
                                            return Colors
                                                .white; // Color del check (✓) cuando está seleccionado
                                          }
                                          return null; // Mantener el color predeterminado del check (✓) cuando no está seleccionado
                                        }),
                                      ),
                                    ),
                                    child: Checkbox(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(2.0),
                                      ),
                                      side: MaterialStateBorderSide.resolveWith(
                                        (states) => const BorderSide(
                                            width: 1.0, color: Colors.black),
                                      ),
                                      checkColor: Colors.black,
                                      value: _rememberMe,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _rememberMe = value ?? false;
                                        });
                                      },
                                    )),
                                const Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Text('Recordar sesión',
                                      style: TextStyle(color: Colors.black)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 90, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              child: const Text(
                                'Iniciar sesión',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
  }

  void showCustomNotificationERROR(BuildContext context, String message) {
    OverlayEntry? overlayEntry; // Declaramos la variable fuera del constructor

    // Creamos una nueva instancia de OverlayEntry
    overlayEntry = OverlayEntry(
        builder: (context) => CustomNotificationError(
              message: message,
              onClose: () {
                // Usamos la referencia para remover la entrada
                overlayEntry?.remove();
              },
            ));

    // Insertamos el OverlayEntry en el Overlay actual
    Overlay.of(context)!.insert(overlayEntry);
  }
}
