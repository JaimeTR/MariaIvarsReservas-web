import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  final String token;

  ApiService({
    required this.baseUrl,
    required this.token,
  });

/*   Future<List<dynamic>> fetchReservations() async {
    final response = await http.get(
      Uri.parse('$baseUrl/wp-json/wp/v2/reservas?status=any'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar las reservas');
    }
  } */

  Future<List<dynamic>> fetchReservations() async {
    List<dynamic> allReservations = [];
    int currentPage = 1;
    const int perPage = 100; // Máximo permitido por WordPress REST API
    int totalReservations = 0;

    while (true) {
      try {
        final response = await http.get(
          Uri.parse(
              '$baseUrl/wp-json/wp/v2/reservas?status=any&per_page=$perPage&page=$currentPage'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          // Obtener el número total de reservas desde los encabezados
          if (currentPage == 1) {
            totalReservations =
                int.parse(response.headers['x-wp-total'] ?? '0');
            debugPrint('Número total de reservas: $totalReservations');
          }

          // Decodificar la respuesta
          List<dynamic> reservations = json.decode(response.body);

          // Añadir las reservas actuales a la lista completa
          allReservations.addAll(reservations);
          debugPrint(
              'Cargadas ${reservations.length} reservas de la página $currentPage');

          // Detener el bucle si se han cargado todas las reservas
          if (allReservations.length >= totalReservations) {
            debugPrint('Todas las reservas han sido cargadas.');
            // **Imprime el resultado final**
           // print('${json.encode(allReservations)} ');
            break;
          }

          // Incrementar el contador de páginas
          currentPage++;
        } else {
          // Imprimir información del error
          debugPrint('Error en la página $currentPage: ${response.statusCode}');
         // debugPrint('Cuerpo de la respuesta: ${response.body}');
          break; // Romper el bucle si hay un error
        }
      } catch (e) {
        // Capturar cualquier excepción
        debugPrint('Excepción al cargar la página $currentPage: $e');
        break; // Romper el bucle si ocurre una excepción
      }
    }

    return allReservations;
  }

  Future<bool> guardarReserva(Map<String, dynamic> reservation) async {
    final response = await http.post(
      Uri.parse('$baseUrl/wp-json/wp/v2/reservas'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(reservation),
    );

    return response.statusCode == 201;
  }

  Future<bool> actualizarReserva(Map<String, dynamic> reservation) async {
    final response = await http.post(
      Uri.parse('$baseUrl/wp-json/wp/v2/reservas/${reservation['id']}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(reservation),
    );

    return response.statusCode == 200;
  }
/* 
  Future<bool> eliminarReserva(String parcela) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/wp-json/wp/v2/reservas/$parcela'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return response.statusCode == 200;
  }
}
 */

  Future<bool> eliminarReserva(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/wp-json/wp/v2/reservas/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return response.statusCode == 200;
  }
}
