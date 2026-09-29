import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/medical_branding_panel.dart';
import '../widgets/primary_button.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _selectedRole = 'Administrator';
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  final List<String> _roles = const [
    'Administrator',
    'Doctor',
    'Nurse',
    'Receptionist',
  ];

  static const Map<String, _DemoAccount> _demoAccounts = {
    'admin': _DemoAccount(
      username: 'admin',
      password: 'admin123',
      role: 'Administrator',
      label: 'Admin (Full)',
      icon: Icons.admin_panel_settings_rounded,
    ),
    'doctor': _DemoAccount(
      username: 'doctor',
      password: 'doctor123',
      role: 'Doctor',
      label: 'Doctor (Clinical)',
      icon: Icons.medical_services_rounded,
    ),
    'nurse': _DemoAccount(
      username: 'nurse',
      password: 'nurse123',
      role: 'Nurse',
      label: 'Nurse (Ward/Vitals)',
      icon: Icons.health_and_safety_rounded,
    ),
    'reception': _DemoAccount(
      username: 'reception',
      password: 'reception123',
      role: 'Receptionist',
      label: 'Reception (OPD)',
      icon: Icons.how_to_reg_rounded,
    ),
  };

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _autofillRole(String userKey) {
    final account = _demoAccounts[userKey];
    if (account != null) {
      setState(() {
        _usernameController.text = account.username;
        _passwordController.text = account.password;
        _selectedRole = account.role;
        _errorMessage = null;
      });
    }
  }

  Future<void> _handleLogin() async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    setState(() {
      _errorMessage = null;
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String username = _usernameController.text.trim();
    final String password = _passwordController.text;
    final String? role = _selectedRole;

    setState(() {
      _isLoading = true;
    });

    // Simulate 500ms local verification delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // Check against demo role accounts
    final account = _demoAccounts[username.toLowerCase()];
    final bool passwordMatches = account != null &&
        (account.password == password || (account.username == 'doctor' && password == 'doc123'));

    if (account != null && passwordMatches) {
      // Validate role consistency
      if (role != account.role) {
        setState(() {
          _isLoading = false;
          _errorMessage =
              "Role mismatch: User '$username' is assigned to '${account.role}'. Please select '${account.role}' in the dropdown.";
        });
        return;
      }

      setState(() {
        _isLoading = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Login successful ($role access granted)',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: AppTheme.successGreen,
          duration: const Duration(seconds: 2),
        ),
      );

      // Navigate to Dashboard with user role
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => DashboardScreen(
            username: username,
            role: role ?? 'Staff',
          ),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Invalid username or password';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Invalid username or password',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: AppTheme.errorRed,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.lock_reset_rounded, color: AppTheme.primaryBlue),
            SizedBox(width: 10),
            Text(
              'Reset Password',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        content: const Text(
          'For security and hospital data privacy, password recovery must be initiated by the hospital system administrator.\n\nPlease contact IT Support at extension 404 or support@citycarehospital.local.',
          style: TextStyle(fontSize: 14, color: AppTheme.textSecondary, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Understood',
              style: TextStyle(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isDesktop = constraints.maxWidth >= 900;

          if (isDesktop) {
            return _buildDesktopLayout();
          } else {
            return _buildMobileLayout();
          }
        },
      ),
    );
  }

  /// Desktop / Windows Layout (Two-column)
  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left Side: Medical Branding
        const Expanded(
          flex: 5,
          child: MedicalBrandingPanel(),
        ),

        // Right Side: Centered Login Card
        Expanded(
          flex: 6,
          child: Container(
            color: AppTheme.scaffoldBackground,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: _buildLoginCard(isDesktop: true),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Mobile / Android Layout (Single Vertically Scrollable)
  Widget _buildMobileLayout() {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Mobile Hospital Header
                _buildMobileHeader(),
                const SizedBox(height: 16),

                // Login Card
                _buildLoginCard(isDesktop: false),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Mobile Top Branding Header
  Widget _buildMobileHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryBlue.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.local_hospital_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'CityCare Hospital',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppTheme.primaryBlue,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Hospital Management System',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.tealSecondary,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  /// The Reusable Healthcare Login Card
  Widget _buildLoginCard({required bool isDesktop}) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 36 : 20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: AppTheme.cardShadow,
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Hospital Logo Badge (Desktop only, as mobile has top header)
            if (isDesktop) ...[
              Center(
                child: Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppTheme.scaffoldBackground,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.borderLight),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.local_hospital_rounded,
                      color: AppTheme.primaryBlue,
                      size: 28,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Heading & Subtitle
            Center(
              child: Column(
                children: const [
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                      letterSpacing: -0.4,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Sign in to continue to Hospital Management System',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textMuted,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Error Message Banner (if any)
            if (_errorMessage != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.errorRedLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.errorRed.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 18,
                      color: AppTheme.errorRed,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.errorRed,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
            ],

            // 1. Username / Email Field
            CustomTextField(
              label: 'Username or Email',
              hintText: 'Enter your username',
              controller: _usernameController,
              prefixIcon: Icons.person_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // 2. Password Field
            CustomTextField(
              label: 'Password',
              hintText: 'Enter your password',
              controller: _passwordController,
              prefixIcon: Icons.lock_outline_rounded,
              isPassword: true,
              obscureText: _obscurePassword,
              onToggleVisibility: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _handleLogin(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // 3. Role Dropdown
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Role',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  key: ValueKey(_selectedRole),
                  initialValue: _selectedRole,
                  isExpanded: true,
                  hint: const Text(
                    'Select Role',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textLight,
                    ),
                  ),
                  icon: const Icon(
                    Icons.arrow_drop_down_rounded,
                    color: AppTheme.textMuted,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.badge_outlined,
                      size: 20,
                      color: AppTheme.primaryBlueLight,
                    ),
                    filled: true,
                    fillColor: AppTheme.surfaceWhite,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppTheme.borderLight,
                        width: 1.2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppTheme.borderLight,
                        width: 1.2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppTheme.borderFocus,
                        width: 1.8,
                      ),
                    ),
                  ),
                  items: _roles.map((role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(
                        role,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textDark,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a role';
                    }
                    return null;
                  },
                ),
              ],
            ),

            const SizedBox(height: 14),

            // 4. Remember Me & Forgot Password Row
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 4,
              children: [
                // Remember Me Checkbox
                InkWell(
                  onTap: () {
                    setState(() {
                      _rememberMe = !_rememberMe;
                    });
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          value: _rememberMe,
                          onChanged: (val) {
                            setState(() {
                              _rememberMe = val ?? false;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Remember Me',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Forgot Password Button
                TextButton(
                  onPressed: _showForgotPasswordDialog,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    visualDensity: VisualDensity.compact,
                  ),
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryBlueLight,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 5. Primary Login Button
            PrimaryButton(
              text: 'Login',
              isLoading: _isLoading,
              icon: Icons.login_rounded,
              onPressed: _handleLogin,
            ),

            const SizedBox(height: 16),

            // Role Quick-Select Prototype Chips
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.touch_app_rounded, size: 14, color: AppTheme.textMuted),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Quick Role Auto-Fill (Local Prototype):',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _demoAccounts.entries.map((entry) {
                    final isSelected = _selectedRole == entry.value.role &&
                        _usernameController.text == entry.value.username;
                    return InkWell(
                      onTap: () => _autofillRole(entry.key),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.primaryBlue : AppTheme.surfaceMuted,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? AppTheme.primaryBlue : AppTheme.borderLight,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              entry.value.icon,
                              size: 13,
                              color: isSelected ? Colors.white : AppTheme.primaryBlueLight,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              entry.value.label,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.white : AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // 6. Small Footer Text
            const Center(
              child: Text(
                'Local Hospital System • Prototype',
                style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.textMuted,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoAccount {
  final String username;
  final String password;
  final String role;
  final String label;
  final IconData icon;

  const _DemoAccount({
    required this.username,
    required this.password,
    required this.role,
    required this.label,
    required this.icon,
  });
}
