import 'dart:async';
import 'package:flutter/material.dart';

/// نص يعرض عداداً تنازلياً (أو "انتهى") مباشراً نحو [target].
class CountdownText extends StatefulWidget {
  final DateTime target;
  final TextStyle? style;
  final String finishedLabel;

  const CountdownText({
    super.key,
    required this.target,
    this.style,
    this.finishedLabel = '00:00:00',
  });

  @override
  State<CountdownText> createState() => _CountdownTextState();
}

class _CountdownTextState extends State<CountdownText> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final diff = widget.target.difference(DateTime.now());
    final text = diff.isNegative ? widget.finishedLabel : _format(diff);
    return Text(
      text,
      style: widget.style,
      textDirection: TextDirection.ltr,
    );
  }

  String _format(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    return '${two(h)}:${two(m)}:${two(s)}';
  }
}
