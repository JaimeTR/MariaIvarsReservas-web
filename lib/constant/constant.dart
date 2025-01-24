import 'package:flutter/material.dart';

class Constant {
  static TextEditingController parcelaController = TextEditingController();
  static int? formId;
  static TextEditingController clienteController = TextEditingController();
  static TextEditingController telefonoController = TextEditingController();
  static TextEditingController numPersonasController = TextEditingController();
  static TextEditingController observacionesCnotroller =
      TextEditingController();
  static TextEditingController vehiculoController = TextEditingController();
  static TextEditingController correoController = TextEditingController();
  static TextEditingController inicioController = TextEditingController();
  static String? calendarIniciotx;
  static TextEditingController finalizacionController = TextEditingController();
  static ValueNotifier<String> pendienteDeConfirmarNotifier =
      ValueNotifier<String>('False');
  static TextEditingController pendienteDeConfirmar = TextEditingController();
  static String checkStatus = 'Actualizar';
  static List<Map<String, String>> baseParcels = [];
  static void reloadValues() {
    Constant.baseParcels = [
      // A01 a A14
      {'parcel': 'A01', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'A02', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'A03', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'A04', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'A05', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'A06', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'A07', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'A08', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'A09', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'A10', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'A11', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'A12', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'A13', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'A14', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},

      // B01 a B14
      {'parcel': 'B01', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'B02', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'B03', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'B04', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'B05', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'B06', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'B07', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'B08', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'B09', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'B10', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'B11', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'B12', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'B13', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'B14', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'B15', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},

      // C01 a C07
      {'parcel': 'C01', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'C02', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'C03', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'C04', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'C05', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'C06', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'C07', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'C08', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},

      // D01 a D04
      {'parcel': 'D01', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'D02', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'D03', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'D04', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'D05', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},

      // E01 a E04
      {'parcel': 'E01', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'E02', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'E03', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'E04', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},

      // F01 a F08
      {'parcel': 'F01', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'F02', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'F03', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'F04', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'F05', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'F06', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'F07', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'F08', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},

      // G01 a G04
      {'parcel': 'G01', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'G02', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'G03', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'G04', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'G05', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},

      // P01 a P06
      {'parcel': 'P01', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'P02', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'P03', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'P04', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'P05', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
      {'parcel': 'P06', 'title': '', 'name': '', 'phone': '', 'exitDate': ''},
    ];
  }

  static bool alreadyInit = false;
  static int selectVista = 0;
}
