import 'package:flutter/material.dart';

import 'dart:convert';
import '../../services/api_client.dart';

class ReportsAnalyticsScreen extends StatefulWidget {
  const ReportsAnalyticsScreen({super.key});

  static const Color navy = Color(0xFF172554);
  static const Color background = Color(0xFFF8FAFC);

  @override
  State<ReportsAnalyticsScreen> createState() =>
      _ReportsAnalyticsScreenState();
}

class _ReportsAnalyticsScreenState extends State<ReportsAnalyticsScreen> {

  final ApiClient _apiClient = ApiClient();
  bool _isLoading = true;
  String? _error;
  List<dynamic> tickets = [];

  @override
  void initState() {
    super.initState();
    fetchTickets();
  }

  Future<void> fetchTickets() async {
    try {
      final response = await _apiClient.get('/tickets');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          tickets = data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load reports';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Something went wrong: $e';
        _isLoading = false;
      });
    }
  }

  int getTicketCount(String status) {
    return tickets.where((ticket) {
      final ticketStatus =
          ticket['status']?.toString().toUpperCase() ?? '';

      if (status == 'IN_PROGRESS') {
        return ticketStatus == 'IN_PROCESS' ||
            ticketStatus == 'IN_PROGRESS';
      }

      return ticketStatus == status;
    }).length;
  }

  int getAIProcessedCount() {
    return tickets.where((ticket) =>
        ticket['aiStatus']?.toString().toUpperCase() ==
        'AI_COMPLETED').length;
  }

  int getHumanReviewCount() {
    return tickets.where((ticket) =>
        ticket['aiDecision']?.toString().toUpperCase() ==
        'HUMAN_REVIEW').length;
  }

  Map<String, int> getStatusDistribution() {
    return {
      'Open': getTicketCount('OPEN'),
      'In Progress': getTicketCount('IN_PROGRESS'),
      'Resolved': getTicketCount('RESOLVED'),
    };
  }

  Map<String, int> getPriorityDistribution() {
    return {
      'High': tickets.where((ticket) =>
          ticket['priority']?.toString().toUpperCase() == 'HIGH').length,
      'Medium': tickets.where((ticket) =>
          ticket['priority']?.toString().toUpperCase() == 'MEDIUM').length,
      'Low': tickets.where((ticket) =>
          ticket['priority']?.toString().toUpperCase() == 'LOW').length,
    };
  }

  Map<String, Map<String, int>> getTeamPerformance() {
    final Map<String, Map<String, int>> performance = {};
    for (var ticket in tickets) {
      final team = ticket['assignedTeam']?.toString();
      if (team == null || team.isEmpty) continue;
      performance.putIfAbsent(
        team,
        () => {'Assigned': 0, 'Resolved': 0},
      );

      performance[team]!['Assigned'] =
          performance[team]!['Assigned']! + 1;

      if (ticket['status']?.toString().toUpperCase() == 'RESOLVED') {
        performance[team]!['Resolved'] =
            performance[team]!['Resolved']! + 1;
      }
    }
    return performance;
  }

  Map<String, Map<String, int>> getAgentPerformance() {
    final Map<String, Map<String, int>> performance = {};

    for (var ticket in tickets) {
      final agent = ticket['assignedTo']?.toString();

      if (agent == null || agent.isEmpty) continue;

      performance.putIfAbsent(
        agent,
        () => {'Assigned': 0, 'Resolved': 0},
      );

      performance[agent]!['Assigned'] =
          performance[agent]!['Assigned']! + 1;

      if (ticket['status']?.toString().toUpperCase() == 'RESOLVED') {
        performance[agent]!['Resolved'] =
            performance[agent]!['Resolved']! + 1;
      }
    }

    return performance;
  }

  double getAverageAIConfidence() {
    final confidenceTickets = tickets.where(
      (ticket) => ticket['aiConfidence'] != null,
    );

    if (confidenceTickets.isEmpty) return 0;

    final total = confidenceTickets.fold<double>(
      0,
      (sum, ticket) =>
          sum + (ticket['aiConfidence'] as num).toDouble(),
    );

    return total / confidenceTickets.length;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Text(_error!),
        ),
      );
    }
    return Scaffold(
      backgroundColor: ReportsAnalyticsScreen.background,
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
                  color: ReportsAnalyticsScreen.navy,
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
                        child:  _MetricCard(
                          title: 'Total Tickets',
                          value: tickets.length.toString(),
                          icon: Icons.confirmation_number_outlined,
                        ),
                      ),
                      SizedBox(
                        width: width,
                        child:  _MetricCard(
                          title: 'Open Tickets',
                          value: getTicketCount('OPEN').toString(),
                          icon: Icons.inbox_outlined,
                        ),
                      ),
                      SizedBox(
                        width: width,
                        child:  _MetricCard(
                          title: 'In Progress',
                          value: getTicketCount('IN_PROGRESS').toString(),
                          icon: Icons.pending_actions_outlined,
                        ),
                      ),
                      SizedBox(
                        width: width,
                        child:  _MetricCard(
                          title: 'Resolved',
                          value: getTicketCount('RESOLVED').toString(),
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
              _StatusDistributionPanel(
                distribution: getStatusDistribution(),
              ),
              

              const SizedBox(height: 24),

              // Priority
              const _SectionTitle(title: 'Priority Distribution'),
              const SizedBox(height: 14),
              _PriorityDistributionPanel(
                distribution: getPriorityDistribution(),
              ),

              const SizedBox(height: 24),

              // Team performance
              const _SectionTitle(title: 'Team Performance'),
              const SizedBox(height: 14),
              _TeamPerformancePanel(
                performance: getTeamPerformance(),
              ),

              const SizedBox(height: 24),
              // Agent performance
              const _SectionTitle(title: 'Agent Performance'),
              const SizedBox(height: 14),
              _AgentPerformancePanel(
                performance: getAgentPerformance(),
              ),

              const SizedBox(height: 24),

              // AI performance
              _AverageConfidencePanel(
                confidence: getAverageAIConfidence(),
              ),
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
                        child:  _MetricCard(
                          title: 'AI Processed Tickets',
                          value: getAIProcessedCount().toString(),
                          icon: Icons.psychology_outlined,
                        ),
                      ),
                      SizedBox(
                        width: width,
                        child:  _MetricCard(
                          title: 'Human Review Required',
                          value: getHumanReviewCount().toString(),
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



class _StatusDistributionPanel extends StatelessWidget {
  final Map<String, int> distribution;

  const _StatusDistributionPanel({
    required this.distribution,
  });

  @override
  Widget build(BuildContext context) {
    final total = distribution.values.fold<int>(
      0,
      (sum, value) => sum + value,
    );

    final colors = {
      'Open': Colors.orange,
      'In Progress': Colors.blue,
      'Resolved': Colors.green,
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: distribution.entries.map((entry) {
          final percentage =
              total == 0 ? 0.0 : entry.value / total;

          return Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${entry.value} (${(percentage * 100).toStringAsFixed(1)}%)',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: percentage,
                  minHeight: 9,
                  backgroundColor: const Color(0xFFE2E8F0),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colors[entry.key]!,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}


class _PriorityDistributionPanel extends StatelessWidget {
  final Map<String, int> distribution;

  const _PriorityDistributionPanel({
    required this.distribution,
  });

  @override
  Widget build(BuildContext context) {
    final total = distribution.values.fold<int>(
      0,
      (sum, value) => sum + value,
    );

    final colors = {
      'High': Colors.red,
      'Medium': Colors.orange,
      'Low': Colors.green,
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: distribution.entries.map((entry) {
          final percentage =
              total == 0 ? 0.0 : entry.value / total;

          return Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${entry.value} (${(percentage * 100).toStringAsFixed(1)}%)',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: percentage,
                  minHeight: 9,
                  backgroundColor: const Color(0xFFE2E8F0),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colors[entry.key]!,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}


class _TeamPerformancePanel extends StatelessWidget {
  final Map<String, Map<String, int>> performance;

  const _TeamPerformancePanel({
    required this.performance,
  });

  @override
  Widget build(BuildContext context) {
    if (performance.isEmpty) {
      return const _PlaceholderPanel(
        icon: Icons.groups_outlined,
        title: 'No Team Data',
        description: 'No tickets are currently assigned to a team.',
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: performance.entries.map((entry) {
          final assigned = entry.value['Assigned'] ?? 0;
          final resolved = entry.value['Resolved'] ?? 0;

          return Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Assigned: $assigned'),
                    Text('Resolved: $resolved'),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: assigned == 0 ? 0 : resolved / assigned,
                  minHeight: 9,
                  backgroundColor: const Color(0xFFE2E8F0),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Colors.green,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}


class _AgentPerformancePanel extends StatelessWidget {
  final Map<String, Map<String, int>> performance;

  const _AgentPerformancePanel({
    required this.performance,
  });

  @override
  Widget build(BuildContext context) {
    if (performance.isEmpty) {
      return const _PlaceholderPanel(
        icon: Icons.people_outline,
        title: 'No Agent Data',
        description: 'No tickets are currently assigned to an agent.',
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: performance.entries.map((entry) {
          final assigned = entry.value['Assigned'] ?? 0;
          final resolved = entry.value['Resolved'] ?? 0;

          final rate = assigned == 0
              ? 0.0
              : (resolved / assigned) * 100;

          return Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Assigned: $assigned'),
                    Text('Resolved: $resolved'),
                    Text('${rate.toStringAsFixed(1)}%'),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: rate / 100,
                  minHeight: 9,
                  backgroundColor: const Color(0xFFE2E8F0),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Colors.green,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}


class _AverageConfidencePanel extends StatelessWidget {
  final double confidence;

  const _AverageConfidencePanel({
    required this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = confidence * 100;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Average AI Confidence',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${percentage.toStringAsFixed(1)}%',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: ReportsAnalyticsScreen.navy,
            ),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: confidence.clamp(0.0, 1.0),
            minHeight: 9,
            backgroundColor: const Color(0xFFE2E8F0),
            valueColor: const AlwaysStoppedAnimation<Color>(
              Colors.blue,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Average confidence score of tickets processed by AI.',
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}