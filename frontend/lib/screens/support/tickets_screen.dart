import 'package:flutter/material.dart';
import 'ticket_details_screen.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});
  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  String searchQuery = '';
  String selectedStatus = 'All';
  String selectedPriority = 'All';

  final List<Map<String, String>> tickets = [
    {
      'id': 'T101',
      'subject': 'Unable to reset password',
      'category': 'ACCOUNT',
      'priority': 'High',
      'status': 'Open',
      'agent': 'Ankit',
      'sentiment': 'Negative'
    },
    {
      'id': 'T102',
      'subject': 'Refund request for order',
      'category': 'PAYMENT',
      'priority': 'Medium',
      'status': 'In Progress',
      'agent': 'Hardik',
      'sentiment': 'Negative',
    },
    {
      'id': 'T103',
      'subject': 'Order delivery delayed',
      'category': 'DELIVERY',
      'priority': 'Low',
      'status': 'Open',
      'agent': 'Ravindra',
      'sentiment': 'Neutral',
    },
    {
      'id': 'T104',
      'subject': 'Payment deducted twice',
      'category': 'PAYMENT',
      'priority': 'High',
      'status': 'In Progress',
      'agent': 'Rahul',
      'sentiment': 'Negative',
    },
    {
      'id': 'T105',
      'subject': 'Account verification issue',
      'category': 'ACCOUNT',
      'priority': 'Medium',
      'status': 'Resolved',
      'agent': 'Priya',
      'sentiment': 'Negative',
    },
  ];

  List<Map<String, String>> get filteredTickets {
    return tickets.where((ticket) {
      final query = searchQuery.toLowerCase();
      final matchesSearch =
          ticket['id']!.toLowerCase().contains(query) ||
          ticket['subject']!.toLowerCase().contains(query) ||
          ticket['category']!.toLowerCase().contains(query);

      final matchesStatus = selectedStatus == 'All' ||
          ticket['status'] == selectedStatus;

      final matchesPriority = selectedPriority == 'All' ||
          ticket['priority'] == selectedPriority;

      

      return matchesSearch && matchesStatus && matchesPriority;
    }).toList();
  }


  void openTicket(Map<String, String> ticket) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TicketDetailsScreen(ticket: ticket),
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
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(
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
                // Search
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
                      borderSide: const BorderSide(
                        color: Color(0xFFE5E7EB),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFE5E7EB),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Filters
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
                DataCell(Text(ticket['id']!)),
                DataCell(
                  SizedBox(
                    width: 200,
                    child: Text(ticket['subject']!),
                  ),
                ),
                DataCell(Text(ticket['category']!)),
                DataCell(_StatusChip(value: ticket['priority']!)),
                DataCell(_StatusChip(value: ticket['status']!)),
                DataCell(Text(ticket['agent']!)),
                DataCell(_StatusChip(value: ticket['sentiment']!),),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  final Map<String, String> ticket;
  final VoidCallback onTap;

  const _TicketCard({required this.ticket, required this.onTap});

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
                '#${ticket['id']}',
                style: const TextStyle(
                  color: Color(0xFF2563EB),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              _StatusChip(value: ticket['priority']!),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            ticket['subject']!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            ticket['category']!,
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
              _StatusChip(value: ticket['sentiment']!),
            ],
          ),
          const Divider(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _StatusChip(value: ticket['status']!),
              Text(
                ticket['agent']!,
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
      'High' || 'Negative' => const Color(0xFFDC2626),
      'Medium' || 'Neutral' => const Color(0xFFD97706),
      'Low' || 'Resolved' || 'Positive' =>
        const Color(0xFF059669),
      'In Progress' => const Color(0xFF2563EB),
      _ => const Color(0xFF64748B),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
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
