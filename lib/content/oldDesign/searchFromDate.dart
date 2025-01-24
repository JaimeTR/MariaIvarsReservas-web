import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mariaivarsreservas/content/oldDesign/reservation_form.dart';
import 'package:mariaivarsreservas/content/oldDesign/reservation_list.dart';
import 'package:mariaivarsreservas/data/apiService.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../constant/constant.dart';

class SearchFromDate extends StatefulWidget {
  @override
  _SearchFromDateState createState() => _SearchFromDateState();
}

class _SearchFromDateState extends State<SearchFromDate> {
  final ApiService apiService = ApiService(
    baseUrl: 'https://campingbenigembla.com/',
    token:
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2NhbXBpbmdiZW5pZ2VtYmxhLmNvbSIsImlhdCI6MTcyNDkyODM3MSwibmJmIjoxNzI0OTI4MzcxLCJleHAiOjQ4Nzg1MjgzNzEsImRhdGEiOnsidXNlciI6eyJpZCI6IjEifX19.Dw-aOaSG_ZL9ccXpHrqRWRhUfrNUwP8zg4JAzPkILUU',
  );

  String? selectedClient;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<dynamic> reservations = [];
  Set<DateTime> reservedDates = {};
  List<dynamic> filteredReservations = [];
  bool loading = false;
  bool showForm = false;
  Map<String, dynamic> selectedReservation = {};
  List<Map<String, String>> updatedParcels = [];
  Map<DateTime, Color> reservationColors = {};
  final List<Map<String, String>> baseParcelsDefault = [
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

  // Lista base de parcelas con la nomenclatura específica

  @override
  void initState() {
    super.initState();
    Constant.baseParcels = baseParcelsDefault;
    fetchReservations();
  }

  Future<void> fetchReservations() async {
    try {
      final data = await apiService.fetchReservations();
      setState(() {
        reservations = data;
        reservedDates = _getReservedDates();
      });
      //debugPrint('Fetched Reservations: $reservations');
      // debugPrint('Reserved Dates: $reservedDates');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Set<DateTime> _getReservedDates() {
    loading = false;
    Set<DateTime> reservedDates = {};
    reservationColors.clear(); // Limpia los colores previamente asignados

    for (var reservation in reservations) {
      if (reservation.containsKey('meta')) {
        var meta = reservation['meta'];
        String? entryDateStr = meta['entryDate'];
        String? exitDateStr = meta['exitDate'];
        String? clientName = meta['name'];

        // Validar que las fechas de entrada y salida no sean nulas
        if (entryDateStr != null && exitDateStr != null) {
          DateTime entryDate = DateTime.parse(entryDateStr);
          DateTime exitDate = DateTime.parse(exitDateStr);

          // Garantizar que las fechas estén en el orden correcto
          if (exitDate.isAfter(entryDate) ||
              exitDate.isAtSameMomentAs(entryDate)) {
            // Filtrar por cliente seleccionado
            if (selectedClient == null || clientName == selectedClient) {
              // Iterar desde la fecha de entrada hasta la de salida
              for (var date = entryDate;
                  !date.isAfter(exitDate);
                  date = date.add(const Duration(days: 1))) {
                reservedDates.add(date);

                // Asignar colores dependiendo de la lógica
                if (date == entryDate) {
                  // Color para la fecha de entrada
                  reservationColors[date] =
                      Colors.green; // Fecha de entrada (puedes cambiarlo)
                } else if (date == exitDate) {
                  // Color para la fecha de salida
                  reservationColors[date] = Colors.pink; // Fecha de salida
                } else {
                  // Color para fechas intermedias
                  reservationColors[date] = clientName == selectedClient
                      ? Colors.orange // Cliente seleccionado
                      : Colors.green; // General (sin cliente seleccionado)
                }
              }
            }
          }
        }
      }
    }

    loading = true;
    return reservedDates;
  }

  void _filterReservationsByDate(DateTime date) {
    Constant.reloadValues();
    updatedParcels = List.from(Constant.baseParcels);

    // Normalizar la fecha seleccionada para comparar solo días
    DateTime normalizedDate = DateTime(date.year, date.month, date.day);

    for (var reservation in reservations) {
      if (reservation.containsKey('meta')) {
        var meta = reservation['meta'];
        String? entryDateStr = meta['entryDate'];
        String? exitDateStr = meta['exitDate'];
        String? clientName = meta['name'];

        if (entryDateStr != null &&
            exitDateStr != null &&
            (selectedClient == null || clientName == selectedClient)) {
          // Normalizar las fechas de entrada y salida
          DateTime entryDate = DateTime.parse(entryDateStr);
          DateTime exitDate = DateTime.parse(exitDateStr);
          DateTime normalizedEntryDate =
              DateTime(entryDate.year, entryDate.month, entryDate.day);
          DateTime normalizedExitDate =
              DateTime(exitDate.year, exitDate.month, exitDate.day);

          // Verificar si la fecha seleccionada está dentro del rango
          if ((normalizedDate.isAtSameMomentAs(normalizedEntryDate) ||
                  normalizedDate.isAfter(normalizedEntryDate)) &&
              (normalizedDate.isAtSameMomentAs(normalizedExitDate) ||
                  normalizedDate.isBefore(normalizedExitDate))) {
            String parcel = meta['parcela'] ?? '';
            String title = reservation['title']['rendered'] ?? 'No title';
            String name = meta['name'] ?? '';
            String phone = meta['phone'] ?? '';
            String numPersonas = meta['numberOfPeople'].toString();
            String vehicle = meta['vehicle'] ?? '';
            String email = meta['email'] ?? '';
            String observaciones = meta['observaciones'] ?? '';
            String pendienteConfirmar = meta['pendienteConfirmar'] ?? 'False';

            // Actualizar la parcela correspondiente
            var parcelToUpdate = updatedParcels
                .firstWhere((element) => element['parcel'] == parcel);
            parcelToUpdate['title'] = title;
            parcelToUpdate['name'] = name;
            parcelToUpdate['phone'] = phone;
            parcelToUpdate['numberOfPeople'] = numPersonas;
            parcelToUpdate['vehicle'] = vehicle;
            parcelToUpdate['email'] = email;
            parcelToUpdate['entryDate'] = entryDateStr;
            parcelToUpdate['exitDate'] = exitDateStr;
            parcelToUpdate['observaciones'] = observaciones;
            parcelToUpdate['pendienteConfirmar'] = pendienteConfirmar;
            parcelToUpdate['id'] = reservation['id'].toString();
          }
        }
      }
    }

    // Actualizar el estado
    setState(() {
      filteredReservations = updatedParcels;
      showForm = false;
      selectedReservation = {};
    });
  }

  void _onReservationTap(Map<String, String> reservation) {
    setState(() {
      showForm = true;
      selectedReservation = {};
      selectedReservation = reservation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.08,
          right: MediaQuery.of(context).size.width * 0.08,
          top: MediaQuery.of(context).size.width * 0.03,
          bottom: MediaQuery.of(context).size.width * 0.03),
      child: Card(
        elevation: 10,
        child: loading == false
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.brown,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.02,
                          vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: AnimatedAlign(
                              alignment: Alignment.center,
                              duration: const Duration(seconds: 1),
                              child: TableCalendar(
                                locale: 'es_ES', // Cambiar idioma a español
                                firstDay: DateTime.utc(2000, 1, 1),
                                lastDay: DateTime.utc(2100, 12, 31),
                                focusedDay: _focusedDay,
                                selectedDayPredicate: (day) {
                                  return isSameDay(_selectedDay, day);
                                },
                                onDaySelected: (selectedDay, focusedDay) {
                                  setState(() {
                                    _selectedDay = selectedDay;
                                    Constant.calendarIniciotx =
                                        formatDateToString(_selectedDay!);
                                    //debugdebugPrint(Constant.calendarIniciotx);
                                    _focusedDay = focusedDay;
                                    _filterReservationsByDate(selectedDay);
                                  });
                                },
                                startingDayOfWeek: StartingDayOfWeek
                                    .monday, // Comienza el lunes
                                availableCalendarFormats: const {
                                  CalendarFormat.month:
                                      'Month', // Solo permitimos la vista mensual
                                },
                                calendarBuilders: CalendarBuilders(
                                  defaultBuilder: (context, day, focusedDay) {
                                    DateTime normalizedDay =
                                        DateTime(day.year, day.month, day.day);

                                    if (reservedDates.any((reservedDate) =>
                                        DateTime(
                                            reservedDate.year,
                                            reservedDate.month,
                                            reservedDate.day) ==
                                        normalizedDay)) {
                                      return Container(
                                        margin: const EdgeInsets.all(6.0),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: reservationColors[
                                                  normalizedDay] ??
                                              Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Text(
                                          day.day.toString(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      );
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.03),
                          Expanded(
                            child: Column(
                              children: [
                                DropdownButton<String>(
                                  hint: Text('Selecciona un cliente'),
                                  value: selectedClient,
                                  isExpanded: true,
                                  items: [
                                    DropdownMenuItem(
                                      value: null,
                                      child: Text('Todos los clientes'),
                                    ),
                                    ...(() {
                                      // Crear una lista de nombres únicos y ordenados con limpieza de texto
                                      final clientNames = reservations
                                          .map<String>((reservation) =>
                                              (reservation['meta']['name'] ??
                                                      'Sin nombre')
                                                  .trim()) // Eliminar espacios
                                          .toSet() // Eliminar duplicados
                                          .toList()
                                        ..sort((a, b) => a.compareTo(
                                            b)); // Ordenar alfabéticamente

                                      // Crear DropdownMenuItems para cada cliente
                                      return clientNames
                                          .map<DropdownMenuItem<String>>(
                                              (clientName) {
                                        return DropdownMenuItem(
                                          value: clientName,
                                          child: Text(clientName),
                                        );
                                      }).toList();
                                    })(),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedClient = value;
                                      reservedDates =
                                          _getReservedDates(); // Actualizar fechas y colores
                                      _filterReservationsByDate(
                                          _selectedDay ?? _focusedDay);
                                    });
                                  },
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.width *
                                        0.03),
                                ReservationList(
                                  filteredReservations: filteredReservations,
                                  onReservationTap: _onReservationTap,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                    Visibility(
                      visible: showForm,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.brown.withOpacity(0.3),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Datos de la reserva',
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.015,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: showForm,
                      child: ReservationForm(
                        reservation: selectedReservation,
                        apiService: apiService,
                        reservations: reservations,
                        onFormSubmit: () {
                          Constant.baseParcels = baseParcelsDefault;
                          setState(() {
                            showForm = false;
                            fetchReservations();
                            _filterReservationsByDate(_selectedDay!);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  String formatDateToString(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
