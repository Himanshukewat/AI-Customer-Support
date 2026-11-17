import 'dart:convert';
import '../models/ticket.dart';
import 'api_client.dart';

class TicketService {
  final ApiClient _apiClient = ApiClient();

  Future<List<Ticket>> getAllTickets() async {
    final response = await _apiClient.get('/tickets');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map((json) => Ticket.fromJson(json))
          .toList();
    }

    throw Exception(
      'Failed to load tickets: '
      '${response.statusCode} - ${response.body}',
    );
  }  

  
  Future<Ticket> resolveTicket(int id, String resolution) async {
    
    final response = await _apiClient.put(
      '/tickets/$id/resolve',
      queryParameters: {
        'resolution': resolution,
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
   
    final response = await _apiClient.put(
      '/tickets/$id/assign',
      queryParameters: {
        'assignedTo': assignedTo,
      },
    );
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
