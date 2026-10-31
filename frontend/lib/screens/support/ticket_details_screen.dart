import 'package:flutter/material.dart';
import '../../services/ticket_service.dart';

class TicketDetailsScreen extends StatefulWidget {
  final Map<String, String> ticket;

  const TicketDetailsScreen({
    super.key,
    required this.ticket,
  });

  @override
  State<TicketDetailsScreen> createState() =>
      _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  late String currentStatus;
  late String currentPriority;
  late String currentAssignedTo;

  final TextEditingController resolutionController =
      TextEditingController();


  final TicketService _ticketService = TicketService();

  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.ticket['status'] ?? 'Unknown';
    currentPriority = widget.ticket['priority'] ?? 'Unknown';
    currentAssignedTo = widget.ticket['agent'] ?? 'Unassigned';

    resolutionController.text =
        widget.ticket['resolution'] ?? '';
  }

 @override
  void dispose() {
    resolutionController.dispose();
    super.dispose();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Resolved':
        return const Color(0xFF059669);

      case 'In Progress':
        return const Color(0xFF2563EB);

      default:
        return const Color(0xFFDC2626);
    }
  }
  Widget detailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.blueGrey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value.isEmpty ? 'Not available' : value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF172554),
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFF2563EB),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172554),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Future<void> resolveTicket() async {
    // Prevent resolving an already resolved ticket.
    if (currentStatus == 'Resolved') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ticket is already resolved.'),
        ),
      );
      return;
    }

    // Validate resolution notes.
    final resolution = resolutionController.text.trim();

    if (resolution.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter resolution notes first.'),
        ),
      );
      return;
    }

    // Get actual database ID.
    final databaseId = int.tryParse(
      widget.ticket['databaseId'] ?? '',
    );

    if (databaseId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid ticket database ID.'),
        ),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await _ticketService.resolveTicket(
        databaseId,
        resolution,
      );

      if (!mounted) return;

      setState(() {
        currentStatus = 'Resolved';
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ticket resolved successfully!'),
        ),
      );

      // Return true so the previous screen can refresh tickets.
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to resolve ticket: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ticket = widget.ticket;
    final sentiment =
        ticket['sentiment'] ?? 'Not available';
    final isResolved = currentStatus == 'Resolved';
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Ticket Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1100,
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#${ticket['id'] ?? 'N/A'}',
                  style: const TextStyle(
                    color: Color(0xFF2563EB),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  ticket['subject'] ?? 'Untitled ticket',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF172554),
                      ),
                ),

                const SizedBox(height: 20),

                LayoutBuilder(
                  builder: (context, constraints) {
                    final wide = constraints.maxWidth >= 700;

                    final ticketInfo = sectionCard(
                      title: 'Ticket Information',
                      icon: Icons.confirmation_number_outlined,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          detailItem(
                            'Description',
                            ticket['description'] ??
                                ticket['subject'] ??
                                'Not available',
                          ),

                          detailItem(
                            'Category',
                            ticket['category'] ?? 'Not available',
                          ),

                          detailItem(
                            'Subcategory',
                            ticket['subCategory'] ?? 'Not available',
                          ),
                          detailItem(
                            'Assigned Agent',
                            currentAssignedTo,
                          ),
                        ],
                      ),
                    );
                    final aiInfo = sectionCard(
                      title: 'AI Analysis',
                      icon: Icons.psychology_outlined,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          detailItem(
                            'Sentiment',
                            sentiment,
                          ),
                          detailItem(
                            'AI Confidence',
                            ticket['aiConfidence'] == null
                                ? 'Not available'
                                : '${(double.tryParse(ticket['aiConfidence']!) ?? 0) * 100}%',
                          ),
                          detailItem(
                            'AI Category',
                            ticket['category'] ?? 'Not available',
                          ),
                          detailItem(
                            'Priority',
                            currentPriority,
                          ),
                        ],
                      ),
                    );
                    if (wide) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: ticketInfo),
                          const SizedBox(width: 20),
                          Expanded(child: aiInfo),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        ticketInfo,
                        const SizedBox(height: 16),
                        aiInfo,
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                // Manage Ticket Section
                sectionCard(
                  title: 'Manage Ticket',
                  icon: Icons.edit_note,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current Status',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Read-only status: backend is the source of truth.
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFE5E7EB),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                currentStatus,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.lock_outline,
                              size: 18,
                              color: Colors.grey.shade500,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Resolution Notes',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Assigned Agent',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: resolutionController,
                        maxLines: 4,
                        readOnly: isResolved,
                        decoration: InputDecoration(
                          hintText:
                              'Describe how the issue was resolved...',

                          filled: true,

                          fillColor: isResolved
                              ? const Color(0xFFF1F5F9)
                              : const Color(0xFFF8FAFC),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed:
                              (isSaving || isResolved)
                                  ? null
                                  : resolveTicket,
                          icon: Icon(
                            isResolved
                                ? Icons.check_circle
                                : Icons.check_circle_outline,
                          ),
                          label: Text(
                            isResolved
                                ? 'Ticket Resolved'
                                : isSaving
                                    ? 'Resolving...'
                                    : 'Resolve Ticket',
                          ),

                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF2563EB),

                            foregroundColor: Colors.white,

                            disabledBackgroundColor:
                                const Color(0xFFD1D5DB),

                            disabledForegroundColor:
                                Colors.white,

                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text('Displayed status: '),

                          Chip(
                            backgroundColor:
                                getStatusColor(currentStatus)
                                    .withValues(alpha: 0.12),

                            label: Text(
                              currentStatus,

                              style: TextStyle(
                                color: getStatusColor(currentStatus),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
