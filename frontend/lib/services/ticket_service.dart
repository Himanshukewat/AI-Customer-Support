
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ticket.dart';

class TicketService {
  static const String baseUrl = 'http://localhost:8080';

  Future<List<Ticket>> getAllTickets() async {
    final url = Uri.parse('$baseUrl/tickets');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map((json) => Ticket.fromJson(json))
          .toList();
    }

    throw Exception(
      'Failed to load tickets: ${response.statusCode}',
    );
  }

  
  Future<Ticket> resolveTicket(int id, String resolution) async {
    final url = Uri.parse('$baseUrl/tickets/$id/resolve')
        .replace(
      queryParameters: {
        'resolution': resolution,
      },
    );

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return Ticket.fromJson(jsonDecode(response.body));
    }

    throw Exception(
      'Failed to resolve ticket: ${response.statusCode} - ${response.body}',
    );
  }

  Future<Ticket> assignTicket(int id, String assignedTo) async {
    final uri = Uri.parse(
      '$baseUrl/tickets/$id/assign',
    ).replace(
      queryParameters: {
        'assignedTo': assignedTo,
      },
    );
    final response = await http.put(uri);
    if (response.statusCode == 200) {
      return Ticket.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw Exception(
        'Failed to assign ticket: ${response.statusCode} - ${response.body}',
      );
    }
  }

}
