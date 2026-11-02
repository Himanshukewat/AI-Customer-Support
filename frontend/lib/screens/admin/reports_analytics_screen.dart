import 'package:flutter/material.dart';

class ReportsAnalyticsScreen extends StatelessWidget {
  const ReportsAnalyticsScreen({super.key});

  static const Color navy = Color(0xFF172554);
  static const Color background = Color(0xFFF8FAFC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Reports & Analytics',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: navy,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Monitor ticket trends, team performance and AI operations.',
                style: TextStyle(color: Colors.blueGrey),
              ),
              const SizedBox(height: 24),

              // Overview
              const _SectionTitle(title: 'Ticket Overview'),
              const SizedBox(height: 14),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth > 800
                      ? 4
                      : constraints.maxWidth > 500
                          ? 2
                          : 1;
                  final width =
                      (constraints.maxWidth - (columns - 1) * 12) /
                          columns;

                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      SizedBox(
                        width: width,
                        child: const _MetricCard(
                          title: 'Total Tickets',
                          value: '—',
                          icon: Icons.confirmation_number_outlined,
                        ),
                      ),
                      SizedBox(
                        width: width,
                        child: const _MetricCard(
                          title: 'Open Tickets',
                          value: '—',
                          icon: Icons.inbox_outlined,
                        ),
                      ),
                      SizedBox(
                        width: width,
                        child: const _MetricCard(
                          title: 'In Progress',
                          value: '—',
                          icon: Icons.pending_actions_outlined,
                        ),
                      ),
                      SizedBox(
                        width: width,
                        child: const _MetricCard(
                          title: 'Resolved',
                          value: '—',
                          icon: Icons.task_alt_outlined,
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 28),

              // Ticket status
              const _SectionTitle(title: 'Ticket Status Distribution'),
              const SizedBox(height: 14),
              const _PlaceholderPanel(
                icon: Icons.pie_chart_outline,
                title: 'Status Distribution Chart',
                description:
                    'Open, In Progress and Resolved ticket distribution will appear here.',
              ),

              const SizedBox(height: 24),

              // Priority
              const _SectionTitle(title: 'Priority Distribution'),
              const SizedBox(height: 14),
              const _PlaceholderPanel(
                icon: Icons.bar_chart_outlined,
                title: 'Priority Analysis',
                description:
                    'High, Medium and Low priority ticket statistics will appear here.',
              ),

              const SizedBox(height: 24),

              // Team performance
              const _SectionTitle(title: 'Team Performance'),
              const SizedBox(height: 14),
              const _PlaceholderPanel(
                icon: Icons.groups_outlined,
                title: 'Team-wise Performance',
                description:
                    'Ticket workload and resolution performance for each support team will appear here.',
              ),

              const SizedBox(height: 24),

              // Agent performance
              const _SectionTitle(title: 'Agent Performance'),
              const SizedBox(height: 14),
              const _PlaceholderPanel(
                icon: Icons.people_outline,
                title: 'Agent-wise Performance',
                description:
                    'Assigned tickets, resolved tickets and agent workload will appear here.',
              ),

              const SizedBox(height: 24),

              // AI performance
              const _SectionTitle(title: 'AI Performance'),
              const SizedBox(height: 14),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth > 600 ? 2 : 1;
                  final width =
                      (constraints.maxWidth - (columns - 1) * 12) /
                          columns;

                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      SizedBox(
                        width: width,
                        child: const _MetricCard(
                          title: 'AI Processed Tickets',
                          value: '—',
                          icon: Icons.psychology_outlined,
                        ),
                      ),
                      SizedBox(
                        width: width,
                        child: const _MetricCard(
                          title: 'Human Review Required',
                          value: '—',
                          icon: Icons.support_agent_outlined,
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 14),
              const _PlaceholderPanel(
                icon: Icons.insights_outlined,
                title: 'AI Classification Insights',
                description:
                    'AI confidence, classification accuracy and failure statistics will appear here.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: ReportsAnalyticsScreen.navy,
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 28,
            color: ReportsAnalyticsScreen.navy,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.blueGrey),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: ReportsAnalyticsScreen.navy,
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

class _PlaceholderPanel extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _PlaceholderPanel({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 38,
            color: Colors.blueGrey.shade300,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: ReportsAnalyticsScreen.navy,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.blueGrey,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
