import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // final nameController = TextEditingController(text: 'Support Agent');
  // final emailController =
  //     TextEditingController(text: 'agent@example.com');

  // String selectedTeam = 'Account Support';
  bool ticketNotifications = true;
  bool assignmentNotifications = true;
  bool resolutionNotifications = false;
  bool compactView = false;

  @override
  void dispose() {
    // nameController.dispose();
    // emailController.dispose();
    super.dispose();
  }

  void saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Settings saved for this demo session only.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 700;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isDesktop ? 28 : 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SUPPORT TEAM / SETTINGS',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Settings',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(
                      color: const Color(0xFF172554),
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Manage your agent profile and workspace preferences.',
                style: TextStyle(color: Colors.blueGrey),
              ),
              const SizedBox(height: 24),

              // Agent profile
              // _SettingsSection(
              //   title: 'Agent Profile',
              //   subtitle: 'Your basic support team information.',
              //   icon: Icons.person_outline,
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       const Text(
              //         'Full Name',
              //         style: TextStyle(fontWeight: FontWeight.w600),
              //       ),
              //       const SizedBox(height: 8),
              //       TextField(
              //         controller: nameController,
              //         decoration: InputDecoration(
              //           hintText: 'Enter your name',
              //           prefixIcon: const Icon(Icons.person_outline),
              //           border: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(10),
              //           ),
              //         ),
              //       ),
              //       const SizedBox(height: 18),
              //       const Text(
              //         'Email Address',
              //         style: TextStyle(fontWeight: FontWeight.w600),
              //       ),
              //       const SizedBox(height: 8),
              //       TextField(
              //         controller: emailController,
              //         keyboardType: TextInputType.emailAddress,
              //         decoration: InputDecoration(
              //           hintText: 'Enter your email',
              //           prefixIcon: const Icon(Icons.email_outlined),
              //           border: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(10),
              //           ),
              //         ),
              //       ),
              //       const SizedBox(height: 18),
              //       const Text(
              //         'Support Team',
              //         style: TextStyle(fontWeight: FontWeight.w600),
              //       ),
              //       const SizedBox(height: 8),
              //       DropdownButtonFormField<String>(
              //         value: selectedTeam,
              //         decoration: InputDecoration(
              //           border: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(10),
              //           ),
              //         ),
              //         items: const [
              //           DropdownMenuItem(
              //             value: 'Account Support',
              //             child: Text('Account Support'),
              //           ),
              //           DropdownMenuItem(
              //             value: 'Payment Support',
              //             child: Text('Payment Support'),
              //           ),
              //           DropdownMenuItem(
              //             value: 'Delivery Support',
              //             child: Text('Delivery Support'),
              //           ),
              //           DropdownMenuItem(
              //             value: 'General Support',
              //             child: Text('General Support'),
              //           ),
              //         ],
              //         onChanged: (value) {
              //           if (value != null) {
              //             setState(() => selectedTeam = value);
              //           }
              //         },
              //       ),
              //     ],
              //   ),
              // ),

              // const SizedBox(height: 20),

              // Notifications
              _SettingsSection(
                title: 'Notifications',
                subtitle: 'Choose which ticket updates you want to see.',
                icon: Icons.notifications_none,
                child: Column(
                  children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('New ticket notifications'),
                      subtitle: const Text(
                        'Get notified about new support tickets.',
                      ),
                      value: ticketNotifications,
                      onChanged: (value) {
                        setState(() => ticketNotifications = value);
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Assignment notifications'),
                      subtitle: const Text(
                        'Get notified when a ticket is assigned to you.',
                      ),
                      value: assignmentNotifications,
                      onChanged: (value) {
                        setState(
                          () => assignmentNotifications = value,
                        );
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Resolution notifications'),
                      subtitle: const Text(
                        'Get notified when a ticket is resolved.',
                      ),
                      value: resolutionNotifications,
                      onChanged: (value) {
                        setState(
                          () => resolutionNotifications = value,
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Display preferences
              _SettingsSection(
                title: 'Display Preferences',
                subtitle: 'Customize how tickets appear in your workspace.',
                icon: Icons.display_settings_outlined,
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Compact ticket view'),
                  subtitle: const Text(
                    'Use a more compact layout for ticket lists.',
                  ),
                  value: compactView,
                  onChanged: (value) {
                    setState(() => compactView = value);
                  },
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: saveSettings,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Save Settings'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Settings are currently stored in this screen only.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;

  const _SettingsSection({
    required this.title,
    required this.subtitle,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: const Color(0xFF2563EB), size: 25),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF172554),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 12,
                      ),
                    ),
                  ],
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
