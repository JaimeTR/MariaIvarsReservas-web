import 'package:flutter/material.dart';

import '../../constant/constant.dart';

class ReservationList extends StatelessWidget {
  final List<dynamic> filteredReservations;
  final void Function(Map<String, String>) onReservationTap;

  ReservationList({
    required this.filteredReservations,
    required this.onReservationTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width * 0.4,
      child: ListView.builder(
        itemCount: filteredReservations.length,
        itemBuilder: (context, index) {
          var reservation = filteredReservations[index];
          bool isReserved = reservation['name'] != '';
          bool isPending = reservation['pendienteConfirmar'] == 'True';
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Constant.parcelaController =
                        TextEditingController(text: reservation['parcel']);
                    Constant.clienteController =
                        TextEditingController(text: reservation['name']);
                    Constant.telefonoController =
                        TextEditingController(text: reservation['phone']);
                    Constant.numPersonasController =
                        TextEditingController(text: reservation['numberOfPeople']);
                    Constant.observacionesCnotroller = TextEditingController(
                        text: reservation['observaciones']);
                    Constant.vehiculoController =
                        TextEditingController(text: reservation['vehicle']);
                    Constant.correoController =
                        TextEditingController(text: reservation['email']);
                    Constant.inicioController = TextEditingController(
                        text: reservation['entryDate'] == '' ||
                                reservation['entryDate'] == null
                            ? Constant.calendarIniciotx
                            : reservation['entryDate']);
                    Constant.finalizacionController = TextEditingController(
                        text: reservation['exitDate'] == '' ||
                                reservation['exitDate'] == null
                            ? Constant.calendarIniciotx
                            : reservation['exitDate']);
                    Constant.pendienteDeConfirmar = TextEditingController(
                        text: reservation['pendienteConfirmar']);
                    if (reservation['name'] == null ||
                        reservation['name'].isEmpty ||
                        reservation['name']=="") {
                      Constant.checkStatus = 'Guardar';
                    } else {
                      Constant.checkStatus = 'Actualizar';
                    }
                    onReservationTap(reservation);
                  },
                  child: Row(
                    children: [
                      Text(
                        '${reservation['parcel']}:',
                        style: TextStyle(
                          color: isPending
                              ? Colors.orange
                              : isReserved
                                  ? Colors.red
                                  : Colors.green,
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: isPending
                                  ? "Pendiente de confirmar"
                                  : isReserved
                                      ? (reservation['phone'] == ''
                                          ? 'Reservado por ${reservation['name']}'
                                          : 'Reservado por ${reservation['name']} con número de teléfono: ${reservation['phone']}')
                                      : 'Sin reserva',
                              style: TextStyle(
                                color: isReserved ? Colors.black : Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            // Comprobación para añadir "(Salida)" si coincide la fecha
                            if (isReserved &&
                                reservation['exitDate'] ==
                                    Constant.calendarIniciotx)
                              TextSpan(
                                text: ' (Salida)', // Etiqueta "(Salida)"
                                style: TextStyle(
                                  color: Colors
                                      .redAccent, // Color marrón para "Salida"
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                color: Colors.brown.withOpacity(0.5),
                thickness: 1,
              ),
            ],
          );
        },
      ),
    );
  }
}
