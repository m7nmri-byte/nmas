import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
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
      appBar: AppBar(
        title: const Text('دخول لوحة التحكم'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward),
          tooltip: 'رجوع للعرض',
          onPressed: () => context.go('/view'),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, size: 48),
                const SizedBox(height: 16),
                Text('هذه الصفحة تتطلب كلمة مرور التحكم',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center),
                const SizedBox(height: 16),
                TextField(
                  controller: _controller,
                  obscureText: _obscure,
                  autofocus: true,
                  onSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور',
                    errorText: _error,
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _submit,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('دخول'),
                    ),
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
