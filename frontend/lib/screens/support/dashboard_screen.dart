import 'package:flutter/material.dart';
import '../../models/ticket.dart';
import '../../services/ticket_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  static const Color navy = Color(0xFF172554);
  static const Color blue = Color(0xFF2563EB);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<Ticket>> _ticketsFuture;

  @override
  void initState() {
    super.initState();
    _ticketsFuture = _loadTickets();
  }

  Future<List<Ticket>> _loadTickets() {
    return TicketService().getAllTickets();
  }

  Future<void> _refreshTickets() async {
    final future = _loadTickets();
    setState(() {
      _ticketsFuture = future;
    });
    try {
      await future;
    } catch (_) {
      // FutureBuilder will display the error.
    }
  }

  String _normalizeStatus(String? status) {
    final value = status?.trim().toUpperCase() ?? '';

    if (value == 'IN_PROCESS' ||
        value == 'IN_PROGRESS' ||
        value == 'IN PROGRESS') {
      return 'IN_PROGRESS';
    }
    return value;
  }

  bool _isHighPriority(String? priority) {
    return priority?.trim().toUpperCase() == 'HIGH';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Ticket>>(
      future: _ticketsFuture,
      builder: (context, snapshot) {
        return RefreshIndicator(
          onRefresh: _refreshTickets,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Support Team / Overview',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Dashboard',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: DashboardScreen.navy,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _refreshTickets,
                      tooltip: 'Refresh Dashboard',
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Monitor tickets and support operations.',
                  style: TextStyle(color: Colors.blueGrey),
                ),
                const SizedBox(height: 24),

                if (snapshot.connectionState ==
                    ConnectionState.waiting)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (snapshot.hasError)
                  _buildError()
                else if (snapshot.hasData)
                  _buildDashboard(snapshot.data!)
                else
                  const Center(
                    child: Text('No ticket data available.'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDashboard(List<Ticket> tickets) {
    final openCount = tickets
        .where((ticket) =>
            _normalizeStatus(ticket.status) == 'OPEN')
        .length;

    final inProgressCount = tickets
        .where((ticket) =>
            _normalizeStatus(ticket.status) == 'IN_PROGRESS')
        .length;

    final resolvedCount = tickets
        .where((ticket) =>
            _normalizeStatus(ticket.status) == 'RESOLVED')
        .length;

    final highPriorityCount = tickets
        .where((ticket) => _isHighPriority(ticket.priority))
        .length;

    // Sort by database ID descending to show recently created records.
    final recentTickets = [...tickets]
      ..sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 1000
                ? 4
                : constraints.maxWidth >= 600
                    ? 2
                    : 1;

            const spacing = 16.0;

            final cardWidth =
                (constraints.maxWidth - spacing * (columns - 1)) /
                    columns;
            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                SizedBox(
                  width: cardWidth,
                  child: _StatCard(
                    title: 'Open Tickets',
                    value: openCount.toString(),
                    icon: Icons.inbox_outlined,
                    color: DashboardScreen.blue,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _StatCard(
                    title: 'In Progress',
                    value: inProgressCount.toString(),
                    icon: Icons.pending_actions,
                    color: const Color(0xFFD97706),
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _StatCard(
                    title: 'Resolved',
                    value: resolvedCount.toString(),
                    icon: Icons.check_circle_outline,
                    color: const Color(0xFF059669),
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _StatCard(
                    title: 'High Priority',
                    value: highPriorityCount.toString(),
                    icon: Icons.priority_high,
                    color: const Color(0xFFDC2626),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 28),
        _RecentTickets(tickets: recentTickets.take(5).toList()),
      ],
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 40,
            ),
            const SizedBox(height: 12),
            const Text(
              'Failed to load dashboard data.',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please check your backend connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blueGrey),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _refreshTickets,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 14,
                  ),
                ),
              ),
              Icon(icon, color: color, size: 23),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: DashboardScreen.navy,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Live data',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentTickets extends StatelessWidget {
  final List<Ticket> tickets;

  const _RecentTickets({required this.tickets});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Tickets',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: DashboardScreen.navy,
            ),
          ),
          const SizedBox(height: 16),
          if (tickets.isEmpty)
            const Text(
              'No tickets available.',
              style: TextStyle(color: Colors.blueGrey),
            )
          else
            for (int i = 0; i < tickets.length; i++) ...[
              if (i > 0) const Divider(height: 24),

              _TicketRow(ticket: tickets[i]),
            ],
        ],
      ),
    );
  }
}

class _TicketRow extends StatelessWidget {
  final Ticket ticket;

  const _TicketRow({required this.ticket});

  @override
  Widget build(BuildContext context) {
    final ticketNumber =
        ticket.ticketId ?? 'T${ticket.id ?? '-'}';

    final description =
        ticket.description ?? 'No description available';

    final category =
        ticket.category ?? 'Uncategorized';

    final status =
        ticket.status ?? 'Unknown';

    final priority =
        ticket.priority ?? 'Unknown';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.confirmation_number_outlined,
          color: DashboardScreen.blue,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '#$ticketNumber · $description',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '$category · $status',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        _PriorityLabel(priority: priority),
      ],
    );
  }
}

class _PriorityLabel extends StatelessWidget {
  final String priority;

  const _PriorityLabel({required this.priority});

  @override
  Widget build(BuildContext context) {
    final normalized = priority.trim().toUpperCase();

    final color = switch (normalized) {
      'HIGH' => const Color(0xFFDC2626),
      'MEDIUM' => const Color(0xFFD97706),
      'LOW' => const Color(0xFF059669),
      _ => Colors.blueGrey,
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
        priority,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
