import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class DashboardScreen extends StatelessWidget {
  final String username;
  final String role;

  const DashboardScreen({
    super.key,
    required this.username,
    required this.role,
  });

  bool get isAdmin => role == 'Administrator';
  bool get isDoctor => role == 'Doctor';
  bool get isNurse => role == 'Nurse';
  bool get isReceptionist => role == 'Receptionist';

  Color get roleColor {
    switch (role) {
      case 'Administrator':
        return AppTheme.primaryBlue;
      case 'Doctor':
        return AppTheme.tealSecondary;
      case 'Nurse':
        return const Color(0xFF0284C7);
      case 'Receptionist':
        return const Color(0xFFD97706);
      default:
        return AppTheme.primaryBlue;
    }
  }

  String get roleAccessLevel {
    switch (role) {
      case 'Administrator':
        return 'Full System Access (Unrestricted)';
      case 'Doctor':
        return 'Clinical & Diagnostic Access';
      case 'Nurse':
        return 'Ward Care & Vitals Charting Access';
      case 'Receptionist':
        return 'Front Desk & Scheduling Access';
      default:
        return 'Standard Hospital Staff Access';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: isWide ? 24 : 12,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.local_hospital_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'CityCare Hospital',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isWide ? 16 : 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                  if (isWide)
                    const Text(
                      'Hospital Management System',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isAdmin
                      ? Icons.admin_panel_settings_rounded
                      : isDoctor
                          ? Icons.medical_services_rounded
                          : isNurse
                              ? Icons.health_and_safety_rounded
                              : Icons.desk_rounded,
                  size: 14,
                  color: AppTheme.tealAccent,
                ),
                const SizedBox(width: 5),
                Text(
                  isWide ? '$username ($role)' : role,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout_rounded, size: 20),
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isWide ? 32 : 16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Banner with Role Clearance Badge
                _buildRoleWelcomeBanner(context, isWide),

                const SizedBox(height: 24),

                // Role-Specific Metrics Section
                Text(
                  '$role Operations Overview',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 12),

                // Metrics Grid
                _buildRoleMetricsGrid(),

                const SizedBox(height: 28),

                // Role-Based Access Control (RBAC) Module Clearance
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    Text(
                      isAdmin
                          ? 'Master System Directory (All Hospital Sections)'
                          : '$role Department Sections',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: roleColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: roleColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isAdmin ? Icons.admin_panel_settings_rounded : Icons.verified_user_rounded,
                            size: 13,
                            color: roleColor,
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              isAdmin
                                  ? 'All 9 Sections'
                                  : '$role (${_getVisibleModules().length} Active)',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: roleColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  isAdmin
                      ? 'Administrator master privilege active: All departmental sections, clinical systems, and ledgers are visible.'
                      : isDoctor
                          ? 'Doctor workspace: Only medical, diagnostic, and prescription sections are displayed. Other hospital sections are hidden.'
                          : isNurse
                              ? 'Nursing workspace: Only inpatient wards, patient vitals, and dispensing sections are displayed. Other hospital sections are hidden.'
                              : 'Receptionist workspace: Only patient registration, scheduling, and billing sections are displayed. Other hospital sections are hidden.',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 14),

                // Module Clearance Grid
                _buildModulesGrid(context),

                const SizedBox(height: 28),

                // Session Security Notice
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.borderLight),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        size: 20,
                        color: AppTheme.primaryBlue,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'CityCare Hospital RBAC Security active. Logged in as $username with role $role. '
                          'Access privileges strictly match clinical and administrative credential policies.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary.withValues(alpha: 0.9),
                            height: 1.4,
                          ),
                        ),
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

  Widget _buildRoleWelcomeBanner(BuildContext context, bool isWide) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isWide ? 24 : 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: const [
          BoxShadow(
            color: AppTheme.cardShadow,
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: roleColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isAdmin
                  ? Icons.admin_panel_settings_rounded
                  : isDoctor
                      ? Icons.medical_services_rounded
                      : isNurse
                          ? Icons.health_and_safety_rounded
                          : Icons.how_to_reg_rounded,
              color: roleColor,
              size: 34,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Text(
                      'Welcome back, $username!',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: roleColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        role,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: roleColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  roleAccessLevel,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: roleColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleMetricsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final int crossAxisCount = constraints.maxWidth > 700 ? 4 : 2;
        final double cardRatio = constraints.maxWidth > 700
            ? 1.4
            : (constraints.maxWidth > 380 ? 1.25 : 1.12);
        final double spacing = constraints.maxWidth > 700 ? 16.0 : 12.0;

        if (isAdmin) {
          return GridView.count(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: cardRatio,
            children: const [
              _StatCard(
                title: 'Total Admitted',
                value: '184',
                subtitle: '+12 today',
                icon: Icons.hotel_rounded,
                iconColor: Color(0xFF0284C7),
                iconBg: Color(0xFFE0F2FE),
              ),
              _StatCard(
                title: 'Hospital Staff',
                value: '78',
                subtitle: '42 Doctors, 36 Nurses',
                icon: Icons.badge_rounded,
                iconColor: AppTheme.tealSecondary,
                iconBg: AppTheme.tealLight,
              ),
              _StatCard(
                title: "Today's Revenue",
                value: '\$28,450',
                subtitle: '94% claims settled',
                icon: Icons.payments_rounded,
                iconColor: Color(0xFF16A34A),
                iconBg: Color(0xFFF0FDF4),
              ),
              _StatCard(
                title: 'ICU Beds Ready',
                value: '6 / 8',
                subtitle: 'Emergency readiness',
                icon: Icons.emergency_rounded,
                iconColor: Color(0xFFDC2626),
                iconBg: Color(0xFFFEE2E2),
              ),
            ],
          );
        } else if (isDoctor) {
          return GridView.count(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: cardRatio,
            children: const [
              _StatCard(
                title: 'Assigned Patients',
                value: '14',
                subtitle: '3 critical review',
                icon: Icons.people_outline_rounded,
                iconColor: AppTheme.tealSecondary,
                iconBg: AppTheme.tealLight,
              ),
              _StatCard(
                title: 'Pending Consults',
                value: '6',
                subtitle: '2 emergency triage',
                icon: Icons.medical_information_rounded,
                iconColor: Color(0xFF0284C7),
                iconBg: Color(0xFFE0F2FE),
              ),
              _StatCard(
                title: 'Lab Reports Ready',
                value: '8',
                subtitle: 'Awaiting signature',
                icon: Icons.biotech_rounded,
                iconColor: Color(0xFFD97706),
                iconBg: Color(0xFFFEF3C7),
              ),
              _StatCard(
                title: 'Discharges Cleared',
                value: '3',
                subtitle: 'Ready today',
                icon: Icons.assignment_turned_in_rounded,
                iconColor: Color(0xFF16A34A),
                iconBg: Color(0xFFF0FDF4),
              ),
            ],
          );
        } else if (isNurse) {
          return GridView.count(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: cardRatio,
            children: const [
              _StatCard(
                title: 'Ward Beds In-Use',
                value: '28 / 32',
                subtitle: 'Ward 4B East',
                icon: Icons.bed_rounded,
                iconColor: Color(0xFF0284C7),
                iconBg: Color(0xFFE0F2FE),
              ),
              _StatCard(
                title: 'Vitals Checks Due',
                value: '9',
                subtitle: 'Next round in 20m',
                icon: Icons.monitor_heart_rounded,
                iconColor: Color(0xFFDC2626),
                iconBg: Color(0xFFFEE2E2),
              ),
              _StatCard(
                title: 'Meds Scheduled',
                value: '18',
                subtitle: 'MAR schedule 14:00',
                icon: Icons.medication_rounded,
                iconColor: AppTheme.tealSecondary,
                iconBg: AppTheme.tealLight,
              ),
              _StatCard(
                title: 'Doctor Orders',
                value: '5',
                subtitle: 'New clinical notes',
                icon: Icons.note_alt_outlined,
                iconColor: Color(0xFFD97706),
                iconBg: Color(0xFFFEF3C7),
              ),
            ],
          );
        } else {
          // Receptionist
          return GridView.count(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: cardRatio,
            children: const [
              _StatCard(
                title: 'Today Check-Ins',
                value: '54',
                subtitle: '+8 in last hour',
                icon: Icons.how_to_reg_rounded,
                iconColor: Color(0xFFD97706),
                iconBg: Color(0xFFFEF3C7),
              ),
              _StatCard(
                title: 'Appointments',
                value: '36',
                subtitle: '12 morning, 24 evening',
                icon: Icons.calendar_month_rounded,
                iconColor: AppTheme.tealSecondary,
                iconBg: AppTheme.tealLight,
              ),
              _StatCard(
                title: 'OPD Waiting Queue',
                value: '8',
                subtitle: 'Avg wait 12 mins',
                icon: Icons.hourglass_top_rounded,
                iconColor: Color(0xFF0284C7),
                iconBg: Color(0xFFE0F2FE),
              ),
              _StatCard(
                title: 'OPD Registrations',
                value: '22',
                subtitle: 'New patient profiles',
                icon: Icons.person_add_alt_1_rounded,
                iconColor: Color(0xFF16A34A),
                iconBg: Color(0xFFF0FDF4),
              ),
            ],
          );
        }
      },
    );
  }


  List<_ModuleItem> _getVisibleModules() {
    final List<_ModuleItem> allModules = [
      _ModuleItem(
        title: 'Patient Directory & Demographics',
        description: 'Patient admissions, search records, and contact info',
        department: 'General Hospital',
        icon: Icons.folder_shared_rounded,
        hasAccess: true,
        accessLabel: isAdmin
            ? 'Full Master CRUD'
            : isDoctor
                ? 'Clinical View & Edit'
                : isNurse
                    ? 'Ward View'
                    : 'Patient Registration',
      ),
      _ModuleItem(
        title: 'Clinical Consultations & EHR',
        description: 'Medical history, diagnostic summaries, and doctor notes',
        department: 'Clinical Care',
        icon: Icons.medical_information_rounded,
        hasAccess: isAdmin || isDoctor,
        accessLabel: isAdmin ? 'Full Clearance' : 'Doctor Authorized',
      ),
      _ModuleItem(
        title: 'Prescriptions & e-Rx',
        description: 'Electronic drug orders, dosages, and pharmacy dispensation',
        department: 'Pharmacy',
        icon: Icons.medication_rounded,
        hasAccess: isAdmin || isDoctor || isNurse,
        accessLabel: isAdmin
            ? 'Full Clearance'
            : isDoctor
                ? 'Doctor Write & Sign'
                : 'Nurse Dispensation',
      ),
      _ModuleItem(
        title: 'Diagnostic Lab & Imaging Orders',
        description: 'Blood work, X-Rays, MRI scans, and pathology results',
        department: 'Diagnostics',
        icon: Icons.biotech_rounded,
        hasAccess: isAdmin || isDoctor,
        accessLabel: isAdmin ? 'Full Clearance' : 'Doctor Authorized',
      ),
      _ModuleItem(
        title: 'Inpatient Wards & Bed Allocation',
        description: 'Room assignments, bed occupancy, and ward transfers',
        department: 'Inpatient Care',
        icon: Icons.hotel_rounded,
        hasAccess: isAdmin || isNurse,
        accessLabel: isAdmin ? 'Full Clearance' : 'Nurse Authorized',
      ),
      _ModuleItem(
        title: 'Patient Vitals & Nurse Charting',
        description: 'Blood pressure, pulse, temperature, and MAR logs',
        department: 'Nursing & Vitals',
        icon: Icons.monitor_heart_rounded,
        hasAccess: isAdmin || isNurse || isDoctor,
        accessLabel: isNurse
            ? 'Primary Nurse Charting'
            : (isDoctor ? 'Doctor Clinical View' : 'Full Clearance'),
      ),
      _ModuleItem(
        title: 'Appointments & OPD Scheduling',
        description: 'Doctor clinic schedules, patient check-ins, and tokens',
        department: 'Front Desk',
        icon: Icons.calendar_month_rounded,
        hasAccess: isAdmin || isReceptionist || isDoctor,
        accessLabel: isReceptionist
            ? 'OPD Counter Manager'
            : (isDoctor ? 'Doctor Schedule' : 'Full Clearance'),
      ),
      _ModuleItem(
        title: 'Billing, Invoicing & Insurance',
        description: 'Fee collection, claim adjudication, and financial ledger',
        department: 'Finance & Accounts',
        icon: Icons.receipt_long_rounded,
        hasAccess: isAdmin || isReceptionist,
        accessLabel: isAdmin ? 'Full Financial Ledger' : 'OPD Billing Counter',
      ),
      _ModuleItem(
        title: 'Hospital Settings & Staff Roster',
        department: 'Administration',
        description: 'User accounts, role policies, and system audit logs',
        icon: Icons.admin_panel_settings_rounded,
        hasAccess: isAdmin,
        accessLabel: 'Master Admin Only',
      ),
    ];

    // Non-admin roles strictly see ONLY the sections belonging to their profession.
    // Admin has master clearance and can see all hospital sections.
    if (isAdmin) {
      return allModules;
    }
    return allModules.where((m) => m.hasAccess).toList();
  }

  Widget _buildModulesGrid(BuildContext context) {
    final List<_ModuleItem> visibleModules = _getVisibleModules();

    return LayoutBuilder(
      builder: (context, constraints) {
        final int crossAxisCount = constraints.maxWidth > 700 ? 2 : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: visibleModules.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 14,
            childAspectRatio: constraints.maxWidth > 700 ? 2.5 : 2.6,
          ),
          itemBuilder: (ctx, index) {
            final mod = visibleModules[index];
            return _ModuleCard(
              module: mod,
              userRole: role,
            );
          },
        );
      },
    );
  }
}

class _ModuleItem {
  final String title;
  final String description;
  final IconData icon;
  final String department;
  final bool hasAccess;
  final String accessLabel;

  const _ModuleItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.department,
    required this.hasAccess,
    required this.accessLabel,
  });
}

class _ModuleCard extends StatelessWidget {
  final _ModuleItem module;
  final String userRole;

  const _ModuleCard({
    required this.module,
    required this.userRole,
  });

  void _showModuleDialog(BuildContext context) {
    if (module.hasAccess) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.tealLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(module.icon, color: AppTheme.tealSecondary, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  module.title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.successGreenLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Access Level: ${module.accessLabel}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.successGreen,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                module.description,
                style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 12),
              Text(
                'Authenticated as $userRole. You have active permissions to work within this module.',
                style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: const [
              Icon(Icons.lock_rounded, color: AppTheme.errorRed, size: 24),
              SizedBox(width: 10),
              Text(
                'Access Denied',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.errorRed,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your current role ($userRole) does not have clearance to view or modify:',
                style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 8),
              Text(
                module.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.errorRedLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.errorRed.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  'Policy: ${module.accessLabel}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.errorRed,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Understood'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool granted = module.hasAccess;

    return InkWell(
      onTap: () => _showModuleDialog(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: granted ? AppTheme.surfaceWhite : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: granted ? AppTheme.borderLight : const Color(0xFFE2E8F0),
            width: 1.2,
          ),
          boxShadow: granted
              ? const [
                  BoxShadow(
                    color: AppTheme.cardShadow,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: granted ? AppTheme.tealLight : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                granted ? module.icon : Icons.lock_outline_rounded,
                size: 22,
                color: granted ? AppTheme.tealSecondary : const Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          module.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: granted ? AppTheme.textDark : AppTheme.textMuted,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.tealLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          module.department,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.tealSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    module.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: granted ? AppTheme.textMuted : AppTheme.textLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        granted ? Icons.check_circle_rounded : Icons.lock_outline_rounded,
                        size: 12,
                        color: granted ? AppTheme.tealSecondary : AppTheme.errorRed,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          module.accessLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: granted ? AppTheme.primaryBlueLight : AppTheme.errorRed,
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
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: const [
          BoxShadow(
            color: AppTheme.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              const Icon(
                Icons.trending_up_rounded,
                size: 15,
                color: AppTheme.successGreen,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppTheme.textMuted,
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
