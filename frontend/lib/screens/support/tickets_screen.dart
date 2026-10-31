import 'package:flutter/material.dart';
import '../../models/ticket.dart';
import '../../services/ticket_service.dart';
import 'ticket_details_screen.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});
  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  final TicketService _ticketService = TicketService();

  List<Ticket> tickets = [];

  String searchQuery = '';
  String selectedStatus = 'All';
  String selectedPriority = 'All';

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchTickets();
  }

  Future<void> fetchTickets() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await _ticketService.getAllTickets();
      if (!mounted) return;
      setState(() {
        tickets = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  String normalizeStatus(String? status) {
    switch (status?.trim().toUpperCase()) {
      case 'OPEN':
        return 'Open';
      case 'IN_PROGRESS':
      case 'IN PROGRESS':
        return 'In Progress';
      case 'RESOLVED':
        return 'Resolved';
      default:
        return 'Unknown';
    }
  }

  String normalizePriority(String? priority) {
    switch (priority?.trim().toUpperCase()) {
      case 'HIGH':
        return 'High';
      case 'MEDIUM':
        return 'Medium';
      case 'LOW':
        return 'Low';
      default:
        return 'Unknown';
    }
  }

  List<Ticket> get filteredTickets {
    return tickets.where((ticket) {
      final query = searchQuery.toLowerCase();
      final matchesSearch =
          (ticket.ticketId ?? '').toLowerCase().contains(query) ||
          (ticket.description ?? '').toLowerCase().contains(query) ||
          (ticket.category ?? '').toLowerCase().contains(query);
      final matchesStatus = selectedStatus == 'All' ||
          normalizeStatus(ticket.status) == selectedStatus;
      final matchesPriority = selectedPriority == 'All' ||
          normalizePriority(ticket.priority) == selectedPriority;
      return matchesSearch && matchesStatus && matchesPriority;
    }).toList();
  }

  void openTicket(Ticket ticket) {
    final ticketMap = <String, String>{
      'id': ticket.ticketId ?? 'ID-${ticket.id ?? 'Unknown'}',
      'databaseId': ticket.id?.toString() ?? '',
      'subject': ticket.description ?? 'No description available',
      'category': ticket.category ?? 'Uncategorized',
      'subCategory': ticket.subCategory ?? 'Not available',
      'priority': normalizePriority(ticket.priority),
      'status': normalizeStatus(ticket.status),
      'agent': ticket.assignedTo ?? 'Unassigned',
      'sentiment': ticket.sentiment ?? 'Unknown',
      'aiConfidence': ticket.aiConfidence?.toString() ?? '',
      'aiStatus': ticket.aiStatus ?? '',
      'aiDecision': ticket.aiDecision ?? '',
      'resolution': ticket.resolution ?? '',
    };
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TicketDetailsScreen(ticket: ticketMap),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 900;
          return SingleChildScrollView(
            padding: EdgeInsets.all(isDesktop ? 28 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SUPPORT TEAM / TICKETS',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Assigned Tickets',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF172554),
                      ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Search, filter and manage support tickets.',
                  style: TextStyle(color: Colors.blueGrey),
                ),
                const SizedBox(height: 24),

                TextField(
                  onChanged: (value) {
                    setState(() => searchQuery = value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search by ticket ID, subject or category',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
               const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildFilter(
                      label: 'Status',
                      value: selectedStatus,
                      options: const [
                        'All',
                        'Open',
                        'In Progress',
                        'Resolved',
                      ],
                      onChanged: (value) {
                        setState(() => selectedStatus = value);
                      },
                    ),
                    _buildFilter(
                      label: 'Priority',
                      value: selectedPriority,
                      options: const ['All', 'High', 'Medium', 'Low'],
                      onChanged: (value) {
                        setState(() => selectedPriority = value);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (errorMessage != null)
                  _buildError()
                else ...[
                  Text(
                    '${filteredTickets.length} tickets found',
                    style: const TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (filteredTickets.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 42,
                            color: Colors.blueGrey,
                          ),
                          SizedBox(height: 12),
                          Text('No tickets match your filters.'),
                        ],
                      ),
                    )
                  else if (isDesktop)
                    _buildTable()
                  else
                    ...filteredTickets.map(
                      (ticket) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _TicketCard(
                          ticket: ticket,
                          onTap: () => openTicket(ticket),
                          normalizeStatus: normalizeStatus,
                          normalizePriority: normalizePriority,
                        ),
                      ),
                    ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildError() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, size: 40, color: Colors.red),
          const SizedBox(height: 12),
          const Text('Unable to load tickets'),
          const SizedBox(height: 8),
          Text(
            errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.blueGrey),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: fetchTickets,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilter({
    required String label,
    required String value,
    required List<String> options,
    required ValueChanged<String> onChanged,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$label: '),
        const SizedBox(width: 6),
        DropdownButton<String>(
          value: value,
          items: options
              .map(
                (option) => DropdownMenuItem(
                  value: option,
                  child: Text(option),
                ),
              )
              .toList(),
          onChanged: (newValue) {
            if (newValue != null) onChanged(newValue);
          },
        ),
      ],
    );
  }

  Widget _buildTable() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 24,
          columns: const [
            DataColumn(label: Text('Ticket')),
            DataColumn(label: Text('Subject')),
            DataColumn(label: Text('Category')),
            DataColumn(label: Text('Priority')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Assigned Agent')),
            DataColumn(label: Text('Sentiment')),
          ],
          rows: filteredTickets.map((ticket) {
            return DataRow(
              onSelectChanged: (_) => openTicket(ticket),
              cells: [
                DataCell(Text(
                  ticket.ticketId ?? 'ID-${ticket.id ?? '-'}',
                )),
                DataCell(
                  SizedBox(
                    width: 200,
                    child: Text(ticket.description ?? 'No description'),
                  ),
                ),
                DataCell(Text(ticket.category ?? 'Unknown')),
                DataCell(
                  _StatusChip(value: normalizePriority(ticket.priority)),
                ),
                DataCell(
                  _StatusChip(value: normalizeStatus(ticket.status)),
                ),
                DataCell(Text(ticket.assignedTo ?? 'Unassigned')),
                DataCell(
                  _StatusChip(value: ticket.sentiment ?? 'Unknown'),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  final Ticket ticket;
  final VoidCallback onTap;
  final String Function(String?) normalizeStatus;
  final String Function(String?) normalizePriority;

  const _TicketCard({
    required this.ticket,
    required this.onTap,
    required this.normalizeStatus,
    required this.normalizePriority,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '#${ticket.ticketId ?? ticket.id ?? 'Unknown'}',
                  style: const TextStyle(
                    color: Color(0xFF2563EB),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                _StatusChip(
                  value: normalizePriority(ticket.priority),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              ticket.description ?? 'No description available',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              ticket.category ?? 'Uncategorized',
              style: const TextStyle(
                color: Colors.blueGrey,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  'Sentiment: ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                _StatusChip(value: ticket.sentiment ?? 'Unknown'),
              ],
            ),
            const Divider(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _StatusChip(value: normalizeStatus(ticket.status)),
                Text(
                  ticket.assignedTo ?? 'Unassigned',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String value;

  const _StatusChip({required this.value});

  @override
  Widget build(BuildContext context) {
    final color = switch (value) {
      'High' || 'Negative' || 'Strong Negative' =>
        const Color(0xFFDC2626),
      'Medium' || 'Neutral' =>
        const Color(0xFFD97706),
      'Low' || 'Resolved' || 'Positive' =>
        const Color(0xFF059669),
      'In Progress' =>
        const Color(0xFF2563EB),
      _ => const Color(0xFF64748B),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        value,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
