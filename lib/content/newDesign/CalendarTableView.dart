import 'package:flutter/material.dart';
import 'package:mariaivarsreservas/constant/constant.dart';
import 'package:mariaivarsreservas/content/oldDesign/reservation_form.dart';
import 'package:mariaivarsreservas/data/apiService.dart';
import 'package:mariaivarsreservas/provider/allProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalendarTableView extends StatefulWidget {
  @override
  _CalendarTableViewState createState() => _CalendarTableViewState();
}

class _CalendarTableViewState extends State<CalendarTableView> {
  DateTime _focusedDay = DateTime.now();
  List<String> parcelas = [];
  Map<DateTime, Map<String, Map<String, dynamic>>> reservations = {};
  bool isLoading = true; // Estado inicial de carga
  String? selectedClient = null; // Por defecto, "Todos los clientes"
  Map<DateTime, Map<String, Map<String, dynamic>>> filteredReservations = {};

  Map<String, dynamic> selectedReservation = {};
  final ApiService apiService = ApiService(
    baseUrl: 'https://campingbenigembla.com/',
    token:
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2NhbXBpbmdiZW5pZ2VtYmxhLmNvbSIsImlhdCI6MTcyNDkyODM3MSwibmJmIjoxNzI0OTI4MzcxLCJleHAiOjQ4Nzg1MjgzNzEsImRhdGEiOnsidXNlciI6eyJpZCI6IjEifX19.Dw-aOaSG_ZL9ccXpHrqRWRhUfrNUwP8zg4JAzPkILUU',
  );

  @override
  void initState() {
    super.initState();
    selectedClient = null; // Inicializa en "Todos los clientes"
    _loadBaseParcels();
    _fetchReservations();
  }

  void _loadBaseParcels() {
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
    setState(() {
      parcelas = baseParcelsDefault.map((e) => e['parcel']!).toList();
    });
  }

  Future<void> _fetchReservations() async {
  setState(() {
    isLoading = true; // Mostrar el loader
  });

  try {
    final data = await apiService.fetchReservations();
    Map<DateTime, Map<String, Map<String, dynamic>>> processedReservations = {};

    for (var reservation in data) {
      final meta = reservation['meta'];
      String? entryDateStr = meta['entryDate'];
      String? exitDateStr = meta['exitDate'];
      String? parcel = meta['parcela'];
      String? clientName = meta['name'];
      int? id= reservation['id'];

      if (entryDateStr != null && exitDateStr != null && parcel != null) {
        DateTime entryDate = DateTime.parse(entryDateStr);
        DateTime exitDate = DateTime.parse(exitDateStr);

        for (var date = entryDate;
            !date.isAfter(exitDate);
            date = date.add(const Duration(days: 1))) {
          processedReservations.putIfAbsent(date, () => {});
          processedReservations[date]![parcel] = {
            'id':id,
            'name': clientName ?? '',
            'pendienteConfirmar': meta['pendienteConfirmar'] ?? 'False',
            'phone': meta['phone'] ?? '',
            'numberOfPeople': meta['numberOfPeople']?.toString() ?? '',
            'observaciones': meta['observaciones'] ?? '',
            'vehicle': meta['vehicle'] ?? '',
            'email': meta['email'] ?? '',
            'entryDate': entryDateStr,
            'exitDate': exitDateStr,
            'parcela': parcel,
          };
        }
      }
    }

    setState(() {
      reservations = processedReservations;
      filteredReservations = Map.from(reservations);
      isLoading = false; // Ocultar el loader
    });
  } catch (e) {
    debugPrint('Error al cargar reservas: $e');
    setState(() {
      isLoading = false; // Ocultar el loader en caso de error
    });
  }
}


  @override
  Widget build(BuildContext context) {
    final allProvider = Provider.of<AllProvider>(context);
    final daysInMonth = List.generate(
      DateTime(_focusedDay.year, _focusedDay.month + 1, 0).day,
      (index) => DateTime(_focusedDay.year, _focusedDay.month, index + 1),
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Botón de cambiar vista
            Tooltip(
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
                  await prefs.setInt('selectVista', allProvider.selectDesign);
                },
              ),
            ),

            // DropdownButton para seleccionar mes, año y cliente
            Row(
              children: [
                // Dropdown para seleccionar el mes
                DropdownButton<int>(
                  value: _focusedDay.month,
                  onChanged: (int? newMonth) {
                    if (newMonth != null) {
                      setState(() {
                        _focusedDay = DateTime(_focusedDay.year, newMonth, 1);
                      //  _fetchReservations();
                      });
                    }
                  },
                  items: List.generate(12, (index) {
                    final monthIndex = index + 1;
                    return DropdownMenuItem(
                      value: monthIndex,
                      child: Text(
                        _getMonthName(monthIndex),
                        style: TextStyle(fontSize: 14),
                      ),
                    );
                  }),
                ),
                SizedBox(width: 10),

                // Dropdown para seleccionar el año
                DropdownButton<int>(
                  value: _focusedDay.year,
                  onChanged: (int? newYear) {
                    if (newYear != null) {
                      setState(() {
                        _focusedDay = DateTime(newYear, _focusedDay.month, 1);
                     //   _fetchReservations();
                      });
                    }
                  },
                  items: List.generate(10, (index) {
                    final year = DateTime.now().year - 5 + index;
                    return DropdownMenuItem(
                      value: year,
                      child: Text(
                        year.toString(),
                        style: TextStyle(fontSize: 14),
                      ),
                    );
                  }),
                ),
                SizedBox(width: 10),

                // Dropdown para seleccionar cliente
                DropdownButton<String>(
                  hint: Text('Selecciona un cliente'),
                  value: selectedClient,
                  items: [
                    DropdownMenuItem<String>(
                      value: null,
                      child: Text('Todos los clientes'),
                    ),
                    ..._getUniqueClients()
                        .map<DropdownMenuItem<String>>((clientName) {
                      return DropdownMenuItem<String>(
                        value: clientName,
                        child: Text(clientName, style: TextStyle(fontSize: 14)),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedClient = value;
                      _filterReservationsByClient();
                    });
                  },
                ),
              ],
            ),

            // Iconos de navegación para cambiar el mes
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => setState(() {
                    _focusedDay = DateTime(_focusedDay.year,
                        _focusedDay.month - 1, _focusedDay.day);
                  //  _fetchReservations();
                  }),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () => setState(() {
                    _focusedDay = DateTime(_focusedDay.year,
                        _focusedDay.month + 1, _focusedDay.day);
                  //  _fetchReservations();
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Loader mientras carga
          : LayoutBuilder(
              builder: (context, constraints) {
                double totalWidth = constraints.maxWidth;
                double totalHeight = constraints.maxHeight;

                // Calcular tamaño de las celdas
                double cellWidth = totalWidth / (daysInMonth.length + 1);
                double cellHeight = totalHeight / (parcelas.length + 2);

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      // Fila de encabezado fija
                      _buildHeaderRow(
                        daysInMonth,
                        cellWidth,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: parcelas.map((parcela) {
                              return _buildRow(
                                parcela,
                                daysInMonth,
                                cellWidth,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildHeaderRow(List<DateTime> daysInMonth, double cellWidth) {
    return Container(
      color: Colors.blueGrey[100],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Celda de "Parcelas"
          Container(
            width: cellWidth - 4, // Compensar el margen
            height: 50,
            margin: EdgeInsets.all(2.0), // Espacio uniforme
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.blueGrey[200],
              border: Border.all(color: Colors.black12),
            ),
            child: Text(
              'Parcelas',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          // Encabezado de días
          ...daysInMonth.map((day) {
            bool isWeekend = day.weekday == DateTime.saturday ||
                day.weekday == DateTime.sunday;
            return Container(
              width: cellWidth - 4,
              height: 50,
              margin: EdgeInsets.all(2.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isWeekend ? Colors.orangeAccent : Colors.blueGrey[100],
                border: Border.all(color: Colors.black12),
              ),
              child: Text(
                '${day.day}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isWeekend ? Colors.white : Colors.black,
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildRow(
      String parcela, List<DateTime> daysInMonth, double cellWidth) {
    return Row(
      children: [
        // Columna "Parcelas"
        Container(
          width: cellWidth - 4,
          height: 50,
          margin: EdgeInsets.all(2.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blueGrey[50],
            border: Border.all(color: Colors.black12),
          ),
          child: Text(
            parcela,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        // Celdas de datos
        ...daysInMonth.map((day) {
          final reservationMeta = reservations[day]?[parcela] ?? {};
          final clientName =
              filteredReservations[day]?[parcela]?['name'] as String? ?? '';

          //
          final pendienteConfirmar =
              reservationMeta['pendienteConfirmar'] as String? ?? 'False';

          final isReserved = clientName.isNotEmpty;

          return InkWell(
            onTap: () => _showReservationDialog(parcela, day),
            child: Container(
              width: cellWidth - 4,
              height: 50,
              margin: EdgeInsets.all(2.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isReserved
                    ? (pendienteConfirmar == 'True'
                        ? Colors.blueAccent[
                            100] // Azul si pendienteConfirmar es 'True'
                        : Colors.redAccent[
                            100]) // Rojo si pendienteConfirmar es 'False'
                    : const Color.fromARGB(
                        255, 138, 170, 102), // Verde si no está reservado
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Text(
                isReserved ? clientName : '',
                style: TextStyle(
                  color: isReserved ? Colors.white : Colors.grey[800],
                  fontSize: 10,
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  void _showReservationDialog(String parcela, DateTime day) {
    final reservationMeta = reservations[day]?[parcela] ?? {};

    // Inicializar los controladores con los datos de la reserva
    Constant.parcelaController.text = reservationMeta['parcel'] ?? parcela;
    Constant.formId=reservationMeta['id'];
    Constant.clienteController.text = reservationMeta['name'] ?? '';
    Constant.telefonoController.text = reservationMeta['phone'] ?? '';
    Constant.numPersonasController.text =
        reservationMeta['numberOfPeople']?.toString() ?? '';
    Constant.observacionesCnotroller.text =
        reservationMeta['observaciones'] ?? '';
    Constant.vehiculoController.text = reservationMeta['vehicle'] ?? '';
    Constant.correoController.text = reservationMeta['email'] ?? '';
    Constant.inicioController.text =
        reservationMeta['entryDate'] ?? day.toIso8601String().split('T')[0];
    Constant.finalizacionController.text =
        reservationMeta['exitDate'] ?? day.toIso8601String().split('T')[0];
    Constant.pendienteDeConfirmar.text =
        reservationMeta['pendienteConfirmar'] ?? 'False';

    // Determinar si es una acción de Guardar o Actualizar
    Constant.checkStatus =
        reservationMeta['name'] == null || reservationMeta['name'].isEmpty ||  reservationMeta['name']==""
            ? 'Guardar'
            : 'Actualizar';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: ReservationForm(
                reservation: reservationMeta,
                apiService: apiService,
                reservations: reservations.values.toList(),
                onFormSubmit: () {
                  _fetchReservations(); // Recargar los datos después de la edición
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _filterReservationsByClient() {
    if (selectedClient == null) {
      // Si no hay cliente seleccionado, mostrar todas las reservas
      filteredReservations = Map.from(reservations);
    } else {
      // Filtrar las reservas que coincidan con el cliente seleccionado
      filteredReservations = {};
      reservations.forEach((date, parcels) {
        final filteredParcels = Map.fromEntries(
          parcels.entries
              .where((entry) => entry.value['name'] == selectedClient),
        );

        if (filteredParcels.isNotEmpty) {
          filteredReservations[date] = filteredParcels;
        }
      });
    }
    setState(() {});
  }

  List<String> _getUniqueClients() {
    final Set<String> clientNames = {};

    reservations.forEach((date, parcels) {
      parcels.forEach((parcel, meta) {
        if (meta['name'] != null && meta['name'].toString().trim().isNotEmpty) {
          clientNames.add(meta['name'].toString().trim());
        }
      });
    });

    final sortedClientNames = clientNames.toList()..sort();
    return sortedClientNames;
  }

  String _getMonthName(int month) {
    const monthNames = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];
    return monthNames[month - 1];
  }
}
