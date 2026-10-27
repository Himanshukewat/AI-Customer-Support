import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  static const Color navy = Color(0xFF172554);
  static const Color blue = Color(0xFF2563EB);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
          const Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: navy,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Monitor tickets and support operations.',
            style: TextStyle(color: Colors.blueGrey),
          ),
          const SizedBox(height: 24),
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
                    child: const _StatCard(
                      title: 'Open Tickets',
                      value: '24',
                      icon: Icons.inbox_outlined,
                      color: blue,
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: const _StatCard(
                      title: 'In Progress',
                      value: '12',
                      icon: Icons.pending_actions,
                      color: Color(0xFFD97706),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: const _StatCard(
                      title: 'Resolved',
                      value: '86',
                      icon: Icons.check_circle_outline,
                      color: Color(0xFF059669),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: const _StatCard(
                      title: 'High Priority',
                      value: '5',
                      icon: Icons.priority_high,
                      color: Color(0xFFDC2626),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 28),
          const _RecentTickets(),
        ],
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
            'Sample data',
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
  const _RecentTickets();

  static const tickets = [
    (
      id: 'T101',
      subject: 'Unable to reset password',
      category: 'ACCOUNT',
      priority: 'High',
      status: 'Open',
    ),
    (
      id: 'T102',
      subject: 'Refund request for order',
      category: 'PAYMENT',
      priority: 'Medium',
      status: 'In Progress',
    ),
    (
      id: 'T103',
      subject: 'Order delivery delayed',
      category: 'DELIVERY',
      priority: 'Low',
      status: 'Open',
    ),
  ];

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
          for (final ticket in tickets) ...[
            if (ticket != tickets.first) const Divider(height: 24),
            Row(
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
                        '#${ticket.id} · ${ticket.subject}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${ticket.category} · ${ticket.status}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _PriorityLabel(priority: ticket.priority),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _PriorityLabel extends StatelessWidget {
  final String priority;

  const _PriorityLabel({required this.priority});

  @override
  Widget build(BuildContext context) {
    final color = switch (priority) {
      'High' => const Color(0xFFDC2626),
      'Medium' => const Color(0xFFD97706),
      _ => const Color(0xFF059669),
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
