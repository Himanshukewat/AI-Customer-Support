import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController(text: 'Support Agent');
  final emailController =
      TextEditingController(text: 'agent@example.com');

  final agentIdController = TextEditingController(text: 'AGT-001');

  String selectedTeam = 'Account Support';
  bool isEditing = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    agentIdController.dispose();
    super.dispose();
  }

  void saveProfile() {
    setState(() => isEditing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated for this demo session.'),
      ),
    );
  }

  Widget infoField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: readOnly || !isEditing,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
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

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isDesktop ? 28 : 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 950),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SUPPORT TEAM / PROFILE',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'My Profile',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: const Color(0xFF172554),
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              const Text(
                'View and manage your support agent information.',
                style: TextStyle(color: Colors.blueGrey),
              ),
              const SizedBox(height: 24),

              // Profile header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF172554),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Wrap(
                  spacing: 18,
                  runSpacing: 16,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 38,
                      backgroundColor: Color(0xFFDBEAFE),
                      child: Icon(
                        Icons.person,
                        size: 42,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    SizedBox(
                      width: isDesktop ? 500 : 220,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nameController.text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Support Agent',
                            style: TextStyle(color: Color(0xFFCBD5E1)),
                          ),
                          const SizedBox(height: 10),
                          const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.verified_user_outlined,
                                size: 16,
                                color: Color(0xFF86EFAC),
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Agent ID: AGT-001',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
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

              const SizedBox(height: 20),

              // Personal information
              sectionCard(
                title: 'Personal Information',
                icon: Icons.person_outline,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final wide = constraints.maxWidth >= 600;
                    final fieldWidth = wide
                        ? (constraints.maxWidth - 16) / 2
                        : constraints.maxWidth;

                    return Wrap(
                      spacing: 16,
                      runSpacing: 18,
                      children: [
                        SizedBox(
                          width: fieldWidth,
                          child: infoField(
                            label: 'Full Name',
                            controller: nameController,
                            icon: Icons.person_outline,
                          ),
                        ),
                        SizedBox(
                          width: fieldWidth,
                          child: infoField(
                            label: 'Email Address',
                            controller: emailController,
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        SizedBox(
                          width: fieldWidth,
                          child: infoField(
                            label: 'Agent ID',
                            controller: agentIdController,
                            icon: Icons.badge_outlined,
                            readOnly: true,
                          ),
                        ),
                        SizedBox(
                          width: fieldWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Assigned Team',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF334155),
                                ),
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                value: selectedTeam,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFF8FAFC),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Account Support',
                                    child: Text('Account Support'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Payment Support',
                                    child: Text('Payment Support'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Delivery Support',
                                    child: Text('Delivery Support'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'General Support',
                                    child: Text('General Support'),
                                  ),
                                ],
                                onChanged: isEditing
                                    ? (value) {
                                        if (value != null) {
                                          setState(() {
                                            selectedTeam = value;
                                          });
                                        }
                                      }
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Skills
              sectionCard(
                title: 'Support Skills',
                icon: Icons.workspace_premium_outlined,
                child: const Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _SkillChip(label: 'Customer Support'),
                    _SkillChip(label: 'Ticket Management'),
                    _SkillChip(label: 'Account Issues'),
                    _SkillChip(label: 'Issue Resolution'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Demo performance
              sectionCard(
                title: 'Performance Overview',
                icon: Icons.trending_up,
                child: const Wrap(
                  spacing: 28,
                  runSpacing: 20,
                  children: [
                    _PerformanceItem(
                      label: 'Tickets Resolved',
                      value: '24',
                      icon: Icons.check_circle_outline,
                    ),
                    _PerformanceItem(
                      label: 'Open Tickets',
                      value: '5',
                      icon: Icons.inbox_outlined,
                    ),
                    _PerformanceItem(
                      label: 'Avg. Resolution',
                      value: '2.4 hrs',
                      icon: Icons.schedule,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Actions
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  if (!isEditing)
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() => isEditing = true);
                      },
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Edit Profile'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                    )
                  else ...[
                    ElevatedButton.icon(
                      onPressed: saveProfile,
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('Save Changes'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF059669),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          nameController.text = 'Support Agent';
                          emailController.text = 'agent@example.com';
                          selectedTeam = 'Account Support';
                          isEditing = false;
                        });
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 16),
              const Text(
                'Profile details and performance figures are sample data.',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;

  const _SkillChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: const Icon(
        Icons.check_circle_outline,
        size: 17,
        color: Color(0xFF2563EB),
      ),
      label: Text(label),
      backgroundColor: const Color(0xFFEFF6FF),
      side: BorderSide.none,
    );
  }
}

class _PerformanceItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _PerformanceItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF2563EB), size: 25),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172554),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.blueGrey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
