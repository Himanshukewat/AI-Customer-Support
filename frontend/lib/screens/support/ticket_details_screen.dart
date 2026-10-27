import 'package:flutter/material.dart';

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

class _TicketDetailsScreenState
    extends State<TicketDetailsScreen> {
  late String currentStatus;
  late String currentPriority;

  final TextEditingController resolutionController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    currentStatus = widget.ticket['status'] ?? 'Open';
    currentPriority = widget.ticket['priority'] ?? 'Medium';
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

  Widget detailItem(String label, String value){
    return Padding(padding: const EdgeInsets.only(bottom: 18),
    child: Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.blueGrey,
            fontSize: 12
            ),
          ),
          const SizedBox(height : 5),
          Text(
            value.isEmpty ? 'Not aviable': value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF172554),
            ),
          )
      ],
    ),
    
    );
  }


  Widget sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }){
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
  void updateStatus(String? value) {
    if (value == null) return;

    setState(() {
      currentStatus = value;
    });
  }
  void resolveTicket() {
    if (currentStatus == 'Resolved') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ticket is already resolved.'),
        ),
      );
      return;
    }
    if (resolutionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter resolution notes first.'),
        ),
      );
      return;
    }
    setState(() {
      currentStatus = 'Resolved';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Ticket marked as resolved in this demo.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ticket = widget.ticket;
    final sentiment = ticket['sentiment'] ?? 'Not available';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Ticket Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
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
                            ticket['agent'] ?? 'Unassigned',
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
                          detailItem('Sentiment', sentiment),
                          detailItem(
                            'AI Confidence',
                            ticket['aiConfidence'] == null
                                ? 'Not available'
                                : '${(double.tryParse(ticket['aiConfidence']!) ?? 0) * 100}% ',
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
                sectionCard(
                  title: 'Manage Ticket',
                  icon: Icons.edit_note,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current Status',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFE5E7EB),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton<String>(
                          value: currentStatus,
                          isExpanded: true,
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(
                              value: 'Open',
                              child: Text('Open'),
                            ),
                            DropdownMenuItem(
                              value: 'In Progress',
                              child: Text('In Progress'),
                            ),
                            DropdownMenuItem(
                              value: 'Resolved',
                              child: Text('Resolved'),
                            ),
                          ],
                          onChanged: updateStatus,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Resolution Notes',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: resolutionController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Describe how the issue was resolved...',
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: resolveTicket,
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text('Resolve Ticket'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
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