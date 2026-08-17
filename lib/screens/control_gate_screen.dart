import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../theme.dart';
import 'control_panel_screen.dart';

/// بوابة كلمة المرور لرابط التحكم.
class ControlGateScreen extends StatefulWidget {
  const ControlGateScreen({super.key});

  @override
  State<ControlGateScreen> createState() => _ControlGateScreenState();
}

class _ControlGateScreenState extends State<ControlGateScreen> {
  bool _checking = true;
  bool _authed = false;
  bool _obscure = true;
  String? _error;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkStoredAuth();
  }

  Future<void> _checkStoredAuth() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _authed = prefs.getBool(kPrefsControlAuthedKey) ?? false;
      _checking = false;
    });
  }

  Future<void> _submit() async {
    if (_controller.text.trim() == kControlPassword) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(kPrefsControlAuthedKey, true);
      setState(() {
        _authed = true;
        _error = null;
      });
    } else {
      setState(() => _error = 'كلمة المرور غير صحيحة');
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kPrefsControlAuthedKey, false);
    setState(() => _authed = false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_authed) {
      return ControlPanelScreen(onLogout: _logout);
    }
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.outline),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.goldSoft,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.lock_rounded, color: AppColors.gold, size: 26),
                  ),
                  const SizedBox(height: 18),
                  Text('لوحة التحكم', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 6),
                  Text(
                    'أدخل كلمة المرور للمتابعة',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 22),
                  TextField(
                    controller: _controller,
                    obscureText: _obscure,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    onSubmitted: (_) => _submit(),
                    decoration: InputDecoration(
                      hintText: 'كلمة المرور',
                      errorText: _error,
                      suffixIcon: IconButton(
                        icon: Icon(_obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                            size: 20),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _submit,
                      child: const Text('دخول'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => context.go('/view'),
                    child: const Text('رجوع للعرض'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
