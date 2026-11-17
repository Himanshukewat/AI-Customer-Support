import 'package:flutter/material.dart';
import '../admin/all_ticket_screen.dart';
import '../admin/agent_management_screen.dart';
import '../admin/team_management_screen.dart';
import '../admin/reports_analytics_screen.dart';
import 'dart:convert';
import '../../services/api_client.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  static const Color navy = Color(0xFF172554);
  static const Color blue = Color(0xFF2563EB);

  @override
  State<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final ApiClient _apiClient = ApiClient();

  bool _isLoading = true;
  String? _error;

  int totalTickets = 0;
  int openTickets = 0;
  int inProgressTickets = 0;
  int resolvedTickets = 0;
  int totalAgents = 0;
  int activeAgents = 0;

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      final responses = await Future.wait([
        _apiClient.get('/tickets'),
        _apiClient.get('/users'),
      ]);

      if (responses[0].statusCode != 200 ||
          responses[1].statusCode != 200) {
        throw Exception('Failed to load dashboard data');
      }

      final List<dynamic> tickets = jsonDecode(responses[0].body);
      final List<dynamic> agents = jsonDecode(responses[1].body);

      if (!mounted) return;

      setState(() {
        totalTickets = tickets.length;

        openTickets = tickets.where((ticket) =>
            ticket['status']?.toString().toUpperCase() == 'OPEN').length;

        inProgressTickets = tickets.where((ticket) {
          final status = ticket['status']?.toString().toUpperCase();
          return status == 'IN_PROCESS' || status == 'IN_PROGRESS';
        }).length;

        resolvedTickets = tickets.where((ticket) =>
            ticket['status']?.toString().toUpperCase() == 'RESOLVED').length;

        totalAgents = agents.length;

        activeAgents = agents.where((agent) =>
            agent['active'] == true).length;

        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void navigateToTickets(String status) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AllTicketsScreen(initialStatus: status),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              ),
            if(_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'Error: $_error',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
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
                color: AdminDashboardScreen.navy,
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
                      child:  _StatCard(
                        title: 'Total Tickets',
                        value: _isLoading ? '...' : totalTickets.toString(),
                        icon: Icons.confirmation_number_outlined,
                        color: AdminDashboardScreen.blue,
                        onTap: () => navigateToTickets('All'),
                      ),
                    ),
                    SizedBox(
                      width: width,
                      child:  _StatCard(
                        title: 'Open Tickets',
                        value: _isLoading ? '...' : openTickets.toString(),
                        icon: Icons.inbox_outlined,
                        color: Color(0xFFD97706),
                        onTap: () => navigateToTickets('Open'),
                      ),
                    ),
                    SizedBox(
                      width: width,
                      child:  _StatCard(
                        title: 'In Progress',
                        value: _isLoading ? '...' : inProgressTickets.toString(),
                        icon: Icons.pending_actions,
                        color: Color(0xFF2563EB),
                        onTap: () => navigateToTickets('In Progress'),
                      ),
                    ),
                    SizedBox(
                      width: width,
                      child:  _StatCard(
                        title: 'Resolved Tickets',
                        value: _isLoading ? '...' : resolvedTickets.toString(),
                        icon: Icons.check_circle_outline,
                        color: Color(0xFF059669),
                        onTap: () => navigateToTickets('Resolved'),
                      ),
                    ),
                    SizedBox(
                      width: width,
                      child:  _StatCard(
                        title: 'Total Agents',
                        value: _isLoading ? '...' : totalAgents.toString(),
                        icon: Icons.support_agent,
                        color: Color(0xFF7C3AED),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AgentManagementScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: width,
                      child:  _StatCard(
                        title: 'Active Teams',
                        value: '—',
                        icon: Icons.groups_outlined,
                        color: Color(0xFF0891B2),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TeamManagementScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 28),

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
  final VoidCallback? onTap;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
            'Live data',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
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
