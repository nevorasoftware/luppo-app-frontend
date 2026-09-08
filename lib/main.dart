import 'package:flutter/material.dart';
import 'config/app_colors.dart';
import 'config/app_theme.dart';
import 'core/api_client.dart';
import 'models/models.dart';
import 'views/login_view.dart';
import 'views/dashboard_view.dart';
import 'views/prospects_view.dart';
import 'views/prospecting_view.dart';
import 'views/pipeline_view.dart';
import 'views/follow_ups_view.dart';
import 'components/ui_components.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LuppoApp());
}

class LuppoApp extends StatefulWidget {
  const LuppoApp({Key? key}) : super(key: key);

  @override
  State<LuppoApp> createState() => _LuppoAppState();
}

class _LuppoAppState extends State<LuppoApp> {
  AuthResponse? _currentUser;
  bool _isCheckingAuth = true;

  @override
  void initState() {
    super.initState();
    _checkInitialAuth();
  }

  Future<void> _checkInitialAuth() async {
    final token = await ApiClient.getToken();
    final user = await ApiClient.getStoredUser();
    setState(() {
      if (token != null && user != null) {
        _currentUser = user;
      }
      _isCheckingAuth = false;
    });
  }

  void _handleLoginSuccess(AuthResponse auth) {
    setState(() {
      _currentUser = auth;
    });
  }

  void _handleLogout() async {
    await ApiClient.logout();
    setState(() {
      _currentUser = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luppo — Gestión Comercial',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: _isCheckingAuth
          ? const Scaffold(
              backgroundColor: Color(0xFF0B1B2D),
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LuppoLogo(size: 64, showText: true),
                    SizedBox(height: 24),
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: AppColors.tealAccent, strokeWidth: 2.5),
                    ),
                  ],
                ),
              ),
            )
          : _currentUser == null
              ? LoginView(onLoginSuccess: _handleLoginSuccess)
              : AppShell(
                  currentUser: _currentUser!,
                  onLogout: _handleLogout,
                ),
    );
  }
}

class AppShell extends StatefulWidget {
  final AuthResponse currentUser;
  final VoidCallback onLogout;

  const AppShell({
    Key? key,
    required this.currentUser,
    required this.onLogout,
  }) : super(key: key);

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  final List<Widget> _views = const [
    DashboardView(),
    ProspectsView(),
    ProspectingView(),
    PipelineView(),
    FollowUpsView(),
  ];

  final List<_NavItem> _navItems = const [
    _NavItem(title: 'Mi Día Comercial', icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard),
    _NavItem(title: 'Mis KYC', icon: Icons.people_outline, activeIcon: Icons.people),
    _NavItem(title: 'Metas Diarias', icon: Icons.track_changes_outlined, activeIcon: Icons.track_changes),
    _NavItem(title: 'Cartera (Pipeline)', icon: Icons.account_tree_outlined, activeIcon: Icons.account_tree),
    _NavItem(title: 'Seguimientos', icon: Icons.calendar_today_outlined, activeIcon: Icons.calendar_today),
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: !isDesktop
          ? AppBar(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              title: Row(
                children: [
                  const LuppoLogo(size: 26),
                  const SizedBox(width: 10),
                  Text(
                    _navItems[_selectedIndex].title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.white),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout, size: 20, color: AppColors.white),
                  tooltip: 'Cerrar Sesión',
                  onPressed: widget.onLogout,
                ),
              ],
            )
          : null,
      body: Row(
        children: [
          // Sidebar for Desktop
          if (isDesktop)
            Container(
              width: 250,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                border: Border(right: BorderSide(color: AppColors.secondaryBlue, width: 1)),
              ),
              child: Column(
                children: [
                  // Sidebar Brand Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    child: Row(
                      children: [
                        const LuppoLogo(size: 34),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            LuppoWordmark(fontSize: 18),
                            SizedBox(height: 2),
                            Text(
                              'Gestión Comercial',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF94A3B8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.secondaryBlue),
                  const SizedBox(height: 12),

                  // Nav list
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: _navItems.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 4),
                      itemBuilder: (context, index) {
                        final item = _navItems[index];
                        final isSelected = _selectedIndex == index;

                        return InkWell(
                          onTap: () => setState(() => _selectedIndex = index),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.secondaryBlue : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              border: isSelected
                                  ? Border.all(color: AppColors.tealAccent.withOpacity(0.4), width: 1)
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected ? item.activeIcon : item.icon,
                                  size: 20,
                                  color: isSelected ? AppColors.tealAccent : const Color(0xFF94A3B8),
                                ),
                                const SizedBox(width: 14),
                                Text(
                                  item.title,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    color: isSelected ? AppColors.white : const Color(0xFFE2E8F0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Bottom User Info & Logout
                  const Divider(height: 1, color: AppColors.secondaryBlue),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.tealAccent,
                          child: Text(
                            widget.currentUser.firstName.isNotEmpty ? widget.currentUser.firstName[0].toUpperCase() : 'U',
                            style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${widget.currentUser.firstName} ${widget.currentUser.lastName}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                widget.currentUser.roles.isNotEmpty ? widget.currentUser.roles.first.replaceAll('ROLE_', '') : 'Comercial',
                                style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.logout, size: 18, color: Color(0xFF94A3B8)),
                          tooltip: 'Cerrar sesión',
                          onPressed: widget.onLogout,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Main View Content
          Expanded(
            child: _views[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: !isDesktop
          ? BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) => setState(() => _selectedIndex = index),
              selectedItemColor: AppColors.accent,
              unselectedItemColor: AppColors.textSecondary,
              type: BottomNavigationBarType.fixed,
              backgroundColor: AppColors.surface,
              elevation: 8,
              items: _navItems
                  .map(
                    (item) => BottomNavigationBarItem(
                      icon: Icon(item.icon),
                      activeIcon: Icon(item.activeIcon),
                      label: item.title,
                    ),
                  )
                  .toList(),
            )
          : null,
    );
  }
}

class _NavItem {
  final String title;
  final IconData icon;
  final IconData activeIcon;

  const _NavItem({
    required this.title,
    required this.icon,
    required this.activeIcon,
  });
}
