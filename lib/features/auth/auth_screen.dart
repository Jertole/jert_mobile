import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';
import '../../core/state/app_controller.dart';
import '../../core/ui/jert_button.dart';
import '../../core/ui/jert_colors.dart';
import '../../core/ui/jert_panel.dart';
import '../../core/ui/jert_scaffold_background.dart';
import 'kyc_pending_screen.dart';

enum AuthMode { register, signIn }

class AuthScreen extends StatefulWidget {
  final AppController controller;
  final AuthMode mode;

  const AuthScreen({
    super.key,
    required this.controller,
    required this.mode,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final companyController = TextEditingController();

  bool obscurePassword = true;
  bool loading = false;
  String? errorText;

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    companyController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final isRegister = widget.mode == AuthMode.register;
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();
    final company = companyController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorText = 'Email and password are required.';
      });
      return;
    }

    if (isRegister && (company.isEmpty || phone.isEmpty)) {
      setState(() {
        errorText = 'Company and phone are required for registration.';
      });
      return;
    }

    setState(() {
      loading = true;
      errorText = null;
    });

    try {
      late final SessionAuthResult authResult;

      if (isRegister) {
        authResult = await widget.controller.apiService.register(
          accountType: 'company',
          email: email,
          phone: phone,
          password: password,
        );

        await widget.controller.apiService.submitKyc(
          bearerToken: authResult.sessionToken,
        );
      } else {
        authResult = await widget.controller.apiService.login(
          email: email,
          password: password,
        );
      }

      await widget.controller.setSession(
        sessionToken: authResult.sessionToken,
        userId: authResult.userId,
      );

      widget.controller.updateAccessState(
        authed: true,
        walletConnected: false,
        kycStatus: KycStatus.registered,
      );

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => KycPendingScreen(
            controller: widget.controller,
            email: email,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        errorText = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRegister = widget.mode == AuthMode.register;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(isRegister ? 'Create Account' : 'Sign In'),
      ),
      extendBodyBehindAppBar: true,
      body: JertScaffoldBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      isRegister
                          ? 'Create your JERT access'
                          : 'Sign in to JERT',
                      style: const TextStyle(
                        color: JertColors.textPrimary,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        height: 1.08,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isRegister
                          ? 'Create your access profile to continue.'
                          : 'Sign in to continue.',
                      style: const TextStyle(
                        color: JertColors.textSecondary,
                        fontSize: 15,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 22),
                    JertPanel(
                      borderColor: JertColors.borderCyan,
                      boxShadow: JertColors.cyanSoftGlow,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isRegister) ...[
                            const _FieldLabel('Company / Entity'),
                            const SizedBox(height: 8),
                            _GlassTextField(
                              controller: companyController,
                              hintText: 'Cryogas / partner company',
                            ),
                            const SizedBox(height: 16),
                            const _FieldLabel('Phone'),
                            const SizedBox(height: 8),
                            _GlassTextField(
                              controller: phoneController,
                              hintText: '+46 ...',
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 16),
                          ],
                          const _FieldLabel('Email'),
                          const SizedBox(height: 8),
                          _GlassTextField(
                            controller: emailController,
                            hintText: 'name@company.com',
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 16),
                          const _FieldLabel('Password'),
                          const SizedBox(height: 8),
                          _GlassTextField(
                            controller: passwordController,
                            hintText: 'Enter password',
                            obscureText: obscurePassword,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscurePassword = !obscurePassword;
                                });
                              },
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: JertColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (errorText != null) ...[
                      const SizedBox(height: 14),
                      Text(
                        errorText!,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    JertPrimaryButton(
                      text: loading
                          ? 'Submitting...'
                          : (isRegister ? 'Create Account' : 'Sign In'),
                      onPressed: loading ? null : _submit,
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: JertColors.textPrimary,
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.22),
                          ),
                          backgroundColor: Colors.white.withValues(alpha: 0.03),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed:
                            loading ? null : () => Navigator.of(context).pop(),
                        child: const Text(
                          'Back',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: JertColors.textPrimary,
        fontWeight: FontWeight.w700,
        fontSize: 14,
      ),
    );
  }
}

class _GlassTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;

  const _GlassTextField({
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: JertColors.textPrimary),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: JertColors.textMuted),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.04),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.12),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: JertColors.neonCyan,
            width: 1.2,
          ),
        ),
      ),
    );
  }
}
