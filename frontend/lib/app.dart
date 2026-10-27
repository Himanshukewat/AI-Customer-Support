import 'package:flutter/material.dart';
import 'package:frontend/screens/support/settings_screen.dart';
import 'screens/support/dashboard_screen.dart';
import 'screens/support/tickets_screen.dart';
import 'screens/support/team_queue_screen.dart';
import 'screens/support/reports_screen.dart';
import 'screens/support/profile_screen.dart';

class SupportApp extends StatelessWidget {
  const SupportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Customer Support',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      ),
      home: const SupportHome(),
    );
  }
}

class SupportHome extends StatefulWidget {
  const SupportHome({super.key});
  @override
  State<SupportHome> createState() => _SupportHomeState();
}

class _SupportHomeState extends State<SupportHome> {
  int selectedIndex = 0;
  static const Color navy = Color(0xFF172554);
  final List<String> pageTitles = [
    'Dashboard',
    'Assigned Tickets',
    'Team Queue',
    'Reports',
    'Settings',
  ];
  Widget buildPage() {
    switch (selectedIndex) {
      case 0:
        return const DashboardScreen();
      case 1:
        return const TicketsScreen();
      case 2:
        return const TeamQueueScreen();
      case 3:
        return const ReportsScreen();
      case 4:
        return const SettingsScreen();
      case 5:
        return const ProfileScreen();
      default:
        return Center(
          child: Text(
            '${pageTitles[selectedIndex]} — Coming soon',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;

        return Scaffold(
          drawer: isDesktop
              ? null
              : Drawer(
                  backgroundColor: navy,
                  child: SafeArea(
                    child: buildSidebar(),
                  ),
                ),
          body: Row(
            children: [
              if (isDesktop)
                SizedBox(
                  width: 240,
                  child: buildSidebar(),
                ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 72,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          if (!isDesktop)
                            Builder(
                              builder: (context) => IconButton(
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                                icon: const Icon(Icons.menu),
                              ),
                            ),
                          Expanded(
                            child: Text(
                              isDesktop
                                  ? 'Agent Workspace'
                                  : pageTitles[selectedIndex],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: 'My Profile',
                            onPressed: () {
                              setState(() => selectedIndex = 5);
                            },
                            icon: const CircleAvatar(
                              backgroundColor: Color(0xFFDBEAFE),
                              child: Icon(
                                Icons.person,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: buildPage()),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildSidebar() {
    const icons = [
      Icons.dashboard_outlined,
      Icons.confirmation_number_outlined,
      Icons.groups_outlined,
      Icons.analytics_outlined,
      Icons.settings_outlined,
    ];

    return Material(
      color: navy,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(24),
            child: Row(
              children: [
                Icon(
                  Icons.support_agent,
                  color: Colors.white,
                  size: 30,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'SupportDesk',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white24),
          const SizedBox(height: 12),
          for (int i = 0; i < pageTitles.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
              child: Material(
                color: Colors.transparent,
                child: ListTile(
                  selected: selectedIndex == i,
                  selectedTileColor: Colors.white.withValues(alpha: 0.12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  leading: Icon(
                    icons[i],
                    color: selectedIndex == i
                        ? Colors.white
                        : Colors.white70,
                  ),
                  title: Text(
                    pageTitles[i],
                    style: TextStyle(
                      color: selectedIndex == i
                          ? Colors.white
                          : Colors.white70,
                      fontWeight: selectedIndex == i
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    setState(() => selectedIndex = i);
                    if (! (MediaQuery.of(context).size.width >= 900)) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
