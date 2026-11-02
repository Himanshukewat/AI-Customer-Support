import 'package:flutter/material.dart';

class AgentManagementScreen extends StatelessWidget {
  const AgentManagementScreen({super.key});

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
                'Agent Management',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: navy,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Manage support agents, availability and workload.',
                style: TextStyle(color: Colors.blueGrey),
              ),
              const SizedBox(height: 24),

              // Summary cards
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth > 700 ? 3 : 1;
                  final cardWidth =
                      (constraints.maxWidth - (columns - 1) * 12) / columns;

                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      SizedBox(
                        width: cardWidth,
                        child: _SummaryCard(
                          title: 'Total Agents',
                          value: '—',
                          icon: Icons.people_outline,
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _SummaryCard(
                          title: 'Available Agents',
                          value: '—',
                          icon: Icons.person_outline,
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _SummaryCard(
                          title: 'Unavailable Agents',
                          value: '—',
                          icon: Icons.person_off_outlined,
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 28),

              // Agent list
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'All Agents',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: navy,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Agent records will appear here after backend integration.',
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 48,
                            color: Colors.blueGrey.shade200,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No agent data available',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: navy,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Connect the backend to view and manage agents.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.blueGrey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _SummaryCard({
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
          Icon(icon, size: 28, color: AgentManagementScreen.navy),
          const SizedBox(width: 14),
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
                    color: AgentManagementScreen.navy,
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
