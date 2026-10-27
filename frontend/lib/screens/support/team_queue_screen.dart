import 'package:flutter/material.dart';

class TeamQueueScreen extends StatefulWidget {
  const TeamQueueScreen({super.key});

  @override
  State<TeamQueueScreen> createState() => _TeamQueueScreenState();
}

class _TeamQueueScreenState extends State<TeamQueueScreen> {
  String searchQuery = '';
  String selectedPriority = 'All';

  final List<Map<String, String>> queueTickets = [
    {
      'id': 'T201',
      'subject': 'Unable to access account',
      'category': 'ACCOUNT',
      'priority': 'High',
      'sentiment': 'Negative',
      'status': 'Unassigned',
    },
    {
      'id': 'T202',
      'subject': 'Refund not received',
      'category': 'PAYMENT',
      'priority': 'High',
      'sentiment': 'Negative',
      'status': 'Unassigned',
    },
    {
      'id': 'T203',
      'subject': 'Delivery tracking issue',
      'category': 'DELIVERY',
      'priority': 'Medium',
      'sentiment': 'Neutral',
      'status': 'Unassigned',
    },
    {
      'id': 'T204',
      'subject': 'Update registered email',
      'category': 'ACCOUNT',
      'priority': 'Low',
      'sentiment': 'Positive',
      'status': 'Unassigned',
    },
  ];

  List<Map<String, String>> get filteredTickets {
    return queueTickets.where((ticket) {
      final query = searchQuery.toLowerCase();

      final matchesSearch =
          ticket['id']!.toLowerCase().contains(query) ||
          ticket['subject']!.toLowerCase().contains(query) ||
          ticket['category']!.toLowerCase().contains(query);

      final matchesPriority = selectedPriority == 'All' ||
          ticket['priority'] == selectedPriority;

      return matchesSearch && matchesPriority;
    }).toList();
  }

  Color chipColor(String value) {
    switch (value) {
      case 'High':
      case 'Negative':
        return const Color(0xFFDC2626);
      case 'Medium':
      case 'Neutral':
        return const Color(0xFFD97706);
      case 'Low':
      case 'Positive':
        return const Color(0xFF059669);
      default:
        return const Color(0xFF64748B);
    }
  }

  Widget chip(String value) {
    final color = chipColor(value);

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

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isDesktop ? 28 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SUPPORT TEAM / QUEUE',
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Team Queue',
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
            'Review tickets waiting for team assignment.',
            style: TextStyle(color: Colors.blueGrey),
          ),
          const SizedBox(height: 24),

          // Queue summary
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _QueueStat(
                title: 'Total in Queue',
                value: '${queueTickets.length}',
                icon: Icons.inbox_outlined,
                color: const Color(0xFF2563EB),
              ),
              _QueueStat(
                title: 'High Priority',
                value: '${queueTickets.where((t) => t['priority'] == 'High').length}',
                icon: Icons.priority_high,
                color: const Color(0xFFDC2626),
              ),
              _QueueStat(
                title: 'Negative Sentiment',
                value: '${queueTickets.where((t) => t['sentiment'] == 'Negative').length}',
                icon: Icons.sentiment_dissatisfied_outlined,
                color: const Color(0xFFD97706),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Search
          TextField(
            onChanged: (value) {
              setState(() => searchQuery = value);
            },
            decoration: InputDecoration(
              hintText: 'Search ticket ID, subject or category',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFE5E7EB),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Priority filter
          Row(
            children: [
              const Text(
                'Priority:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 10),
              DropdownButton<String>(
                value: selectedPriority,
                items: const [
                  DropdownMenuItem(value: 'All', child: Text('All')),
                  DropdownMenuItem(value: 'High', child: Text('High')),
                  DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                  DropdownMenuItem(value: 'Low', child: Text('Low')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedPriority = value);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          Text(
            '${filteredTickets.length} tickets found',
            style: const TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          if (filteredTickets.isEmpty)
            const Padding(
              padding: EdgeInsets.all(28),
              child: Center(
                child: Text('No tickets match your filters.'),
              ),
            )
          else if (isDesktop)
            _buildTable()
          else
            ...filteredTickets.map(
              (ticket) => _QueueTicketCard(
                ticket: ticket,
                chip: chip,
              ),
            ),
        ],
      ),
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
            DataColumn(label: Text('Sentiment')),
            DataColumn(label: Text('Queue Status')),
          ],
          rows: filteredTickets.map((ticket) {
            return DataRow(
              cells: [
                DataCell(Text(ticket['id']!)),
                DataCell(
                  SizedBox(
                    width: 200,
                    child: Text(ticket['subject']!),
                  ),
                ),
                DataCell(Text(ticket['category']!)),
                DataCell(chip(ticket['priority']!)),
                DataCell(chip(ticket['sentiment']!)),
                DataCell(chip(ticket['status']!)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _QueueStat extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _QueueStat({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QueueTicketCard extends StatelessWidget {
  final Map<String, String> ticket;
  final Widget Function(String) chip;

  const _QueueTicketCard({
    required this.ticket,
    required this.chip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
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
              chip(ticket['priority']!),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            ticket['subject']!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
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
          const Divider(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              chip(ticket['sentiment']!),
              chip(ticket['status']!),
            ],
          ),
        ],
      ),
    );
  }
}
