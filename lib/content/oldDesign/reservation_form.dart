import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constant/constant.dart';
import '../../data/apiService.dart';
import 'package:table_calendar/table_calendar.dart';

class ReservationForm extends StatefulWidget {
  final Map<String, dynamic> reservation;
  final ApiService apiService;
  final VoidCallback onFormSubmit;
  List<dynamic> reservations;

  ReservationForm({
    required this.reservation,
    required this.apiService,
    required this.onFormSubmit,
    required this.reservations,
  });

  @override
  _ReservationFormState createState() => _ReservationFormState();
}

class _ReservationFormState extends State<ReservationForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    /*    Constant.parcelaController.dispose();
    Constant.clienteController.dispose();
    Constant.telefonoController.dispose();
    Constant.numPersonasController.dispose();
    Constant.observacionesCnotroller.dispose();
    Constant.vehiculoController.dispose();
    Constant.correoController.dispose();
    Constant.inicioController.dispose();
    Constant.finalizacionController.dispose();
    Constant.pendienteDeConfirmar.dispose(); */
    super.dispose();
  }

  void eliminarReserva() {
    int id =
        widget.reservation['id'] ?? Constant.formId; // Usar el id para eliminar
    widget.apiService.eliminarReserva(id.toString()).then((success) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Reserva eliminada con éxito')));
        widget.onFormSubmit();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al eliminar la reserva')));
      }
    });
  }

  void guardarReserva() {
    // Validar campos importantes antes de continuar
    String parcela = Constant.parcelaController.text.isNotEmpty
        ? Constant.parcelaController.text
        : '';
    String cliente = Constant.clienteController.text.isNotEmpty
        ? Constant.clienteController.text
        : '';
    String telefono = Constant.telefonoController.text;
    int numPersonas = int.tryParse(Constant.numPersonasController.text) ?? 0;
    String vehiculo = Constant.vehiculoController.text;
    String correo = Constant.correoController.text;
    String inicio = Constant.inicioController.text;
    String finalizacion = Constant.finalizacionController.text;
    String observaciones = Constant.observacionesCnotroller.text.isNotEmpty
        ? Constant.observacionesCnotroller.text
        : '';
    String pendienteConfirmar = Constant.pendienteDeConfirmar.text.isNotEmpty
        ? Constant.pendienteDeConfirmar.text
        : 'False';

    // Validaciones
    if (cliente.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('El nombre del cliente es obligatorio.')));
      return; // Salir si el campo es inválido
    }

    if (numPersonas <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('El número de personas debe ser mayor que 0.')));
      return;
    }

    if (inicio.isEmpty || finalizacion.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Las fechas de inicio y finalización son obligatorias.')));
      return;
    }

    DateTime fechaInicio;
    DateTime fechaFinalizacion;

    try {
      fechaInicio = DateTime.parse(inicio);
      fechaFinalizacion = DateTime.parse(finalizacion);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'El formato de la fecha es incorrecto. Utilice YYYY-MM-DD.')));
      return;
    }

    if (fechaInicio.isAfter(fechaFinalizacion)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'La fecha de inicio no puede ser posterior a la fecha de finalización.')));
      return;
    }

// Validar si alguna fecha en el rango está ocupada
// Validar si alguna fecha en el rango está ocupada
    Set<DateTime> reservedDatesForParcel = getReservedDatesForParcel(parcela);
    for (DateTime fecha = fechaInicio;
        !fecha.isAfter(fechaFinalizacion);
        fecha = fecha.add(Duration(days: 1))) {
      // Verificar si la fecha está reservada
      if (reservedDatesForParcel.contains(fecha)) {
        // Comprobar si el cliente que ocupa esa fecha es el mismo cliente actual
        bool isSameClient = widget.reservations.any((reservation) {
          // Si 'meta' existe, úsalo. Si no, usa el mapa directamente
          var meta = reservation['meta'] ?? reservation;

          String? entryDateStr = meta['entryDate'];
          String? exitDateStr = meta['exitDate'];
          String? parcel = meta['parcela'] ?? reservation['parcela'];
          String? clientName = meta['name'];

          // Verificar que las fechas sean válidas y la parcela coincida
          if (entryDateStr != null &&
              exitDateStr != null &&
              parcel == parcela) {
            DateTime entryDate = DateTime.parse(entryDateStr).toLocal();
            DateTime exitDate = DateTime.parse(exitDateStr).toLocal();

            // Verificar si la fecha actual cae dentro del rango de esta reserva
            if (!fecha.isBefore(entryDate) && !fecha.isAfter(exitDate)) {
              // Comprobar si el cliente actual es el mismo que tiene esta reserva
              return clientName == cliente;
            }
          }
          return false;
        });

        if (!isSameClient) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  'No se puede realizar la reserva. Hay días ocupados en el rango seleccionado.')));
          return;
        }
      }
    }

    // Si llega aquí, significa que todas las fechas están libres o pertenecen al mismo cliente
    // Proceder con la reserva o ajuste del rango
    debugPrint("Reserva válida para el cliente seleccionado.");

    // Si todas las validaciones son correctas, proceder a guardar o actualizar la reserva
    final reservationData = {
      "title": cliente,
      "content": "Reserva de $cliente",
      "meta": {
        "parcela": parcela,
        "name": cliente,
        "numberOfPeople": numPersonas,
        "vehicle": vehiculo,
        "entryDate": inicio,
        "exitDate": finalizacion,
        "phone": telefono,
        "email": correo,
        "observaciones": observaciones,
        "pendienteConfirmar": pendienteConfirmar
      }
    };

    if (Constant.checkStatus == 'Guardar') {
      widget.apiService.guardarReserva(reservationData).then((success) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Reserva guardada con éxito')));
          widget.onFormSubmit();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error al guardar la reserva')));
        }
      });
    } else {
      reservationData['id'] = widget.reservation['id']
          .toString(); // Asegurarse de que el ID sea un string
      widget.apiService.actualizarReserva(reservationData).then((success) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Reserva actualizada con éxito')));
          widget.onFormSubmit();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error al actualizar la reserva')));
        }
      });
    }
  }

  Widget campoTexto(
      String label, TextEditingController controller, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.01,
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
            width: MediaQuery.of(context).size.width * 0.12,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.01,
                  color: Colors.grey,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ),
      ],
    );
  }

  void _selectDateWithCalendar(
      BuildContext context, TextEditingController controller, String parcelId) {
    // Obtener las fechas reservadas para la parcela específica
    Set<DateTime> reservedDatesForParcel = getReservedDatesForParcel(parcelId);
    DateTime focusedDay = DateTime.now();
    DateTime? selectedDay;

    if (controller.text.isNotEmpty) {
      try {
        focusedDay = DateTime.parse(controller.text);
        selectedDay = focusedDay;
      } catch (e) {
        // Si hay un error al parsear la fecha, usamos el día actual
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 500, // Ajusta el ancho según tus necesidades
                  child: TableCalendar(
                    firstDay: DateTime.utc(2000, 1, 1),
                    lastDay: DateTime.utc(2100, 12, 31),
                    focusedDay: focusedDay,
                    startingDayOfWeek:
                        StartingDayOfWeek.monday, // Comienza la semana el lunes
                    availableCalendarFormats: {
                      // Oculta el selector de semanas
                      CalendarFormat.month: 'Month',
                    },
                    selectedDayPredicate: (day) =>
                        selectedDay != null && isSameDay(selectedDay, day),
                    onDaySelected: (newSelectedDay, newFocusedDay) {
                      DateTime normalizedDate = DateTime(newSelectedDay.year,
                          newSelectedDay.month, newSelectedDay.day);

                      // Verificar si la fecha seleccionada está reservada
                      bool isDateReserved =
                          reservedDatesForParcel.contains(normalizedDate);

                      if (isDateReserved) {
                        // Comprobar si la fecha pertenece al mismo cliente
                        bool isSameClient = _isDateReservedBySameClient(
                            normalizedDate, Constant.parcelaController.text);

                        if (!isSameClient) {
                          // Mostrar error si la fecha está reservada por otro cliente
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'La fecha seleccionada ya está ocupada para esta parcela.'),
                            ),
                          );
                          return;
                        }
                      }

                      // Si la fecha no está ocupada o pertenece al mismo cliente, actualizar el campo
                      setState(() {
                        controller.text =
                            normalizedDate.toIso8601String().split('T')[0];
                      });
                      Navigator.of(context).pop(); // Cerrar el diálogo
                    },

                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, date, _) {
                        DateTime normalizedDate =
                            DateTime(date.year, date.month, date.day);
                        if (reservedDatesForParcel.contains(normalizedDate)) {
                          // debugPrint("Resaltando la fecha: $normalizedDate");
                          return Container(
                            margin: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red, // Color para días ocupados
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${date.day}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }
                        return null; // Devolver null para el renderizado predeterminado
                      },
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pop(), // Botón de cerrar
                  child: Text('Cancelar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.04,
          bottom: MediaQuery.of(context).size.width * 0.04,
          left: MediaQuery.of(context).size.width * 0.12,
          right: MediaQuery.of(context).size.width * 0.12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              campoTexto('Parcela', Constant.parcelaController, context),
              campoTexto('Cliente', Constant.clienteController, context),
              campoTexto('Teléfono', Constant.telefonoController, context),
              campoTexto(
                  'Num. Personas', Constant.numPersonasController, context),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              campoTexto('Vehículo', Constant.vehiculoController, context),
              campoTexto('Correo', Constant.correoController, context),
              campoFecha('Fecha Inicio', Constant.inicioController, context),
              campoFecha(
                  ' Fecha Final', Constant.finalizacionController, context),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder<String>(
                  valueListenable: Constant.pendienteDeConfirmarNotifier,
                  builder: (context, data, child) {
                    return Checkbox(
                      value: Constant.pendienteDeConfirmar.text == 'True'
                          ? true
                          : false,
                      onChanged: (value) {
                        if (Constant.pendienteDeConfirmar.text == 'True') {
                          Constant.pendienteDeConfirmar.text = 'False';
                        } else {
                          Constant.pendienteDeConfirmar.text = 'True';
                        }
                        Constant.pendienteDeConfirmarNotifier.value =
                            Constant.pendienteDeConfirmar.text;
                      },
                    );
                  }),
              const Text(
                "Pendiente de confirmar",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          Center(
            child: campoArea(
                'Observaciones', Constant.observacionesCnotroller, context),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.reservation['title'] != '')
                ElevatedButton(
                  onPressed:
                      widget.reservation.isEmpty ? null : eliminarReserva,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text(
                    'Eliminar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: guardarReserva,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: Text(
                  Constant.checkStatus,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget campoFecha(
      String label, TextEditingController controller, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.01,
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
            width: MediaQuery.of(context).size.width * 0.12,
            child: InkWell(
              onTap: () => _selectDateWithCalendar(
                  context, controller, Constant.parcelaController.text),
              child: InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  child: Text(
                    controller.text.isNotEmpty
                        ? invertDateFormat(controller.text)
                        : '',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.01,
                        color: Colors.grey,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget campoArea(
      String label, TextEditingController controller, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.01,
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width *
                0.8, // Ajusta el tamaño según sea necesario
            child: TextField(
              controller: controller,
              maxLines: 4, // Permite múltiples líneas
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.01,
                  color: Colors.grey,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ),
      ],
    );
  }

 Set<DateTime> getReservedDatesForParcel(String parcelId) {
  Set<DateTime> reservedDates = {};

  for (var reservation in widget.reservations) {
    // Extraer el mapa 'meta' o usar directamente 'reservation'
    var meta = reservation['meta'] ?? reservation;

    try {
      final entryDateStr = meta['entryDate'];
      final exitDateStr = meta['exitDate'];
      final parcel = meta['parcela'] ?? reservation['parcela'];

      // Validar que las fechas y la parcela coincidan
      if (entryDateStr != null &&
          exitDateStr != null &&
          parcel == parcelId) {
        DateTime entryDate = _normalizeDate(entryDateStr);
        DateTime exitDate = _normalizeDate(exitDateStr);

        // Añadir fechas entre 'entryDate' y 'exitDate' al conjunto
        for (var date = entryDate;
            !date.isAfter(exitDate);
            date = date.add(const Duration(days: 1))) {
          reservedDates.add(date);
        }
      }
    } catch (e) {
      debugPrint("Error al procesar la reserva: $e");
    }
  }

  debugPrint("Fechas reservadas para la parcela $parcelId: $reservedDates");
  return reservedDates;
}

/// Método auxiliar para normalizar fechas a formato sin hora
DateTime _normalizeDate(String dateStr) {
  DateTime date = DateTime.parse(dateStr).toLocal();
  return DateTime(date.year, date.month, date.day);
}


  bool _isDateReservedBySameClient(DateTime date, String parcelId) {
    return widget.reservations.any((reservation) {
      // Acceder al 'meta' o directamente al mapa
      var meta = reservation['meta'] ?? reservation;

      String? entryDateStr = meta['entryDate'];
      String? exitDateStr = meta['exitDate'];
      String? parcel = meta['parcela'];
      String? clientName = meta['name'];

      // Verificar que las fechas, parcela y cliente sean válidos
      if (entryDateStr != null && exitDateStr != null && parcel == parcelId) {
        DateTime entryDate = DateTime.parse(entryDateStr).toLocal();
        DateTime exitDate = DateTime.parse(exitDateStr).toLocal();

        // Comparar si la fecha seleccionada está en el rango y coincide con el cliente
        return !date.isBefore(entryDate) &&
            !date.isAfter(exitDate) &&
            clientName == Constant.clienteController.text;
      }
      return false;
    });
  }

  String invertDateFormat(String date) {
    try {
      if (date.isEmpty) return '';
      // Parseamos la fecha en formato yyyy-mm-dd
      DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(date);
      // La convertimos al formato dd-mm-yyyy
      return DateFormat('dd-MM-yyyy').format(parsedDate);
    } catch (e) {
      // En caso de error, devolvemos la fecha original
      return date;
    }
  }
}
