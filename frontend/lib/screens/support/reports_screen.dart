import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  static const Color navy = Color(0xFF172554);
  static const Color blue = Color(0xFF2563EB);

  final List<Map<String, dynamic>> priorityData = const [
    {'label': 'High', 'count': 12, 'color': Color(0xFFDC2626)},
    {'label': 'Medium', 'count': 18, 'color': Color(0xFFD97706)},
    {'label': 'Low', 'count': 10, 'color': Color(0xFF059669)},
  ];

  final List<Map<String, dynamic>> categoryData = const [
    {'label': 'Account', 'count': 16, 'color': Color(0xFF2563EB)},
    {'label': 'Payment', 'count': 12, 'color': Color(0xFF7C3AED)},
    {'label': 'Delivery', 'count': 8, 'color': Color(0xFF0891B2)},
    {'label': 'Other', 'count': 4, 'color': Color(0xFF64748B)},
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isDesktop ? 28 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SUPPORT TEAM / REPORTS',
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Reports & Analytics',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: navy,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Monitor ticket volume, priorities and resolution performance.',
            style: TextStyle(color: Colors.blueGrey),
          ),
          const SizedBox(height: 24),

          // Summary cards
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 900
                  ? 4
                  : constraints.maxWidth >= 550
                      ? 2
                      : 1;

              final cardWidth =
                  (constraints.maxWidth - (columns - 1) * 12) / columns;

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: cardWidth,
                    child: const _ReportStatCard(
                      title: 'Total Tickets',
                      value: '40',
                      subtitle: 'All sample tickets',
                      icon: Icons.confirmation_number_outlined,
                      color: blue,
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: const _ReportStatCard(
                      title: 'Open Tickets',
                      value: '12',
                      subtitle: 'Awaiting action',
                      icon: Icons.inbox_outlined,
                      color: Color(0xFFD97706),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: const _ReportStatCard(
                      title: 'In Progress',
                      value: '10',
                      subtitle: 'Being handled',
                      icon: Icons.autorenew,
                      color: Color(0xFF7C3AED),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: const _ReportStatCard(
                      title: 'Resolved',
                      value: '18',
                      subtitle: 'Marked resolved',
                      icon: Icons.check_circle_outline,
                      color: Color(0xFF059669),
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 24),

          // Resolution performance
          _ReportPanel(
            title: 'Resolution Performance',
            icon: Icons.trending_up,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      '45%',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: navy,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        'of sample tickets resolved',
                        style: TextStyle(color: Colors.blueGrey.shade600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: const LinearProgressIndicator(
                    value: 0.45,
                    minHeight: 10,
                    backgroundColor: Color(0xFFE5E7EB),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF059669),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '18 resolved out of 40 total sample tickets.',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Priority and category breakdown
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 700;

              final priorityPanel = _ReportPanel(
                title: 'Priority Distribution',
                icon: Icons.flag_outlined,
                child: Column(
                  children: priorityData.map((item) {
                    return _BreakdownRow(
                      label: item['label'] as String,
                      count: item['count'] as int,
                      total: 40,
                      color: item['color'] as Color,
                    );
                  }).toList(),
                ),
              );

              final categoryPanel = _ReportPanel(
                title: 'Tickets by Category',
                icon: Icons.category_outlined,
                child: Column(
                  children: categoryData.map((item) {
                    return _BreakdownRow(
                      label: item['label'] as String,
                      count: item['count'] as int,
                      total: 40,
                      color: item['color'] as Color,
                    );
                  }).toList(),
                ),
              );

              if (wide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: priorityPanel),
                    const SizedBox(width: 20),
                    Expanded(child: categoryPanel),
                  ],
                );
              }

              return Column(
                children: [
                  priorityPanel,
                  const SizedBox(height: 20),
                  categoryPanel,
                ],
              );
            },
          ),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: blue),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'These reports use illustrative sample values. '
                    'They are not live backend statistics.',
                    style: TextStyle(
                      color: Color(0xFF1E40AF),
                      height: 1.5,
                    ),
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

class _ReportStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _ReportStatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
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
                    fontSize: 13,
                  ),
                ),
              ),
              Icon(icon, color: color),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172554),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.blueGrey,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportPanel extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _ReportPanel({
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
              Icon(icon, color: const Color(0xFF2563EB)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172554),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          child,
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  final String label;
  final int count;
  final int total;
  final Color color;

  const _BreakdownRow({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = total == 0 ? 0.0 : count / total;

    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                '$count tickets',
                style: const TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: percentage.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: const Color(0xFFE5E7EB),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
