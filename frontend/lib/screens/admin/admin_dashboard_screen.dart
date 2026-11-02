import 'package:flutter/material.dart';
import '../admin/all_ticket_screen.dart';
import '../admin/agent_management_screen.dart';
import '../admin/team_management_screen.dart';
import '../admin/reports_analytics_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  static const Color navy = Color(0xFF172554);
  static const Color blue = Color(0xFF2563EB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ADMIN WORKSPACE / OVERVIEW',
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Admin Dashboard',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: navy,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Monitor support operations, agents and teams.',
              style: TextStyle(color: Colors.blueGrey),
            ),
            const SizedBox(height: 28),

            // Overview statistics
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 1000
                    ? 3
                    : constraints.maxWidth >= 600
                        ? 2
                        : 1;

                const spacing = 16.0;
                final width = (constraints.maxWidth -
                        spacing * (columns - 1)) /
                    columns;

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    SizedBox(
                      width: width,
                      child: const _StatCard(
                        title: 'Total Tickets',
                        value: '—',
                        icon: Icons.confirmation_number_outlined,
                        color: blue,
                      ),
                    ),
                    SizedBox(
                      width: width,
                      child: const _StatCard(
                        title: 'Open Tickets',
                        value: '—',
                        icon: Icons.inbox_outlined,
                        color: Color(0xFFD97706),
                      ),
                    ),
                    SizedBox(
                      width: width,
                      child: const _StatCard(
                        title: 'In Progress',
                        value: '—',
                        icon: Icons.pending_actions,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    SizedBox(
                      width: width,
                      child: const _StatCard(
                        title: 'Resolved Tickets',
                        value: '—',
                        icon: Icons.check_circle_outline,
                        color: Color(0xFF059669),
                      ),
                    ),
                    SizedBox(
                      width: width,
                      child: const _StatCard(
                        title: 'Total Agents',
                        value: '—',
                        icon: Icons.support_agent,
                        color: Color(0xFF7C3AED),
                      ),
                    ),
                    SizedBox(
                      width: width,
                      child: const _StatCard(
                        title: 'Active Teams',
                        value: '—',
                        icon: Icons.groups_outlined,
                        color: Color(0xFF0891B2),
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 28),

            // Team overview
            _SectionCard(
              title: 'Team Overview',
              icon: Icons.groups_outlined,
              child: const Column(
                children: [
                  _InfoRow(
                    title: 'Account Support',
                    subtitle: 'Team workload will appear here',
                  ),
                  Divider(),
                  _InfoRow(
                    title: 'Technical Support',
                    subtitle: 'Team workload will appear here',
                  ),
                  Divider(),
                  _InfoRow(
                    title: 'General Support',
                    subtitle: 'Team workload will appear here',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Recent tickets
            _SectionCard(
              title: 'Recent Tickets',
              icon: Icons.history,
              child: const Text(
                'Recent ticket activity will appear here.',
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),

            const SizedBox(height: 20),

            // Quick actions
            _SectionCard(
              title: 'Quick Actions',
              icon: Icons.flash_on_outlined,
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _ActionButton(
                    icon: Icons.confirmation_number_outlined,
                    label: 'All Tickets',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AllTicketsScreen(),
                        ),
                      );
                    },
                  ),
                  _ActionButton(
                    icon: Icons.people_outline,
                    label: 'Manage Agents',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AgentManagementScreen(),
                        ),
                      );
                    },
                  ),
                  _ActionButton(
                    icon: Icons.groups_outlined,
                    label: 'Manage Teams',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TeamManagementScreen(),
                        ),
                      );
                    },
                  ),
                  _ActionButton(
                  icon: Icons.analytics_outlined,
                  label: 'View Reports',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ReportsAnalyticsScreen(),
                      ),
                    );
                  },
                ),
                ],
              ),
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
              color: AdminDashboardScreen.navy,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Awaiting integration',
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

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

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
          Row(
            children: [
              Icon(icon, color: AdminDashboardScreen.blue),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AdminDashboardScreen.navy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String subtitle;

  const _InfoRow({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(
            Icons.groups,
            color: AdminDashboardScreen.blue,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.blueGrey,
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

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: AdminDashboardScreen.blue,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
